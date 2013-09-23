Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:62838 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab3IWHRa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 03:17:30 -0400
Message-ID: <523FEAF3.1090607@windriver.com>
Date: Mon, 23 Sep 2013 15:17:07 +0800
From: Rongqing Li <rongqing.li@windriver.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Add dependencies explicitly to fix a parallel
 build issue
References: <1379466661-27973-1-git-send-email-rongqing.li@windriver.com> <52390704.3010902@redhat.com>
In-Reply-To: <52390704.3010902@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/18/2013 09:51 AM, Eric Sandeen wrote:
> On 9/17/13 8:11 PM, rongqing.li@windriver.com wrote:
>> From: Roy Li <rongqing.li@windriver.com>
>>
>> The dependencies of "all: version.h" or other similar ones can not
>> fix the parallel build failure, only reduce the times; In fact,
>> many *.o files require version.h file.
>>
>> 	#grep '#include "version.h"' ./ -r
>> 	./btrfs-corrupt-block.c:#include "version.h"
>> 	./btrfs.c:#include "version.h"
>> 	./btrfs-image.c:#include "version.h"
>> 	./cmds-filesystem.c:#include "version.h"
>> 	./btrfs-show-super.c:#include "version.h"
>> 	./btrfs-select-super.c:#include "version.h"
>> 	./cmds-restore.c:#include "version.h"
>> 	./btrfs-find-root.c:#include "version.h"
>> 	./mkfs.c:#include "version.h"
>> 	./btrfs-zero-log.c:#include "version.h"
>> 	./btrfs-defrag.c:#include "version.h"
>> 	./cmds-chunk.c:#include "version.h"
>> 	./btrfstune.c:#include "version.h"
>> 	./btrfs-calc-size.c:#include "version.h"
>> 	./btrfs-map-logical.c:#include "version.h"
>> 	./cmds-check.c:#include "version.h"
>> 	./btrfs-debug-tree.c:#include "version.h"
>>
>> Signed-off-by: Roy Li <rongqing.li@windriver.com>
>> ---
>>   Sorry, The patch [btrfs-progs: fix parallel build] sent by me on Sep 3
>> can not fix the build failure, when build enough times on a 16 core cpu,
>> the build failure happens again, so I refix it again.
>>
>>
>>   Makefile |    6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/Makefile b/Makefile
>> index c43cb68..a7c259c 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -81,6 +81,12 @@ endif
>>   	@echo "    [CC]     $@"
>>   	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<
>>
>> +btrfs-corrupt-block.o btrfs.o btrfs-image.o cmds-filesystem.o:version.h
>> +btrfs-show-super.o btrfs-select-super.o cmds-restore.o:version.h
>> +btrfs-find-root.o mkfs.o btrfs-zero-log.o btrfs-defrag.o cmds-chunk.o:version.h
>> +btrfstune.o btrfs-calc-size.o btrfs-map-logical.o cmds-check.o:version.h
>> +btrfs-debug-tree.o:version.h
>> +
>>   %.static.o: %.c
>>   	@echo "    [CC]     $@"
>>   	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(STATIC_CFLAGS) -c $< -o $@
>>
>
> I think this can be done more cleanly, I'll send a patch.
>
> -Eric
>
>

If this one is not cleanly, how is the below one


 From a56ac083a789605904507b602d9ebf196ae6746d Mon Sep 17 00:00:00 2001
From: Roy Li <rongqing.li@windriver.com>
Date: Mon, 23 Sep 2013 09:53:30 +0800
Subject: [PATCH] btrfs-progs: Add dependencies explicitly to fix a parallel
  build issue

The dependencies of "all: version.h" or other similar ones can not
fix the parallel build failure, only reduce the times; In fact,
many *.o files require version.h file.

	#grep '#include "version.h"' ./ -r
	./btrfs-corrupt-block.c:#include "version.h"
	./btrfs.c:#include "version.h"
	./btrfs-image.c:#include "version.h"
	./cmds-filesystem.c:#include "version.h"
	./btrfs-show-super.c:#include "version.h"
	./btrfs-select-super.c:#include "version.h"
	./cmds-restore.c:#include "version.h"
	./btrfs-find-root.c:#include "version.h"
	./mkfs.c:#include "version.h"
	./btrfs-zero-log.c:#include "version.h"
	./btrfs-defrag.c:#include "version.h"
	./cmds-chunk.c:#include "version.h"
	./btrfstune.c:#include "version.h"
	./btrfs-calc-size.c:#include "version.h"
	./btrfs-map-logical.c:#include "version.h"
	./cmds-check.c:#include "version.h"
	./btrfs-debug-tree.c:#include "version.h"

Signed-off-by: Roy Li <rongqing.li@windriver.com>
---
  Makefile |    2 ++
  1 file changed, 2 insertions(+)

diff --git a/Makefile b/Makefile
index c43cb68..901ffa2 100644
--- a/Makefile
+++ b/Makefile
@@ -81,6 +81,8 @@ endif
  	@echo "    [CC]     $@"
  	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(CFLAGS) -c $<

+%.o: version.h
+
  %.static.o: %.c
  	@echo "    [CC]     $@"
  	$(Q)$(CC) $(DEPFLAGS) $(AM_CFLAGS) $(STATIC_CFLAGS) -c $< -o $@
-- 
1.7.10.4




-- 
Best Reagrds,
Roy | RongQing Li
