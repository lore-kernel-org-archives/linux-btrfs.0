From: Adrian Hunter <adrian.hunter@linux.intel.com>
Subject: Re: btrfs hang on brd
Date: Wed, 01 Jun 2011 13:07:00 +0300
Message-ID: <4DE60F44.6090400@linux.intel.com>
References: <4DE492B0.9020302@linux.intel.com> <20110601085439.GD12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: dave@jikos.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110601085439.GD12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/06/11 11:54, David Sterba wrote:
> On Tue, May 31, 2011 at 10:03:12AM +0300, Adrian Hunter wrote:
>> Hi
>>
>> I seem to be able to get btrfs reproducibly to
>> produce warnings and finally hang when running
>> a stress test on a ramdisk.
>>
>> Testing was done using the "integration-test"
>> branch of btrfs-unstable.  Note that I also tested
>> v2.6.39 and "integration-test" took much longer to
>> hang i.e. it is an improvement
>>
>> The test script and stack dumps are below.
>>
>> Is this a valid test?
>>
>> Is it worth me investigating these?
>
> I've tried to reproduce myself, but the fsstress utility (taken from
> latest LTP suite) crashes sometimes and I cannot take it as a proper
> reproduction. Can you point me to the exact version you used?

The LTP version does not compile properly:

make[4]: Entering directory 
`/home/ahunter/Desktop/Projects/ltp/ltp-full-20110228/testcases/kernel/fs/fsstress'
gcc -g -O2 -g -O2 -fno-strict-aliasing -pipe -Wall  -DNO_XFS 
-I/home/ahunter/Desktop/Projects/ltp/ltp-full-20110228/testcases/kernel/fs/fsstress 
-D_LARGEFILE64_SOURCE -D_GNU_SOURCE -Wno-error -I../../../../include 
-I../../../../include   -L../../../../lib  fsstress.c   -o fsstress
fsstress.c: In function 'dread_f':
fsstress.c:1829:2: warning: implicit declaration of function 'memalign'
fsstress.c:1829:6: warning: assignment makes pointer from integer 
without a cast
fsstress.c: In function 'dwrite_f':
fsstress.c:1912:6: warning: assignment makes pointer from integer 
without a cast
fsstress.c:1844:17: warning: 'diob.d_miniosz' may be used uninitialized 
in this function
fsstress.c:1844:17: warning: 'diob.d_maxiosz' may be used uninitialized 
in this function
fsstress.c:1844:17: warning: 'diob.d_mem' may be used uninitialized in 
this function
fsstress.c: In function 'dread_f':
fsstress.c:1750:17: warning: 'diob.d_miniosz' may be used uninitialized 
in this function
fsstress.c:1750:17: warning: 'diob.d_maxiosz' may be used uninitialized 
in this function
fsstress.c:1750:17: warning: 'diob.d_mem' may be used uninitialized in 
this function


I hacked a couple of changes but I need to check them before
mailing to the ltp-list:


From: Adrian Hunter <adrian.hunter@intel.com>
Date: Wed, 1 Jun 2011 13:01:48 +0300
Subject: [PATCH] fsstress: quick fix for compile errors

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
  testcases/kernel/fs/fsstress/fsstress.c |    2 ++
  testcases/kernel/fs/fsstress/global.h   |    1 +
  2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/testcases/kernel/fs/fsstress/fsstress.c 
b/testcases/kernel/fs/fsstress/fsstress.c
index e3b48ea..83c23ed 100644
--- a/testcases/kernel/fs/fsstress/fsstress.c
+++ b/testcases/kernel/fs/fsstress/fsstress.c
@@ -1757,6 +1757,7 @@ dread_f(int opno, long r)
  	struct stat64	stb;
  	int		v;

+	memset(&diob, 0, sizeof(struct dioattr));
  	init_pathname(&f);
  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
  		if (v)
@@ -1851,6 +1852,7 @@ dwrite_f(int opno, long r)
  	struct stat64	stb;
  	int		v;

+	memset(&diob, 0, sizeof(struct dioattr));
  	init_pathname(&f);
  	if (!get_fname(FT_REGFILE, r, &f, NULL, NULL, &v)) {
  		if (v)
diff --git a/testcases/kernel/fs/fsstress/global.h 
b/testcases/kernel/fs/fsstress/global.h
index f788395..5ab5d56 100644
--- a/testcases/kernel/fs/fsstress/global.h
+++ b/testcases/kernel/fs/fsstress/global.h
@@ -58,6 +58,7 @@
  #include <stdlib.h>
  #include <stdio.h>
  #include <unistd.h>
+#include <malloc.h>

  #ifndef O_DIRECT
  #define O_DIRECT 040000
-- 
1.7.4.4


> (But no warning or hang observed, on top of 3.0-rc1 + cmason/for-linus)

I will try it tonight.

