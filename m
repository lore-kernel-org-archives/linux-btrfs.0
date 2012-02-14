From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH 1/3] Add the snappy-c compressor to lib v2
Date: Mon, 13 Feb 2012 22:29:41 -0600
Message-ID: <CAKcLGm8u9oKEBjFW3VpLZDUd=56mRRrr-_zjf-M7Hf5NpTTM8Q@mail.gmail.com>
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
	<1326414530-10789-2-git-send-email-andi@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1326414530-10789-2-git-send-email-andi@firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 12, 2012 at 6:28 PM, Andi Kleen <andi@firstfloor.org> wrote=
:
> From: Andi Kleen <ak@linux.intel.com>
>
> This is a C port of the google snappy compressor. It has roughly
> comparable compression to LZO, but is significantly faster on many fi=
le
> types. For example it beats all other compressors on already
> compressed data.
>
> I ported the original C++ code over to C and did some changes
> to make it better fit into the kernel. It preallocates the worst
> case memory consumption now. While the code being larger
> than lzo it is still reasonable (about 5K on x86).
>
> Decompression needs very little memory, Compression
> currently 192K on 64bit and 128K on 32bit. For comparison
> LZO compression needs 128K on 64bit and 64K on 32bit.
>
> [This could be lowered significantly by not preallocating
> for most use cases, typically the footprint is much lower.
> The original C++ version only allocated most of this
> when (rarely) needed, but this is more problematic in the kernel]
>
> There are some minor divergences from the Linux coding standards:
> in particular I kept the C++/C99 style mixed statement/declarations.
> This was mainly to not diverge too much from the reference C++
> source, so that improvements from there can be easily ported.
> There are some other left overs from the google style, but very
> little now.
>
> Performance:
>
> The compressor performs best on 64bit-LE systems,
> but is also quite good on 32bit. I haven't tested BE, but
> I don't expect that to add a lot of overhead.
>
> Here is some performance data (32bit, Nehalem):
> c/b =3D cycles/byte; lower numbers are better.
>
> x86-64 executable: (compression minimally slower than qlz, but
> much better at decompression, lzo is left in the dust):
>
> snappy: emacs-gtk: 11007968 b: ratio 0.38: comp 8.13 uncomp 2.65 c/b
> lzo =A0 : emacs-gtk: 11007968 b: ratio 0.33: comp 12.74 uncomp 4.70 c=
/b
> zlib1 : emacs-gtk: 11007968 b: ratio 0.27: comp 49.96 uncomp 13.14 c/=
b
> zlib3 : emacs-gtk: 11007968 b: ratio 0.26: comp 64.17 uncomp 12.33 c/=
b
> lzf =A0 : emacs-gtk: 11007968 b: ratio 0.37: comp 9.85 uncomp 4.33 c/=
b
> qlz =A0 : emacs-gtk: 11007968 b: ratio 0.34: comp 7.51 uncomp 6.28 c/=
b
> fastlz: emacs-gtk: 11007968 b: ratio 0.37: comp 10.73 uncomp 4.97 c/b
>
> Compressed data (beats everything else):
>
> snappy: udev-151.tar.gz: 634842 b: ratio 1.00: comp 0.99 uncomp 0.33 =
c/b
> lzo =A0 : udev-151.tar.gz: 634842 b: ratio 1.00: comp 41.44 uncomp 0.=
66 c/b
> zlib1 : udev-151.tar.gz: 634842 b: ratio 1.00: comp 116.99 uncomp 3.9=
4 c/b
> zlib3 : udev-151.tar.gz: 634842 b: ratio 1.00: comp 117.68 uncomp 3.9=
4 c/b
> lzf =A0 : udev-151.tar.gz: 634842 b: ratio 1.03: comp 16.32 uncomp 1.=
14 c/b
> qlz =A0 : udev-151.tar.gz: 634842 b: ratio 1.00: comp 10.42 uncomp 0.=
42 c/b
> fastlz: udev-151.tar.gz: 634842 b: ratio 1.03: comp 19.35 uncomp 2.07=
 c/b
>
> Text file (compression somewhat slower than qlz, but decompression
> much better, lzo is much worse):
>
> snappy: manual.txt: 445343 b: ratio 0.47: comp 12.01 uncomp 3.12 c/b
> lzo =A0 : manual.txt: 445343 b: ratio 0.44: comp 16.32 uncomp 7.53 c/=
b
> zlib1 : manual.txt: 445343 b: ratio 0.35: comp 56.37 uncomp 15.59 c/b
> zlib3 : manual.txt: 445343 b: ratio 0.31: comp 73.45 uncomp 13.99 c/b
> lzf =A0 : manual.txt: 445343 b: ratio 0.46: comp 13.43 uncomp 5.47 c/=
b
> qlz =A0 : manual.txt: 445343 b: ratio 0.44: comp 9.16 uncomp 8.19 c/b
> fastlz: manual.txt: 445343 b: ratio 0.46: comp 14.22 uncomp 7.28 c/b
>
> As you can see snappy is a good all-around compressor.
>
> On 64bit the compression is even faster and beats everything else eas=
ily:
>
> snappy: emacs-gtk: 11007968 b: ratio 0.38: comp 4.90 uncomp 2.65 c/b
> lzo =A0 : emacs-gtk: 11007968 b: ratio 0.33: comp 11.24 uncomp 4.46 c=
/b
> zlib1 : emacs-gtk: 11007968 b: ratio 0.27: comp 41.67 uncomp 11.13 c/=
b
> zlib3 : emacs-gtk: 11007968 b: ratio 0.26: comp 51.80 uncomp 10.54 c/=
b
> lzf =A0 : emacs-gtk: 11007968 b: ratio 0.37: comp 8.79 uncomp 4.05 c/=
b
> qlz =A0 : emacs-gtk: 11007968 b: ratio 0.34: comp 5.44 uncomp 5.46 c/=
b
> fastlz: emacs-gtk: 11007968 b: ratio 0.37: comp 9.91 uncomp 4.77 c/b
>
> On 64bit it's now nearly as fast as qlz on the text file too:
>
> snappy: manual.txt: 445343 b: ratio 0.47: comp 7.79 uncomp 3.47 c/b
> lzo =A0 : manual.txt: 445343 b: ratio 0.44: comp 15.46 uncomp 7.27 c/=
b
> zlib1 : manual.txt: 445343 b: ratio 0.35: comp 45.79 uncomp 12.78 c/b
> zlib3 : manual.txt: 445343 b: ratio 0.31: comp 60.52 uncomp 11.72 c/b
> lzf =A0 : manual.txt: 445343 b: ratio 0.46: comp 12.62 uncomp 5.30 c/=
b
> qlz =A0 : manual.txt: 445343 b: ratio 0.44: comp 6.81 uncomp 7.65 c/b
> fastlz: manual.txt: 445343 b: ratio 0.46: comp 13.75 uncomp 6.52 c/b
>
> Overall it's a good alternative to lzo, with the only
> drawback being the somewhat higher memory use.
>
> v2: Some minor performance improvements and cleanups.
> 32bit compression should be a few percent faster now.
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
> =A0include/linux/snappy.h | =A0 26 +
> =A0lib/Kconfig =A0 =A0 =A0 =A0 =A0 =A0| =A0 =A06 +
> =A0lib/Makefile =A0 =A0 =A0 =A0 =A0 | =A0 =A04 +
> =A0lib/snappy.c =A0 =A0 =A0 =A0 =A0 | 1300 ++++++++++++++++++++++++++=
++++++++++++++++++++++
> =A04 files changed, 1336 insertions(+), 0 deletions(-)
> =A0create mode 100644 include/linux/snappy.h
> =A0create mode 100644 lib/snappy.c
>
> diff --git a/include/linux/snappy.h b/include/linux/snappy.h
> new file mode 100644
> index 0000000..4119803
> --- /dev/null
> +++ b/include/linux/snappy.h
> @@ -0,0 +1,26 @@
> +#ifndef _LINUX_SNAPPY_H
> +#define _LINUX_SNAPPY_H 1
> +
> +#include <linux/types.h>
> +
> +/* Only needed for compression. This preallocates the worst case */
> +struct snappy_env {
> + =A0 =A0 =A0 u16 *hash_table;
> + =A0 =A0 =A0 void *scratch;
> + =A0 =A0 =A0 void *scratch_output;
> +};
> +
> +int snappy_init_env(struct snappy_env *env);
> +void snappy_free_env(struct snappy_env *env);
> +bool snappy_uncompress(const char *compressed, size_t n, char *uncom=
pressed);
> +int snappy_compress(struct snappy_env *env,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *input,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t input_length,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *compressed,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t *compressed_length);
> +bool snappy_uncompressed_length(const char *buf, size_t len, size_t =
*result);
> +size_t snappy_max_compressed_length(size_t source_len);
> +
> +
> +
> +#endif
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 201e1b3..719e4f2 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -310,4 +310,10 @@ config DIGSIG
> =A0 =A0 =A0 =A0 =A0Digital signature verification. Currently only RSA=
 is supported.
> =A0 =A0 =A0 =A0 =A0Implementation is done using GnuPG MPI library
>
> +config SNAPPY
> + =A0 =A0 =A0 tristate "Snappy compressor"
> + =A0 =A0 =A0 help
> + =A0 =A0 =A0 =A0 =A0Add the snappy compressor. This is a reasonable =
compressor that
> + =A0 =A0 =A0 =A0 compresses and decompresses extremly fast.
> +
> =A0endmenu
> diff --git a/lib/Makefile b/lib/Makefile
> index dace162..2f5f86a 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -121,6 +121,10 @@ obj-$(CONFIG_DQL) +=3D dynamic_queue_limits.o
> =A0obj-$(CONFIG_MPILIB) +=3D mpi/
> =A0obj-$(CONFIG_DIGSIG) +=3D digsig.o
>
> +CFLAGS_snappy.o +=3D $(call cc-disable-warning, declaration-after-st=
atement) \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0-DNDEBUG=3D1
> +obj-$(CONFIG_SNAPPY) +=3D snappy.o
> +
> =A0hostprogs-y =A0 =A0:=3D gen_crc32table
> =A0clean-files =A0 =A0:=3D crc32table.h
>
> diff --git a/lib/snappy.c b/lib/snappy.c
> new file mode 100644
> index 0000000..0b39e07
> --- /dev/null
> +++ b/lib/snappy.c
> @@ -0,0 +1,1300 @@
> +/*
> + * C port of the snappy compressor from Google.
> + * This is a very fast compressor with comparable compression to lzo=
=2E
> + * Works best on 64bit little-endian, but should be good on others t=
oo.
> + * Ported by Andi Kleen.
> + * Based on snappy 1.0.3 plus some selected changes from SVN.
> + */
> +
> +/*
> + * Copyright 2005 Google Inc. All Rights Reserved.
> + *
> + * Redistribution and use in source and binary forms, with or withou=
t
> + * modification, are permitted provided that the following condition=
s are
> + * met:
> + *
> + * =A0 =A0 * Redistributions of source code must retain the above co=
pyright
> + * notice, this list of conditions and the following disclaimer.
> + * =A0 =A0 * Redistributions in binary form must reproduce the above
> + * copyright notice, this list of conditions and the following discl=
aimer
> + * in the documentation and/or other materials provided with the
> + * distribution.
> + * =A0 =A0 * Neither the name of Google Inc. nor the names of its
> + * contributors may be used to endorse or promote products derived f=
rom
> + * this software without specific prior written permission.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTO=
RS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS=
 FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRI=
GHT
> + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDEN=
TAL,
> + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF =
USE,
> + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON=
 ANY
> + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TO=
RT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE=
 USE
> + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMA=
GE.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/snappy.h>
> +#include <asm/unaligned.h>
> +
> +#define CRASH_UNLESS(x) BUG_ON(!(x))
> +#define CHECK(cond) CRASH_UNLESS(cond)
> +#define CHECK_LE(a, b) CRASH_UNLESS((a) <=3D (b))
> +#define CHECK_GE(a, b) CRASH_UNLESS((a) >=3D (b))
> +#define CHECK_EQ(a, b) CRASH_UNLESS((a) =3D=3D (b))
> +#define CHECK_NE(a, b) CRASH_UNLESS((a) !=3D (b))
> +#define CHECK_LT(a, b) CRASH_UNLESS((a) < (b))
> +#define CHECK_GT(a, b) CRASH_UNLESS((a) > (b))
> +
> +#define UNALIGNED_LOAD16(_p) get_unaligned((u16 *)(_p))
> +#define UNALIGNED_LOAD32(_p) get_unaligned((u32 *)(_p))
> +#define UNALIGNED_LOAD64(_p) get_unaligned((u64 *)(_p))
> +
> +#define UNALIGNED_STORE16(_p, _val) put_unaligned(_val, (u16 *)(_p))
> +#define UNALIGNED_STORE32(_p, _val) put_unaligned(_val, (u32 *)(_p))
> +#define UNALIGNED_STORE64(_p, _val) put_unaligned(_val, (u64 *)(_p))
> +
> +#ifdef NDEBUG
> +
> +#define DCHECK(cond) do {} while(0)
> +#define DCHECK_LE(a, b) do {} while(0)
> +#define DCHECK_GE(a, b) do {} while(0)
> +#define DCHECK_EQ(a, b) do {} while(0)
> +#define DCHECK_NE(a, b) do {} while(0)
> +#define DCHECK_LT(a, b) do {} while(0)
> +#define DCHECK_GT(a, b) do {} while(0)
> +
> +#else
> +
> +#define DCHECK(cond) CHECK(cond)
> +#define DCHECK_LE(a, b) CHECK_LE(a, b)
> +#define DCHECK_GE(a, b) CHECK_GE(a, b)
> +#define DCHECK_EQ(a, b) CHECK_EQ(a, b)
> +#define DCHECK_NE(a, b) CHECK_NE(a, b)
> +#define DCHECK_LT(a, b) CHECK_LT(a, b)
> +#define DCHECK_GT(a, b) CHECK_GT(a, b)
> +
> +#endif
> +
> +static inline bool is_little_endian(void)
> +{
> +#ifdef __LITTLE_ENDIAN__
> + =A0 =A0 =A0 return true;
> +#endif
> + =A0 =A0 =A0 return false;
> +}
> +
> +static inline int log2_floor(u32 n)
> +{
> + =A0 =A0 =A0 return n =3D=3D 0 ? -1 : 31 ^ __builtin_clz(n);
> +}
> +
> +static inline int find_lsb_set_non_zero(u32 n)
> +{
> + =A0 =A0 =A0 return __builtin_ctz(n);
> +}
> +
> +static inline int find_lsb_set_non_zero64(u64 n)
> +{
> + =A0 =A0 =A0 if (sizeof(long) =3D=3D 4) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (n & 0xffffffff)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return __builtin_ctz(n =
& 0xffffffff);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 32 + __builtin_ctz(n >> 32);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return __builtin_ctzll(n);
> +}
> +
> +#define kmax32 5
> +
> +/*
> + * Attempts to parse a varint32 from a prefix of the bytes in [ptr,l=
imit-1].
> + * =A0Never reads a character at or beyond limit. =A0If a valid/term=
inated varint32
> + * was found in the range, stores it in *OUTPUT and returns a pointe=
r just
> + * past the last byte of the varint32. Else returns NULL. =A0On succ=
ess,
> + * "result <=3D limit".
> + */
> +static inline const char *varint_parse32_with_limit(const char *p,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *l,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 * OUTPUT)
> +{
> + =A0 =A0 =A0 const unsigned char *ptr =3D (const unsigned char *)(p)=
;
> + =A0 =A0 =A0 const unsigned char *limit =3D (const unsigned char *)(=
l);
> + =A0 =A0 =A0 u32 b, result;
> +
> + =A0 =A0 =A0 if (ptr >=3D limit)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> + =A0 =A0 =A0 b =3D *(ptr++);
> + =A0 =A0 =A0 result =3D b & 127;
> + =A0 =A0 =A0 if (b < 128)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto done;
> + =A0 =A0 =A0 if (ptr >=3D limit)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> + =A0 =A0 =A0 b =3D *(ptr++);
> + =A0 =A0 =A0 result |=3D (b & 127) << 7;
> + =A0 =A0 =A0 if (b < 128)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto done;
> + =A0 =A0 =A0 if (ptr >=3D limit)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> + =A0 =A0 =A0 b =3D *(ptr++);
> + =A0 =A0 =A0 result |=3D (b & 127) << 14;
> + =A0 =A0 =A0 if (b < 128)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto done;
> + =A0 =A0 =A0 if (ptr >=3D limit)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> + =A0 =A0 =A0 b =3D *(ptr++);
> + =A0 =A0 =A0 result |=3D (b & 127) << 21;
> + =A0 =A0 =A0 if (b < 128)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto done;
> + =A0 =A0 =A0 if (ptr >=3D limit)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
> + =A0 =A0 =A0 b =3D *(ptr++);
> + =A0 =A0 =A0 result |=3D (b & 127) << 28;
> + =A0 =A0 =A0 if (b < 16)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto done;
> + =A0 =A0 =A0 return NULL; =A0 =A0 =A0 =A0 =A0 =A0/* Value is too lon=
g to be a varint32 */
> +done:
> + =A0 =A0 =A0 *OUTPUT =3D result;
> + =A0 =A0 =A0 return (const char *)(ptr);
> +}
> +
> +/*
> + * REQUIRES =A0 "ptr" points to a buffer of length sufficient to hol=
d "v".
> + * =A0EFFECTS =A0 =A0Encodes "v" into "ptr" and returns a pointer to=
 the
> + * =A0 =A0 =A0 =A0 =A0 =A0byte just past the last encoded byte.
> + */
> +static inline char *varint_encode32(char *sptr, u32 v)
> +{
> + =A0 =A0 =A0 /* Operate on characters as unsigneds */
> + =A0 =A0 =A0 unsigned char *ptr =3D (unsigned char *)(sptr);
> + =A0 =A0 =A0 static const int B =3D 128;
> +
> + =A0 =A0 =A0 if (v < (1 << 7)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(ptr++) =3D v;
> + =A0 =A0 =A0 } else if (v < (1 << 14)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(ptr++) =3D v | B;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(ptr++) =3D v >> 7;
> + =A0 =A0 =A0 } else if (v < (1 << 21)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(ptr++) =3D v | B;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(ptr++) =3D (v >> 7) | B;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(ptr++) =3D v >> 14;
> + =A0 =A0 =A0 } else if (v < (1 << 28)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(ptr++) =3D v | B;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(ptr++) =3D (v >> 7) | B;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(ptr++) =3D (v >> 14) | B;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(ptr++) =3D v >> 21;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(ptr++) =3D v | B;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(ptr++) =3D (v >> 7) | B;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(ptr++) =3D (v >> 14) | B;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(ptr++) =3D (v >> 21) | B;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(ptr++) =3D v >> 28;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return (char *)(ptr);
> +}
> +
> +struct source {
> + =A0 =A0 =A0 const char *ptr;
> + =A0 =A0 =A0 size_t left;
> +};
> +
> +static inline int available(struct source *s)
> +{
> + =A0 =A0 =A0 return s->left;
> +}
> +
> +static inline const char *peek(struct source *s, size_t * len)
> +{
> + =A0 =A0 =A0 *len =3D s->left;
> + =A0 =A0 =A0 return s->ptr;
> +}
> +
> +static inline void skip(struct source *s, size_t n)
> +{
> + =A0 =A0 =A0 s->left -=3D n;
> + =A0 =A0 =A0 s->ptr +=3D n;
> +}
> +
> +struct sink {
> + =A0 =A0 =A0 char *dest;
> +};
> +
> +static inline void append(struct sink *s, const char *data, size_t n=
)
> +{
> + =A0 =A0 =A0 if (data !=3D s->dest)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(s->dest, data, n);
> + =A0 =A0 =A0 s->dest +=3D n;
> +}
> +
> +static inline void *sink_peek(struct sink *s, size_t n)
> +{
> + =A0 =A0 =A0 return s->dest;
> +}
> +
> +struct writer {
> + =A0 =A0 =A0 char *base;
> + =A0 =A0 =A0 char *op;
> + =A0 =A0 =A0 char *op_limit;
> +};
> +
> +/* Called before decompression */
> +static inline void writer_set_expected_length(struct writer *w, size=
_t len)
> +{
> + =A0 =A0 =A0 w->op_limit =3D w->op + len;
> +}
> +
> +/* Called after decompression */
> +static inline bool writer_check_length(struct writer *w)
> +{
> + =A0 =A0 =A0 return w->op =3D=3D w->op_limit;
> +}
> +
> +/*
> + * Copy "len" bytes from "src" to "op", one byte at a time. =A0Used =
for
> + * =A0handling COPY operations where the input and output regions ma=
y
> + * overlap. =A0For example, suppose:
> + * =A0 =A0src =A0 =A0=3D=3D "ab"
> + * =A0 =A0op =A0 =A0 =3D=3D src + 2
> + * =A0 =A0len =A0 =A0=3D=3D 20
> + * After IncrementalCopy(src, op, len), the result will have
> + * eleven copies of "ab"
> + * =A0 =A0ababababababababababab
> + * Note that this does not match the semantics of either memcpy()
> + * or memmove().
> + */
> +static inline void incremental_copy(const char *src, char *op, int l=
en)
> +{
> + =A0 =A0 =A0 DCHECK_GT(len, 0);
> + =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *op++ =3D *src++;
> + =A0 =A0 =A0 } while (--len > 0);
> +}
> +
> +/*
> + * Equivalent to IncrementalCopy except that it can write up to ten =
extra
> + * =A0bytes after the end of the copy, and that it is faster.
> + *
> + * The main part of this loop is a simple copy of eight bytes at a t=
ime until
> + * we've copied (at least) the requested amount of bytes. =A0However=
, if op and
> + * src are less than eight bytes apart (indicating a repeating patte=
rn of
> + * length < 8), we first need to expand the pattern in order to get =
the correct
> + * results. For instance, if the buffer looks like this, with the ei=
ght-byte
> + * <src> and <op> patterns marked as intervals:
> + *
> + * =A0 =A0abxxxxxxxxxxxx
> + * =A0 =A0[------] =A0 =A0 =A0 =A0 =A0 src
> + * =A0 =A0 =A0[------] =A0 =A0 =A0 =A0 op
> + *
> + * a single eight-byte copy from <src> to <op> will repeat the patte=
rn once,
> + * after which we can move <op> two bytes without moving <src>:
> + *
> + * =A0 =A0ababxxxxxxxxxx
> + * =A0 =A0[------] =A0 =A0 =A0 =A0 =A0 src
> + * =A0 =A0 =A0 =A0[------] =A0 =A0 =A0 op
> + *
> + * and repeat the exercise until the two no longer overlap.
> + *
> + * This allows us to do very well in the special case of one single =
byte
> + * repeated many times, without taking a big hit for more general ca=
ses.
> + *
> + * The worst case of extra writing past the end of the match occurs =
when
> + * op - src =3D=3D 1 and len =3D=3D 1; the last copy will read from =
byte positions
> + * [0..7] and write to [4..11], whereas it was only supposed to writ=
e to
> + * position 1. Thus, ten excess bytes.
> + */
> +
> +#define kmax_increment_copy_overflow =A010
> +
> +static inline void incremental_copy_fast_path(const char *src, char =
*op,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 int len)
> +{
> + =A0 =A0 =A0 while (op - src < 8) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 UNALIGNED_STORE64(op, UNALIGNED_LOAD64(=
src));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len -=3D op - src;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 op +=3D op - src;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 while (len > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 UNALIGNED_STORE64(op, UNALIGNED_LOAD64(=
src));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 src +=3D 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 op +=3D 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len -=3D 8;
> + =A0 =A0 =A0 }
> +}
> +
> +static inline bool writer_append_from_self(struct writer *w, u32 off=
set,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0u32 len)
> +{
> + =A0 =A0 =A0 char *op =3D w->op;
> + =A0 =A0 =A0 const int space_left =3D w->op_limit - op;
> +
> + =A0 =A0 =A0 if (op - w->base <=3D offset - 1u) =A0 =A0 =A0 =A0/* -1=
u catches offset=3D=3D0 */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
> + =A0 =A0 =A0 if (len <=3D 16 && offset >=3D 8 && space_left >=3D 16)=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Fast path, used for the majority (70=
-80%) of dynamic
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* invocations. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 UNALIGNED_STORE64(op, UNALIGNED_LOAD64(=
op - offset));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 UNALIGNED_STORE64(op + 8, UNALIGNED_LOA=
D64(op - offset + 8));
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (space_left >=3D len + kmax_incremen=
t_copy_overflow) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 incremental_copy_fast_p=
ath(op - offset, op, len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (space_left < len) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 incremental_copy(op - o=
ffset, op, len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 w->op =3D op + len;
> + =A0 =A0 =A0 return true;
> +}
> +
> +static inline bool writer_append(struct writer *w, const char *ip, u=
32 len,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bool=
 allow_fast_path)
> +{
> + =A0 =A0 =A0 char *op =3D w->op;
> + =A0 =A0 =A0 const int space_left =3D w->op_limit - op;
> + =A0 =A0 =A0 if (allow_fast_path && len <=3D 16 && space_left >=3D 1=
6) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Fast path, used for the majority (ab=
out 90%) of dynamic
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* invocations. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 UNALIGNED_STORE64(op, UNALIGNED_LOAD64(=
ip));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 UNALIGNED_STORE64(op + 8, UNALIGNED_LOA=
D64(ip + 8));
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (space_left < len)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(op, ip, len);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 w->op =3D op + len;
> + =A0 =A0 =A0 return true;
> +}
> +
> +/*
> + * Any hash function will produce a valid compressed bitstream, but =
a good
> + * hash function reduces the number of collisions and thus yields be=
tter
> + * compression for compressible input, and more speed for incompress=
ible
> + * input. Of course, it doesn't hurt if the hash function is reasona=
bly fast
> + * either, as it gets called a lot.
> + */
> +static inline u32 hash_bytes(u32 bytes, int shift)
> +{
> + =A0 =A0 =A0 u32 kmul =3D 0x1e35a7bd;
> + =A0 =A0 =A0 return (bytes * kmul) >> shift;
> +}
> +
> +static inline u32 hash(const char *p, int shift)
> +{
> + =A0 =A0 =A0 return hash_bytes(UNALIGNED_LOAD32(p), shift);
> +}
> +
> +/*
> + * Compressed data can be defined as:
> + * =A0 =A0compressed :=3D item* literal*
> + * =A0 =A0item =A0 =A0 =A0 :=3D literal* copy
> + *
> + * The trailing literal sequence has a space blowup of at most 62/60
> + * since a literal of length 60 needs one tag byte + one extra byte
> + * for length information.
> + *
> + * Item blowup is trickier to measure. =A0Suppose the "copy" op copi=
es
> + * 4 bytes of data. =A0Because of a special check in the encoding co=
de,
> + * we produce a 4-byte copy only if the offset is < 65536. =A0Theref=
ore
> + * the copy op takes 3 bytes to encode, and this type of item leads
> + * to at most the 62/60 blowup for representing literals.
> + *
> + * Suppose the "copy" op copies 5 bytes of data. =A0If the offset is=
 big
> + * enough, it will take 5 bytes to encode the copy op. =A0Therefore =
the
> + * worst case here is a one-byte literal followed by a five-byte cop=
y.
> + * I.e., 6 bytes of input turn into 7 bytes of "compressed" data.
> + *
> + * This last factor dominates the blowup, so the final estimate is:
> + */
> +size_t snappy_max_compressed_length(size_t source_len)
> +{
> + =A0 =A0 =A0 return 32 + source_len + source_len / 6;
> +}
> +EXPORT_SYMBOL(snappy_max_compressed_length);
> +
> +enum {
> + =A0 =A0 =A0 LITERAL =3D 0,
> + =A0 =A0 =A0 COPY_1_BYTE_OFFSET =3D 1, /* 3 bit length + 3 bits of o=
ffset in opcode */
> + =A0 =A0 =A0 COPY_2_BYTE_OFFSET =3D 2,
> + =A0 =A0 =A0 COPY_4_BYTE_OFFSET =3D 3
> +};
> +
> +static inline char *emit_literal(char *op,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cons=
t char *literal,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int =
len, bool allow_fast_path)
> +{
> + =A0 =A0 =A0 int n =3D len - 1; =A0 =A0 =A0 =A0/* Zero-length litera=
ls are disallowed */
> +
> + =A0 =A0 =A0 if (n < 60) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Fits in tag byte */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *op++ =3D LITERAL | (n << 2);
> +
> +/*
> + * The vast majority of copies are below 16 bytes, for which a
> + * call to memcpy is overkill. This fast path can sometimes
> + * copy up to 15 bytes too much, but that is okay in the
> + * main loop, since we have a bit to go on for both sides:
> + *
> + * =A0 - The input will always have kInputMarginBytes =3D 15 extra
> + * =A0 =A0 available bytes, as long as we're in the main loop, and
> + * =A0 =A0 if not, allow_fast_path =3D false.
> + * =A0 - The output will always have 32 spare bytes (see
> + * =A0 =A0 MaxCompressedLength).
> + */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (allow_fast_path && len <=3D 16) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UNALIGNED_STORE64(op, U=
NALIGNED_LOAD64(literal));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UNALIGNED_STORE64(op + =
8,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 UNALIGNED_LOAD64(literal + 8));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return op + len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Encode in upcoming bytes */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *base =3D op;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int count =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 op++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (n > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *op++ =3D n & 0xff;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 n >>=3D 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 count++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DCHECK(count >=3D 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DCHECK(count <=3D 4);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *base =3D LITERAL | ((59 + count) << 2)=
;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 memcpy(op, literal, len);
> + =A0 =A0 =A0 return op + len;
> +}
> +
> +static inline char *emit_copy_less_than64(char *op, int offset, int =
len)
> +{
> + =A0 =A0 =A0 DCHECK_LE(len, 64);
> + =A0 =A0 =A0 DCHECK_GE(len, 4);
> + =A0 =A0 =A0 DCHECK_LT(offset, 65536);
> +
> + =A0 =A0 =A0 if ((len < 12) && (offset < 2048)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int len_minus_4 =3D len - 4;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DCHECK(len_minus_4 < 8); =A0 =A0 =A0 =A0=
/* Must fit in 3 bits */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *op++ =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 COPY_1_BYTE_OFFSET | ((len_minu=
s_4) << 2) | ((offset >> 8)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0<< 5);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *op++ =3D offset & 0xff;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *op++ =3D COPY_2_BYTE_OFFSET | ((len - =
1) << 2);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 put_unaligned_le16(offset, op);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 op +=3D 2;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return op;
> +}
> +
> +static inline char *emit_copy(char *op, int offset, int len)
> +{
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Emit 64 byte copies but make sure to keep at least=
 four bytes
> + =A0 =A0 =A0 =A0* reserved
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 while (len >=3D 68) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 op =3D emit_copy_less_than64(op, offset=
, 64);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len -=3D 64;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Emit an extra 60 byte copy if have too much data t=
o fit in
> + =A0 =A0 =A0 =A0* one copy
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (len > 64) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 op =3D emit_copy_less_than64(op, offset=
, 60);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 len -=3D 60;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Emit remainder */
> + =A0 =A0 =A0 op =3D emit_copy_less_than64(op, offset, len);
> + =A0 =A0 =A0 return op;
> +}
> +
> +/**
> + * snappy_uncompressed_length - return length of uncompressed output=
=2E
> + * @start: compressed buffer
> + * @n: length of compressed buffer.
> + * @result: Write the length of the uncompressed output here.
> + *
> + * Returns true when successfull, otherwise false.
> + */
> +bool snappy_uncompressed_length(const char *start, size_t n, size_t =
* result)
> +{
> + =A0 =A0 =A0 u32 v =3D 0;
> + =A0 =A0 =A0 const char *limit =3D start + n;
> + =A0 =A0 =A0 if (varint_parse32_with_limit(start, limit, &v) !=3D NU=
LL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *result =3D v;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
> + =A0 =A0 =A0 }
> +}
> +EXPORT_SYMBOL(snappy_uncompressed_length);
> +
> +#define kblock_log 15
> +#define kblock_size (1 << kblock_log)
> +
> +#define kmax_hash_table_bits 14
> +#define kmax_hash_table_size (1 << kmax_hash_table_bits)
> +
> +/*
> + * Use smaller hash table when input.size() is smaller, since we
> + * fill the table, incurring O(hash table size) overhead for
> + * compression, and if the input is short, we won't need that
> + * many hash table entries anyway.
> + */
> +static u16 *get_hash_table(struct snappy_env *env, size_t input_size=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int *table_=
size)
> +{
> + =A0 =A0 =A0 int htsize =3D 256;
> +
> + =A0 =A0 =A0 DCHECK(kmax_hash_table_size >=3D 256);
> + =A0 =A0 =A0 while (htsize < kmax_hash_table_size && htsize < input_=
size)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 htsize <<=3D 1;
> + =A0 =A0 =A0 CHECK_EQ(0, htsize & (htsize - 1));
> + =A0 =A0 =A0 CHECK_LE(htsize, kmax_hash_table_size);
> +
> + =A0 =A0 =A0 u16 *table;
> + =A0 =A0 =A0 table =3D env->hash_table;
> +
> + =A0 =A0 =A0 *table_size =3D htsize;
> + =A0 =A0 =A0 memset(table, 0, htsize * sizeof(*table));
> + =A0 =A0 =A0 return table;
> +}
> +
> +/*
> + * Return the largest n such that
> + *
> + * =A0 s1[0,n-1] =3D=3D s2[0,n-1]
> + * =A0 and n <=3D (s2_limit - s2).
> + *
> + * Does not read *s2_limit or beyond.
> + * Does not read *(s1 + (s2_limit - s2)) or beyond.
> + * Requires that s2_limit >=3D s2.
> + *
> + * Separate implementation for x86_64, for speed. =A0Uses the fact t=
hat
> + * x86_64 is little endian.
> + */
> +#if defined(__LITTLE_ENDIAN__)
> +static inline int find_match_length(const char *s1,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 const char *s2, const char *s2_limit)
> +{
> + =A0 =A0 =A0 int matched =3D 0;
> +
> + =A0 =A0 =A0 DCHECK_GE(s2_limit, s2);
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Find out how long the match is. We loop over the d=
ata 64 bits at a
> + =A0 =A0 =A0 =A0* time until we find a 64-bit block that doesn't mat=
ch; then we find
> + =A0 =A0 =A0 =A0* the first non-matching bit and use that to calcula=
te the total
> + =A0 =A0 =A0 =A0* length of the match.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 while (likely(s2 <=3D s2_limit - 8)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (UNALIGNED_LOAD64(s2) =3D=3D UN=
ALIGNED_LOAD64(s1 + matched))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s2 +=3D 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 matched +=3D 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* On current (mid-20=
08) Opteron models there
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* is a 3% more effic=
ient code sequence to
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* find the first non=
-matching byte. =A0However,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* what follows is ~1=
0% better on Intel Core 2
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* and newer, and we =
expect AMD's bsf
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* instruction to imp=
rove.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 x =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UNALIGNED_LOAD6=
4(s2) ^ UNALIGNED_LOAD64(s1 +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 matche=
d);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int matching_bits =3D f=
ind_lsb_set_non_zero64(x);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 matched +=3D matching_b=
its >> 3;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return matched;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 while (likely(s2 < s2_limit)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (likely(s1[matched] =3D=3D *s2)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++s2;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++matched;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return matched;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return matched;
> +}
> +#else
> +static inline int find_match_length(const char *s1,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 const char *s2, const char *s2_limit)
> +{
> + =A0 =A0 =A0 /* Implementation based on the x86-64 version, above. *=
/
> + =A0 =A0 =A0 DCHECK_GE(s2_limit, s2);
> + =A0 =A0 =A0 int matched =3D 0;
> +
> + =A0 =A0 =A0 while (s2 <=3D s2_limit - 4 &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0UNALIGNED_LOAD32(s2) =3D=3D UNALIGNED_LO=
AD32(s1 + matched)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 s2 +=3D 4;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 matched +=3D 4;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (is_little_endian() && s2 <=3D s2_limit - 4) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 x =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UNALIGNED_LOAD32(s2) ^ UNALIGNE=
D_LOAD32(s1 + matched);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int matching_bits =3D find_lsb_set_non_=
zero(x);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 matched +=3D matching_bits >> 3;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 while ((s2 < s2_limit) && (s1[matched] =
=3D=3D *s2)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++s2;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++matched;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return matched;
> +}
> +#endif
> +
> +/*
> + * For 0 <=3D offset <=3D 4, GetU32AtOffset(UNALIGNED_LOAD64(p), off=
set) will
> + * =A0equal UNALIGNED_LOAD32(p + offset). =A0Motivation: On x86-64 h=
ardware we have
> + * empirically found that overlapping loads such as
> + * =A0UNALIGNED_LOAD32(p) ... UNALIGNED_LOAD32(p+1) ... UNALIGNED_LO=
AD32(p+2)
> + * are slower than UNALIGNED_LOAD64(p) followed by shifts and casts =
to u32.
> + */
> +static inline u32 get_u32_at_offset(u64 v, int offset)
> +{
> + =A0 =A0 =A0 DCHECK(0 <=3D offset && offset <=3D 4);
> + =A0 =A0 =A0 return v >> (is_little_endian()? 8 * offset : 32 - 8 * =
offset);
> +}
> +
> +/*
> + * Flat array compression that does not emit the "uncompressed lengt=
h"
> + * =A0prefix. Compresses "input" string to the "*op" buffer.
> + *
> + * REQUIRES: "input" is at most "kBlockSize" bytes long.
> + * REQUIRES: "op" points to an array of memory that is at least
> + * "MaxCompressedLength(input.size())" in size.
> + * REQUIRES: All elements in "table[0..table_size-1]" are initialize=
d to zero.
> + * REQUIRES: "table_size" is a power of two
> + *
> + * Returns an "end" pointer into "op" buffer.
> + * "end - op" is the compressed size of "input".
> + */
> +
> +static char *compress_fragment(const char *const input,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const si=
ze_t input_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *op=
, u16 * table, const int table_size)
> +{
> + =A0 =A0 =A0 /* "ip" is the input pointer, and "op" is the output po=
inter. */
> + =A0 =A0 =A0 const char *ip =3D input;
> + =A0 =A0 =A0 CHECK_LE(input_size, kblock_size);
> + =A0 =A0 =A0 CHECK_EQ(table_size & (table_size - 1), 0);
> + =A0 =A0 =A0 const int shift =3D 32 - log2_floor(table_size);
> + =A0 =A0 =A0 DCHECK_EQ(UINT_MAX >> shift, table_size - 1);
> + =A0 =A0 =A0 const char *ip_end =3D input + input_size;
> + =A0 =A0 =A0 const char *baseip =3D ip;
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Bytes in [next_emit, ip) will be emitted as litera=
l bytes. =A0Or
> + =A0 =A0 =A0 =A0* =A0[next_emit, ip_end) after the main loop.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 const char *next_emit =3D ip;
> +
> + =A0 =A0 =A0 const int kinput_margin_bytes =3D 15;
> +
> + =A0 =A0 =A0 if (likely(input_size >=3D kinput_margin_bytes)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *ip_limit =3D input + input_=
size -
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kinput_margin_bytes;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 next_hash;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (next_hash =3D hash(++ip, shift);;)=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DCHECK_LT(next_emit, ip=
);
> +/*
> + * The body of this loop calls EmitLiteral once and then EmitCopy on=
e or
> + * more times. =A0(The exception is that when we're close to exhaust=
ing
> + * the input we goto emit_remainder.)
> + *
> + * In the first iteration of this loop we're just starting, so
> + * there's nothing to copy, so calling EmitLiteral once is
> + * necessary. =A0And we only start a new iteration when the
> + * current iteration has determined that a call to EmitLiteral will
> + * precede the next call to EmitCopy (if any).
> + *
> + * Step 1: Scan forward in the input looking for a 4-byte-long match=
=2E
> + * If we get close to exhausting the input then goto emit_remainder.
> + *
> + * Heuristic match skipping: If 32 bytes are scanned with no matches
> + * found, start looking only at every other byte. If 32 more bytes a=
re
> + * scanned, look at every third byte, etc.. When a match is found,
> + * immediately go back to looking at every byte. This is a small los=
s
> + * (~5% performance, ~0.1% density) for lcompressible data due to mo=
re
> + * bookkeeping, but for non-compressible data (such as JPEG) it's a =
huge
> + * win since the compressor quickly "realizes" the data is incompres=
sible
> + * and doesn't bother looking for matches everywhere.
> + *
> + * The "skip" variable keeps track of how many bytes there are since=
 the
> + * last match; dividing it by 32 (ie. right-shifting by five) gives =
the
> + * number of bytes to move ahead for each iteration.
> + */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 skip =3D 32;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *next_ip =3D=
 ip;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *candidate;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ip =3D =
next_ip;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 hva=
l =3D next_hash;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DCHECK_=
EQ(hval, hash(ip, shift));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 byt=
es_between_hash_lookups =3D skip++ >> 5;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 next_ip=
 =3D ip + bytes_between_hash_lookups;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unl=
ikely(next_ip > ip_limit)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto emit_remainder;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 next_ha=
sh =3D hash(next_ip, shift);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 candida=
te =3D baseip + table[hval];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DCHECK_=
GE(candidate, baseip);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DCHECK_=
LT(candidate, ip);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 table[h=
val] =3D ip - baseip;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (likely(UNALIGN=
ED_LOAD32(ip) !=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 UNALIGNED_LOAD32(candidate)));
> +
> +/*
> + * Step 2: A 4-byte match has been found. =A0We'll later see if more
> + * than 4 bytes match. =A0But, prior to the match, input
> + * bytes [next_emit, ip) are unmatched. =A0Emit them as "literal byt=
es."
> + */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DCHECK_LE(next_emit + 1=
6, ip_end);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 op =3D emit_literal(op,=
 next_emit, ip - next_emit, true);
> +
> +/*
> + * Step 3: Call EmitCopy, and then see if another EmitCopy could
> + * be our next move. =A0Repeat until we find no match for the
> + * input immediately after what was consumed by the last EmitCopy ca=
ll.
> + *
> + * If we exit this loop normally then we need to call EmitLiteral ne=
xt,
> + * though we don't yet know how big the literal will be. =A0We handl=
e that
> + * by proceeding to the next iteration of the main loop. =A0We also =
can exit
> + * this loop via goto if we get close to exhausting the input.
> + */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u64 input_bytes =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 candidate_bytes =3D=
 0;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do {
> +/*
> + * We have a 4-byte match at ip, and no need to emit any
> + * =A0"literal bytes" prior to ip.
> + */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const c=
har *base =3D ip;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int mat=
ched =3D 4 +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 find_match_length(candidate + 4, ip + 4,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ip_end);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ip +=3D=
 matched;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int off=
set =3D base - candidate;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DCHECK_=
EQ(0, memcmp(base, candidate, matched));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 op =3D =
emit_copy(op, offset, matched);
> +/*
> + * We could immediately start working at ip now, but to improve
> + * compression we first update table[Hash(ip - 1, ...)].
> + */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const c=
har *insert_tail =3D ip - 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 next_em=
it =3D ip;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unl=
ikely(ip >=3D ip_limit)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto emit_remainder;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 input_b=
ytes =3D UNALIGNED_LOAD64(insert_tail);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 pre=
v_hash =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 hash_bytes(get_u32_at_offset
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0(input_bytes, 0), shift);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 table[p=
rev_hash] =3D ip - baseip - 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 cur=
_hash =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 hash_bytes(get_u32_at_offset
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0(input_bytes, 1), shift);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 candida=
te =3D baseip + table[cur_hash];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 candida=
te_bytes =3D UNALIGNED_LOAD32(candidate);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 table[c=
ur_hash] =3D ip - baseip;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (get_u32_at_off=
set(input_bytes, 1) =3D=3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cand=
idate_bytes);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 next_hash =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hash_bytes(get_=
u32_at_offset(input_bytes, 2),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0shift);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++ip;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> +emit_remainder:
> + =A0 =A0 =A0 /* Emit the remaining bytes as a literal */
> + =A0 =A0 =A0 if (next_emit < ip_end)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 op =3D emit_literal(op, next_emit, ip_e=
nd - next_emit, false);
> +
> + =A0 =A0 =A0 return op;
> +}
> +
> +/*
> + * -----------------------------------------------------------------=
------
> + * =A0Lookup table for decompression code. =A0Generated by ComputeTa=
ble() below.
> + * -----------------------------------------------------------------=
------
> + */
> +
> +/* Mapping from i in range [0,4] to a mask to extract the bottom 8*i=
 bits */
> +static const u32 wordmask[] =3D {
> + =A0 =A0 =A0 0u, 0xffu, 0xffffu, 0xffffffu, 0xffffffffu
> +};
> +
> +/*
> + * Data stored per entry in lookup table:
> + * =A0 =A0 =A0 Range =A0 Bits-used =A0 =A0 =A0 Description
> + * =A0 =A0 =A0------------------------------------
> + * =A0 =A0 =A01..64 =A0 0..7 =A0 =A0 =A0 =A0 =A0 =A0Literal/copy len=
gth encoded in opcode byte
> + * =A0 =A0 =A00..7 =A0 =A08..10 =A0 =A0 =A0 =A0 =A0 Copy offset enco=
ded in opcode byte / 256
> + * =A0 =A0 =A00..4 =A0 =A011..13 =A0 =A0 =A0 =A0 =A0Extra bytes afte=
r opcode
> + *
> + * We use eight bits for the length even though 7 would have suffice=
d
> + * because of efficiency reasons:
> + * =A0 =A0 =A0(1) Extracting a byte is faster than a bit-field
> + * =A0 =A0 =A0(2) It properly aligns copy offset so we do not need a=
 <<8
> + */
> +static const u16 char_table[256] =3D {
> + =A0 =A0 =A0 0x0001, 0x0804, 0x1001, 0x2001, 0x0002, 0x0805, 0x1002,=
 0x2002,
> + =A0 =A0 =A0 0x0003, 0x0806, 0x1003, 0x2003, 0x0004, 0x0807, 0x1004,=
 0x2004,
> + =A0 =A0 =A0 0x0005, 0x0808, 0x1005, 0x2005, 0x0006, 0x0809, 0x1006,=
 0x2006,
> + =A0 =A0 =A0 0x0007, 0x080a, 0x1007, 0x2007, 0x0008, 0x080b, 0x1008,=
 0x2008,
> + =A0 =A0 =A0 0x0009, 0x0904, 0x1009, 0x2009, 0x000a, 0x0905, 0x100a,=
 0x200a,
> + =A0 =A0 =A0 0x000b, 0x0906, 0x100b, 0x200b, 0x000c, 0x0907, 0x100c,=
 0x200c,
> + =A0 =A0 =A0 0x000d, 0x0908, 0x100d, 0x200d, 0x000e, 0x0909, 0x100e,=
 0x200e,
> + =A0 =A0 =A0 0x000f, 0x090a, 0x100f, 0x200f, 0x0010, 0x090b, 0x1010,=
 0x2010,
> + =A0 =A0 =A0 0x0011, 0x0a04, 0x1011, 0x2011, 0x0012, 0x0a05, 0x1012,=
 0x2012,
> + =A0 =A0 =A0 0x0013, 0x0a06, 0x1013, 0x2013, 0x0014, 0x0a07, 0x1014,=
 0x2014,
> + =A0 =A0 =A0 0x0015, 0x0a08, 0x1015, 0x2015, 0x0016, 0x0a09, 0x1016,=
 0x2016,
> + =A0 =A0 =A0 0x0017, 0x0a0a, 0x1017, 0x2017, 0x0018, 0x0a0b, 0x1018,=
 0x2018,
> + =A0 =A0 =A0 0x0019, 0x0b04, 0x1019, 0x2019, 0x001a, 0x0b05, 0x101a,=
 0x201a,
> + =A0 =A0 =A0 0x001b, 0x0b06, 0x101b, 0x201b, 0x001c, 0x0b07, 0x101c,=
 0x201c,
> + =A0 =A0 =A0 0x001d, 0x0b08, 0x101d, 0x201d, 0x001e, 0x0b09, 0x101e,=
 0x201e,
> + =A0 =A0 =A0 0x001f, 0x0b0a, 0x101f, 0x201f, 0x0020, 0x0b0b, 0x1020,=
 0x2020,
> + =A0 =A0 =A0 0x0021, 0x0c04, 0x1021, 0x2021, 0x0022, 0x0c05, 0x1022,=
 0x2022,
> + =A0 =A0 =A0 0x0023, 0x0c06, 0x1023, 0x2023, 0x0024, 0x0c07, 0x1024,=
 0x2024,
> + =A0 =A0 =A0 0x0025, 0x0c08, 0x1025, 0x2025, 0x0026, 0x0c09, 0x1026,=
 0x2026,
> + =A0 =A0 =A0 0x0027, 0x0c0a, 0x1027, 0x2027, 0x0028, 0x0c0b, 0x1028,=
 0x2028,
> + =A0 =A0 =A0 0x0029, 0x0d04, 0x1029, 0x2029, 0x002a, 0x0d05, 0x102a,=
 0x202a,
> + =A0 =A0 =A0 0x002b, 0x0d06, 0x102b, 0x202b, 0x002c, 0x0d07, 0x102c,=
 0x202c,
> + =A0 =A0 =A0 0x002d, 0x0d08, 0x102d, 0x202d, 0x002e, 0x0d09, 0x102e,=
 0x202e,
> + =A0 =A0 =A0 0x002f, 0x0d0a, 0x102f, 0x202f, 0x0030, 0x0d0b, 0x1030,=
 0x2030,
> + =A0 =A0 =A0 0x0031, 0x0e04, 0x1031, 0x2031, 0x0032, 0x0e05, 0x1032,=
 0x2032,
> + =A0 =A0 =A0 0x0033, 0x0e06, 0x1033, 0x2033, 0x0034, 0x0e07, 0x1034,=
 0x2034,
> + =A0 =A0 =A0 0x0035, 0x0e08, 0x1035, 0x2035, 0x0036, 0x0e09, 0x1036,=
 0x2036,
> + =A0 =A0 =A0 0x0037, 0x0e0a, 0x1037, 0x2037, 0x0038, 0x0e0b, 0x1038,=
 0x2038,
> + =A0 =A0 =A0 0x0039, 0x0f04, 0x1039, 0x2039, 0x003a, 0x0f05, 0x103a,=
 0x203a,
> + =A0 =A0 =A0 0x003b, 0x0f06, 0x103b, 0x203b, 0x003c, 0x0f07, 0x103c,=
 0x203c,
> + =A0 =A0 =A0 0x0801, 0x0f08, 0x103d, 0x203d, 0x1001, 0x0f09, 0x103e,=
 0x203e,
> + =A0 =A0 =A0 0x1801, 0x0f0a, 0x103f, 0x203f, 0x2001, 0x0f0b, 0x1040,=
 0x2040
> +};
> +
> +struct snappy_decompressor {
> + =A0 =A0 =A0 struct source *reader; =A0/* Underlying source of bytes=
 to decompress */
> + =A0 =A0 =A0 const char *ip; =A0 =A0 =A0 =A0 /* Points to next buffe=
red byte */
> + =A0 =A0 =A0 const char *ip_limit; =A0 /* Points just past buffered =
bytes */
> + =A0 =A0 =A0 u32 peeked; =A0 =A0 =A0 =A0 =A0 =A0 /* Bytes peeked fro=
m reader (need to skip) */
> + =A0 =A0 =A0 bool eof; =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Hit end of inp=
ut without an error? */
> + =A0 =A0 =A0 char scratch[5]; =A0 =A0 =A0 =A0/* Temporary buffer for=
 peekfast boundaries */
> +};
> +
> +static void
> +init_snappy_decompressor(struct snappy_decompressor *d, struct sourc=
e *reader)
> +{
> + =A0 =A0 =A0 d->reader =3D reader;
> + =A0 =A0 =A0 d->ip =3D NULL;
> + =A0 =A0 =A0 d->ip_limit =3D NULL;
> + =A0 =A0 =A0 d->peeked =3D 0;
> + =A0 =A0 =A0 d->eof =3D false;
> +}
> +
> +static void exit_snappy_decompressor(struct snappy_decompressor *d)
> +{
> + =A0 =A0 =A0 skip(d->reader, d->peeked);
> +}
> +
> +/*
> + * Read the uncompressed length stored at the start of the compresse=
d data.
> + * On succcess, stores the length in *result and returns true.
> + * On failure, returns false.
> + */
> +static bool read_uncompressed_length(struct snappy_decompressor *d,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0u32 * result)
> +{
> + =A0 =A0 =A0 DCHECK(d->ip =3D=3D NULL); =A0/*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Mu=
st not have read anything yet
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Le=
ngth is encoded in 1..5 bytes
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 *result =3D 0;
> + =A0 =A0 =A0 u32 shift =3D 0;
> + =A0 =A0 =A0 while (true) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (shift >=3D 32)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t n;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *ip =3D peek(d->reader, &n);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (n =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 const unsigned char c =3D *(const unsig=
ned char *)(ip);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 skip(d->reader, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *result |=3D (u32) (c & 0x7f) << shift;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (c < 128) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 shift +=3D 7;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return true;
> +}
> +
> +static bool refill_tag(struct snappy_decompressor *d);
> +
> +/*
> + * Process the next item found in the input.
> + * Returns true if successful, false on error or end of input.
> + */
> +static void decompress_all_tags(struct snappy_decompressor *d,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
writer *writer)
> +{
> + =A0 =A0 =A0 const char *ip =3D d->ip;
> +
> + =A0 =A0 =A0 for (;;) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (d->ip_limit - ip < 5) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 d->ip =3D ip;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!refill_tag(d))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ip =3D d->ip;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 const unsigned char c =3D *(const unsig=
ned char *)(ip++);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((c & 0x3) =3D=3D LITERAL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 literal_length =3D =
c >> 2;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(literal_le=
ngth >=3D 60)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Long=
 literal */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const u=
32 literal_ll =3D literal_length - 59;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 literal=
_length =3D get_unaligned_le32(ip) &
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 wordmask[literal_ll];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ip +=3D=
 literal_ll;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++literal_length;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 avail =3D d->ip_lim=
it - ip;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (avail < literal_=
length) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!wr=
iter_append(writer, ip, avail, false))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 literal=
_length -=3D avail;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 skip(d-=
>reader, d->peeked);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t =
n;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ip =3D =
peek(d->reader, &n);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 avail =3D=
 n;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 d->peek=
ed =3D avail;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ava=
il =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 return; /* Premature end of input */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 d->ip_l=
imit =3D ip + avail;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool allow_fast_path =3D=
 (avail >=3D 16);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!writer_append(writ=
er, ip, literal_length,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0allow_fast_path))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ip +=3D literal_length;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const u32 entry =3D cha=
r_table[c];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const u32 trailer =3D g=
et_unaligned_le32(ip) &
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wordmas=
k[entry >> 11];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const u32 length =3D en=
try & 0xff;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ip +=3D entry >> 11;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* copy_offset/256 is=
 encoded in bits 8..10.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* By just fetching t=
hose bits, we get
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* copy_offset (since=
 the bit-field starts at
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* bit 8).
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const u32 copy_offset =3D=
 entry & 0x700;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!writer_append_from=
_self(writer,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0copy_offset + trailer,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0length))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +}
> +
> +static bool refill_tag(struct snappy_decompressor *d)
> +{
> + =A0 =A0 =A0 const char *ip =3D d->ip;
> +
> + =A0 =A0 =A0 if (ip =3D=3D d->ip_limit) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t n;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Fetch a new fragment from the reader=
 */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 skip(d->reader, d->peeked); /* All peek=
ed bytes are used up */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ip =3D peek(d->reader, &n);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 d->peeked =3D n;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (n =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 d->eof =3D true;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 d->ip_limit =3D ip + n;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Read the tag character */
> + =A0 =A0 =A0 DCHECK_LT(ip, d->ip_limit);
> + =A0 =A0 =A0 const unsigned char c =3D *(const unsigned char *)(ip);
> + =A0 =A0 =A0 const u32 entry =3D char_table[c];
> + =A0 =A0 =A0 const u32 needed =3D (entry >> 11) + 1; =A0 /* +1 byte =
for 'c' */
> + =A0 =A0 =A0 DCHECK_LE(needed, sizeof(d->scratch));
> +
> + =A0 =A0 =A0 /* Read more bytes from reader if needed */
> + =A0 =A0 =A0 u32 nbuf =3D d->ip_limit - ip;
> +
> + =A0 =A0 =A0 if (nbuf < needed) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Stitch together bytes from ip and =
reader to form the word
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* contents. =A0We store the needed b=
ytes in "scratch". =A0They
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* will be consumed immediately by th=
e caller since we do not
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* read more than we need.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memmove(d->scratch, ip, nbuf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 skip(d->reader, d->peeked); /* All peek=
ed bytes are used up */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 d->peeked =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (nbuf < needed) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t length;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *src =3D pee=
k(d->reader, &length);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (length =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 to_add =3D min_t(u3=
2, needed - nbuf, length);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(d->scratch + nbu=
f, src, to_add);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nbuf +=3D to_add;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 skip(d->reader, to_add)=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DCHECK_EQ(nbuf, needed);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 d->ip =3D d->scratch;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 d->ip_limit =3D d->scratch + needed;
> + =A0 =A0 =A0 } else if (nbuf < 5) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Have enough bytes, but move into s=
cratch so that we do not
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* read past end of input
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memmove(d->scratch, ip, nbuf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 skip(d->reader, d->peeked); /* All peek=
ed bytes are used up */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 d->peeked =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 d->ip =3D d->scratch;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 d->ip_limit =3D d->scratch + nbuf;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Pass pointer to buffer returned by r=
eader. */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 d->ip =3D ip;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return true;
> +}
> +
> +static int internal_uncompress(struct source *r,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct w=
riter *writer, u32 max_len)
> +{
> + =A0 =A0 =A0 struct snappy_decompressor decompressor;
> + =A0 =A0 =A0 u32 uncompressed_len =3D 0;
> +
> + =A0 =A0 =A0 init_snappy_decompressor(&decompressor, r);
> +
> + =A0 =A0 =A0 if (!read_uncompressed_length(&decompressor, &uncompres=
sed_len))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> + =A0 =A0 =A0 /* Protect against possible DoS attack */
> + =A0 =A0 =A0 if ((u64) (uncompressed_len) > max_len)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> +
> + =A0 =A0 =A0 writer_set_expected_length(writer, uncompressed_len);
> +
> + =A0 =A0 =A0 /* Process the entire input */
> + =A0 =A0 =A0 decompress_all_tags(&decompressor, writer);
> +
> + =A0 =A0 =A0 exit_snappy_decompressor(&decompressor);
> + =A0 =A0 =A0 return (decompressor.eof && writer_check_length(writer)=
) ? 0 : -EIO;
> +}
> +
> +static inline int compress(struct snappy_env *env, struct source *re=
ader,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct sink *wri=
ter)
> +{
> + =A0 =A0 =A0 int err;
> + =A0 =A0 =A0 size_t written =3D 0;
> + =A0 =A0 =A0 int N =3D available(reader);
> + =A0 =A0 =A0 char ulength[kmax32];
> + =A0 =A0 =A0 char *p =3D varint_encode32(ulength, N);
> +
> + =A0 =A0 =A0 append(writer, ulength, p - ulength);
> + =A0 =A0 =A0 written +=3D (p - ulength);
> +
> + =A0 =A0 =A0 while (N > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Get next block to compress (without =
copying if possible) */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t fragment_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *fragment =3D peek(reader, &=
fragment_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (fragment_size =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -EIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int num_to_read =3D min_t(int, N,=
 kblock_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t bytes_read =3D fragment_size;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int pending_advance =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (bytes_read >=3D num_to_read) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Buffer returned by r=
eader is large enough */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pending_advance =3D num=
_to_read;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fragment_size =3D num_t=
o_read;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +#ifdef SCATHER_GATHER
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(env->scratch, fr=
agment, bytes_read);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 skip(reader, bytes_read=
);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 while (bytes_read < num=
_to_read) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fragmen=
t =3D peek(reader, &fragment_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t =
n =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 min_t(size_t, fragment_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 num_to_read - bytes_read);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(=
env->scratch + bytes_read, fragment, n);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bytes_r=
ead +=3D n;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 skip(re=
ader, n);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DCHECK_EQ(bytes_read, n=
um_to_read);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fragment =3D env->scrat=
ch;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fragment_size =3D num_t=
o_read;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +#endif
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (fragment_size < num_to_read)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Get encoding table for compression *=
/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int table_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u16 *table =3D get_hash_table(env, num_=
to_read, &table_size);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Compress input_fragment and append t=
o dest */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int max_output =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 snappy_max_compressed_length(nu=
m_to_read);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *dest;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dest =3D sink_peek(writer, max_output);
> +#ifdef SCATHER_GATHER
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!dest) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Need a scratch buf=
fer for the output,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* because the byte s=
ink doesn't have enough
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* in one piece.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dest =3D env->scratch_o=
utput;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +#endif
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *end =3D compress_fragment(fragmen=
t, fragment_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 dest, table, table_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 append(writer, dest, end - dest);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 written +=3D (end - dest);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 N -=3D num_to_read;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 skip(reader, pending_advance);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 err =3D 0;
> +out:
> + =A0 =A0 =A0 return err;
> +}
> +
> +/**
> + * snappy_compress - Compress a buffer using the snappy compressor.
> + * @env: Preallocated environment
> + * @input: Input buffer
> + * @input_length: Length of input_buffer
> + * @compressed: Output buffer for compressed data
> + * @compressed_length: The real length of the output written here.
> + *
> + * Return 0 on success, otherwise an negative error code.
> + *
> + * The output buffer must be at least
> + * snappy_max_compressed_length(input_length) bytes long.
> + *
> + * Requires a preallocated environment from snappy_init_env.
> + * The environment does not keep state over individual calls
> + * of this function, just preallocates the memory.
> + */
> +int snappy_compress(struct snappy_env *env,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *input,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 size_t input_length,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *compressed, size_t *compr=
essed_length)
> +{
> + =A0 =A0 =A0 struct source reader =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ptr =3D input,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .left =3D input_length
> + =A0 =A0 =A0 };
> + =A0 =A0 =A0 struct sink writer =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .dest =3D compressed,
> + =A0 =A0 =A0 };
> + =A0 =A0 =A0 int err =3D compress(env, &reader, &writer);
> +
> + =A0 =A0 =A0 /* Compute how many bytes were added */
> + =A0 =A0 =A0 *compressed_length =3D (writer.dest - compressed);
> + =A0 =A0 =A0 return err;
> +}
> +EXPORT_SYMBOL(snappy_compress);
> +
> +/**
> + * snappy_uncompress - Uncompress a snappy compressed buffer
> + * @compressed: Input buffer with compressed data
> + * @n: length of compressed buffer
> + * @uncompressed: buffer for uncompressed data
> + *
> + * The uncompressed data buffer must be at least
> + * snappy_uncompressed_length(compressed) bytes long.
> + *
> + * Returns true when successfull, otherwise false.
> + */
> +bool snappy_uncompress(const char *compressed, size_t n, char *uncom=
pressed)
> +{
> + =A0 =A0 =A0 struct source reader =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ptr =3D compressed,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .left =3D n
> + =A0 =A0 =A0 };
> + =A0 =A0 =A0 struct writer output =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .base =3D uncompressed,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .op =3D uncompressed
> + =A0 =A0 =A0 };
> + =A0 =A0 =A0 return internal_uncompress(&reader, &output, 0xffffffff=
);
> +}
> +EXPORT_SYMBOL(snappy_uncompress);
> +
> +/**
> + * snappy_init_env - Allocate snappy compression environment
> + * @env: Environment to preallocate
> + *
> + * Returns 0 on success, otherwise negative errno.
> + * Must run in process context.
> + */
> +int snappy_init_env(struct snappy_env *env)
> +{
> + =A0 =A0 =A0 env->hash_table =3D vmalloc(sizeof(u16) * kmax_hash_tab=
le_size);
> + =A0 =A0 =A0 if (!env->hash_table)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error;
> +#ifdef SCATHER_GATHER
> + =A0 =A0 =A0 env->scratch =3D vmalloc(kblock_size);
> + =A0 =A0 =A0 env->scratch_output =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 vmalloc(snappy_max_compressed_length(kb=
lock_size));
> + =A0 =A0 =A0 if (!env->scratch || !env->scratch_output)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error;
> +#endif
> + =A0 =A0 =A0 return 0;
> +error:
> + =A0 =A0 =A0 snappy_free_env(env);
> + =A0 =A0 =A0 return -ENOMEM;
> +}
> +EXPORT_SYMBOL(snappy_init_env);
> +
> +/**
> + * snappy_free_env - Free an snappy compression environment
> + * @env: Environment to free.
> + *
> + * Must run in process context.
> + */
> +void snappy_free_env(struct snappy_env *env)
> +{
> + =A0 =A0 =A0 vfree(env->hash_table);
> +#ifdef SCATHER_GATHER
> + =A0 =A0 =A0 vfree(env->scratch);
> + =A0 =A0 =A0 vfree(env->scratch_output);
> +#endif
> + =A0 =A0 =A0 memset(env, 0, sizeof(struct snappy_env));
> +}
> +EXPORT_SYMBOL(snappy_free_env);
> --
> 1.7.7.4

I've run into one of those x86_64/x86 errors (I think x86_64 has
different implicit includes).

(BTW:  If you're ever reworking this patch set, I'd like to make an ad
hoc request for slightly different names for fs/btrfs/snappy.c and
lib/snappy.c)

When building a x86 kernel, I get the following errors:
  CC [M]  lib/snappy.o
lib/snappy.c: In function 'snappy_init_env':
lib/snappy.c:1268:2: error: implicit declaration of function 'vmalloc'
  CC [M]  fs/btrfs/free-space-cache.o
lib/snappy.c:1268:18: warning: assignment makes pointer from integer
without a cast
lib/snappy.c: In function 'snappy_free_env':
lib/snappy.c:1293:2: error: implicit declaration of function 'vfree'
make[1]: *** [lib/snappy.o] Error 1
make: *** [lib] Error 2

The error clears with this patch:

diff --git a/lib/snappy.c b/lib/snappy.c
index 3848c6c..a25b2a4 100644
--- a/lib/snappy.c
+++ b/lib/snappy.c
@@ -41,6 +41,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/snappy.h>
+#include <linux/vmalloc.h>
 #include <asm/unaligned.h>

 #define CRASH_UNLESS(x) BUG_ON(!(x))
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
