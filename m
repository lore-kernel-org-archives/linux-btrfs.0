Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:56873 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758074Ab3BBUM2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Feb 2013 15:12:28 -0500
Message-ID: <510D7356.4030903@inwind.it>
Date: Sat, 02 Feb 2013 21:13:10 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [BTRFS-PROGS][PATCH] remove __attribute_const__ from raid6.c
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I am playing with the new branch raid56-experimental. Unfortunately 
I was not able to compile the btrfs-progs tools because my gcc was unable 
to find '__attribute_const__':

[...]
raid6.c:48:1: error: unknown type name ‘__attribute_const__’
raid6.c:48:45: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘SHLBYTE’
raid6.c:60:1: error: unknown type name ‘__attribute_const__’
raid6.c:60:45: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘MASK’
[...]

$ gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/4.7/lto-wrapper
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Debian 4.7.2-5' 
--with-bugurl=file:///usr/share/doc/gcc-4.7/README.Bugs 
--enable-languages=c,c++,go,fortran,objc,obj-c++ 
--prefix=/usr --program-suffix=-4.7 --enable-shared --enable-linker-build-id 
--with-system-zlib --libexecdir=/usr/lib --without-included-gettext 
--enable-threads=posix --with-gxx-include-dir=/usr/include/c++/4.7 
--libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu 
--enable-libstdcxx-debug --enable-libstdcxx-time=yes --enable-gnu-unique-object 
--enable-plugin --enable-objc-gc --with-arch-32=i586 --with-tune=generic 
--enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu 
--target=x86_64-linux-gnu
Thread model: posix
gcc version 4.7.2 (Debian 4.7.2-5) 


The patch below fixed that:

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

---

>From 761a0b05f04da6029fec2a3060e64135ccb3046e Mon Sep 17 00:00:00 2001
From: Goffredo Baroncelli <kreijack@inwind.it>
Date: Sat, 2 Feb 2013 21:10:20 +0100
Subject: [PATCH] =?UTF-8?q?Remove=20=E2=80=98=5F=5Fattribute=5Fconst=5F=5F=E2?=
 =?UTF-8?q?=80=99=20from=20raid6.c?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Remove ‘__attribute_const__’ from raid6.c otherwise gcc was unable
to compile it.
---
 raid6.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/raid6.c b/raid6.c
index 3a42bdf..a5a3dc3 100644
--- a/raid6.c
+++ b/raid6.c
@@ -45,7 +45,7 @@ typedef uint32_t unative_t;
  * The SHLBYTE() operation shifts each byte left by 1, *not*
  * rolling over into the next byte
  */
-static inline __attribute_const__ unative_t SHLBYTE(unative_t v)
+static inline unative_t SHLBYTE(unative_t v)
 {
 	unative_t vv;
 
@@ -57,7 +57,7 @@ static inline __attribute_const__ unative_t SHLBYTE(unative_t v)
  * The MASK() operation returns 0xFF in any byte for which the high
  * bit is 1, 0x00 for any byte for which the high bit is 0.
  */
-static inline __attribute_const__ unative_t MASK(unative_t v)
+static inline unative_t MASK(unative_t v)
 {
 	unative_t vv;
 
-- 
1.7.10.4





-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
