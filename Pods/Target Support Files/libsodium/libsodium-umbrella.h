#import <Cocoa/Cocoa.h>

#import "../crypto_auth/hmacsha256/cp/api.h"
#import "../crypto_auth/hmacsha512/cp/api.h"
#import "../crypto_auth/hmacsha512256/cp/api.h"
#import "../crypto_box/curve25519xsalsa20poly1305/ref/api.h"
#import "../crypto_core/hsalsa20/ref2/api.h"
#import "../crypto_core/salsa20/ref/api.h"
#import "../crypto_core/salsa2012/ref/api.h"
#import "../crypto_core/salsa208/ref/api.h"
#import "../crypto_generichash/blake2/ref/api.h"
#import "../crypto_generichash/blake2/ref/blake2-impl.h"
#import "../crypto_generichash/blake2/ref/blake2.h"
#import "../crypto_hash/sha256/cp/api.h"
#import "../crypto_hash/sha512/cp/api.h"
#import "../crypto_onetimeauth/poly1305/donna/poly1305_donna.h"
#import "../crypto_onetimeauth/poly1305/donna/poly1305_donna32.h"
#import "../crypto_onetimeauth/poly1305/donna/poly1305_donna64.h"
#import "../crypto_pwhash/scryptsalsa208sha256/crypto_scrypt.h"
#import "../crypto_pwhash/scryptsalsa208sha256/pbkdf2-sha256.h"
#import "../crypto_pwhash/scryptsalsa208sha256/sysendian.h"
#import "../crypto_scalarmult/curve25519/donna_c64/api.h"
#import "../crypto_scalarmult/curve25519/ref10/api.h"
#import "../crypto_scalarmult/curve25519/ref10/fe.h"
#import "../crypto_scalarmult/curve25519/ref10/montgomery.h"
#import "../crypto_scalarmult/curve25519/ref10/pow225521.h"
#import "../crypto_secretbox/xsalsa20poly1305/ref/api.h"
#import "../crypto_shorthash/siphash24/ref/api.h"
#import "../crypto_sign/ed25519/ref10/api.h"
#import "../crypto_sign/ed25519/ref10/base.h"
#import "../crypto_sign/ed25519/ref10/base2.h"
#import "../crypto_sign/ed25519/ref10/d.h"
#import "../crypto_sign/ed25519/ref10/d2.h"
#import "../crypto_sign/ed25519/ref10/fe.h"
#import "../crypto_sign/ed25519/ref10/ge.h"
#import "../crypto_sign/ed25519/ref10/ge_add.h"
#import "../crypto_sign/ed25519/ref10/ge_madd.h"
#import "../crypto_sign/ed25519/ref10/ge_msub.h"
#import "../crypto_sign/ed25519/ref10/ge_p2_dbl.h"
#import "../crypto_sign/ed25519/ref10/ge_sub.h"
#import "../crypto_sign/ed25519/ref10/pow22523.h"
#import "../crypto_sign/ed25519/ref10/pow225521.h"
#import "../crypto_sign/ed25519/ref10/sc.h"
#import "../crypto_sign/ed25519/ref10/sqrtm1.h"
#import "../crypto_sign/edwards25519sha512batch/ref/api.h"
#import "../crypto_sign/edwards25519sha512batch/ref/fe25519.h"
#import "../crypto_sign/edwards25519sha512batch/ref/ge25519.h"
#import "../crypto_sign/edwards25519sha512batch/ref/sc25519.h"
#import "../crypto_stream/aes128ctr/portable/api.h"
#import "../crypto_stream/aes128ctr/portable/common.h"
#import "../crypto_stream/aes128ctr/portable/consts.h"
#import "../crypto_stream/aes128ctr/portable/int128.h"
#import "../crypto_stream/aes128ctr/portable/types.h"
#import "../crypto_stream/chacha20/ref/api.h"
#import "../crypto_stream/salsa20/amd64_xmm6/api.h"
#import "../crypto_stream/salsa20/ref/api.h"
#import "../crypto_stream/salsa2012/ref/api.h"
#import "../crypto_stream/salsa208/ref/api.h"
#import "../crypto_stream/xsalsa20/ref/api.h"
#import "../crypto_verify/16/ref/api.h"
#import "../crypto_verify/32/ref/api.h"
#import "../crypto_verify/64/ref/api.h"
#import "sodium.h"
#import "sodium/core.h"
#import "sodium/crypto_aead_chacha20poly1305.h"
#import "sodium/crypto_auth.h"
#import "sodium/crypto_auth_hmacsha256.h"
#import "sodium/crypto_auth_hmacsha512.h"
#import "sodium/crypto_auth_hmacsha512256.h"
#import "sodium/crypto_box.h"
#import "sodium/crypto_box_curve25519xsalsa20poly1305.h"
#import "sodium/crypto_core_hsalsa20.h"
#import "sodium/crypto_core_salsa20.h"
#import "sodium/crypto_core_salsa2012.h"
#import "sodium/crypto_core_salsa208.h"
#import "sodium/crypto_generichash.h"
#import "sodium/crypto_generichash_blake2b.h"
#import "sodium/crypto_hash.h"
#import "sodium/crypto_hash_sha256.h"
#import "sodium/crypto_hash_sha512.h"
#import "sodium/crypto_int32.h"
#import "sodium/crypto_int64.h"
#import "sodium/crypto_onetimeauth.h"
#import "sodium/crypto_onetimeauth_poly1305.h"
#import "sodium/crypto_pwhash_scryptsalsa208sha256.h"
#import "sodium/crypto_scalarmult.h"
#import "sodium/crypto_scalarmult_curve25519.h"
#import "sodium/crypto_secretbox.h"
#import "sodium/crypto_secretbox_xsalsa20poly1305.h"
#import "sodium/crypto_shorthash.h"
#import "sodium/crypto_shorthash_siphash24.h"
#import "sodium/crypto_sign.h"
#import "sodium/crypto_sign_ed25519.h"
#import "sodium/crypto_sign_edwards25519sha512batch.h"
#import "sodium/crypto_stream.h"
#import "sodium/crypto_stream_aes128ctr.h"
#import "sodium/crypto_stream_chacha20.h"
#import "sodium/crypto_stream_salsa20.h"
#import "sodium/crypto_stream_salsa2012.h"
#import "sodium/crypto_stream_salsa208.h"
#import "sodium/crypto_stream_xsalsa20.h"
#import "sodium/crypto_uint16.h"
#import "sodium/crypto_uint32.h"
#import "sodium/crypto_uint64.h"
#import "sodium/crypto_uint8.h"
#import "sodium/crypto_verify_16.h"
#import "sodium/crypto_verify_32.h"
#import "sodium/crypto_verify_64.h"
#import "sodium/export.h"
#import "sodium/randombytes.h"
#import "sodium/randombytes_salsa20_random.h"
#import "sodium/randombytes_sysrandom.h"
#import "sodium/runtime.h"
#import "sodium/utils.h"
#import "sodium/version.h"

FOUNDATION_EXPORT double libsodiumVersionNumber;
FOUNDATION_EXPORT const unsigned char libsodiumVersionString[];
