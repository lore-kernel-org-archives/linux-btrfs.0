Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:42843 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3IRGjc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 02:39:32 -0400
Message-ID: <52394AA0.9040000@windriver.com>
Date: Wed, 18 Sep 2013 14:39:28 +0800
From: Rongqing Li <rongqing.li@windriver.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Add version.h dependency to fix parallel
 builds
References: <1379466661-27973-1-git-send-email-rongqing.li@windriver.com> <5239084D.4020802@redhat.com> <52390F72.7030908@redhat.com>
In-Reply-To: <52390F72.7030908@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/18/2013 10:26 AM, Eric Sandeen wrote:
> On 9/17/13 8:56 PM, Eric Sandeen wrote:
>> Change the suffix rule to ensure that version.h is
>> built before we try to create any .o file.
>>
>> Reported-by: Roy Li <rongqing.li@windriver.com>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> I dunno, does this work?  My gnu make is rusty.
>
> I'm actually confused by what the makefile is doing with the
> dependency generation, maybe my patch isn't right.
>
> this:
>
> %.o.d: %.c
>          $(Q)$(CC) -MM -MG -MF $@ -MT $(@:.o.d=.o) -MT $(@:.o.d=.static.o) -MT $@ $(AM_CFLAGS) $(CFLAGS) $<
>
> completely confuses me :)
>
> -Eric

It lead to the below building error:

n file included from ctree.c:18:0:
| ctree.h:30:24: fatal error: btrfs/list.h: No such file or directory
|  #include <btrfs/list.h>
|                         ^
| compilation terminated.
| In file included from extent-tree.c:22:0:
| radix-tree.h:43:30: fatal error: btrfs/kerncompat.h: No such file or 
directory
|  #include <btrfs/kerncompat.h>
|                               ^
| compilation terminated.
| In file included from disk-io.c:29:0:
| radix-tree.h:43:30: fatal error: btrfs/kerncompat.h: No such file or 
directory
|  #include <btrfs/kerncompat.h>
|                               ^
| compilation terminated.
| In file included from radix-tree.c:40:0:
| radix-tree.h:43:30: fatal error: btrfs/kerncompat.h: No such file or 
directory
|  #include <btrfs/kerncompat.h>
|                               ^
| compilation terminated.
| In file included from root-tree.c:19:0:
| ctree.h:30:24: fatal error: btrfs/list.h: No such file or directory
|  #include <btrfs/list.h>
|                         ^
| compilation terminated.



-Roy


>
>> diff --git a/Makefile b/Makefile
>> index 3d715d8..d25054f 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -107,13 +107,13 @@ endif
>>   %.o.d: %.c
>>   	$(Q)$(CC) -MM -MG -MF $@ -MT $(@:.o.d=.o) -MT $(@:.o.d=.static.o) -MT $@ $(AM_CFLAGS) $(CFLAGS) $<
>>
>> -.c.o:
>> +%.o: %.c version.h
>>   	@$(check_echo) "    [SP]     $<"
>>   	$(Q)$(check) $(AM_CFLAGS) $(CFLAGS) $<
>>   	@echo "    [CC]     $@"
>>   	$(Q)$(CC) $(AM_CFLAGS) $(CFLAGS) -c $<
>>
>> -%.static.o: %.c
>> +%.static.o: %.c version.h
>>   	@echo "    [CC]     $@"
>>   	$(Q)$(CC) $(AM_CFLAGS) $(STATIC_CFLAGS) -c $< -o $@
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>

-- 
Best Reagrds,
Roy | RongQing Li
