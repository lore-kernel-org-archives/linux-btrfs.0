Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aquinas.techsquare.com ([75.125.237.226]:55106 "EHLO
	techsquare.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932681AbcHJA4l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Aug 2016 20:56:41 -0400
To: Chris Murphy <lists@colorremedies.com>
References: <a70af895-6d3e-3b8a-eeb3-71d6609f8154@techsquare.com>
 <CAJCQCtReDSm46LVVZaiMO3oSRgi9EBQnY9+JkH6Fia1SFH4AWg@mail.gmail.com>
 <CAJCQCtSR6S_RQ5eMjQC9qwifEakme58uw11wHcewiDxqNfq_kw@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Matt McKinnon <matt@techsquare.com>
Message-ID: <464fbfee-82fd-be32-1fc2-6635742ac2a2@techsquare.com>
Date: Tue, 9 Aug 2016 20:56:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSR6S_RQ5eMjQC9qwifEakme58uw11wHcewiDxqNfq_kw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Subject: Re: BTRFS: error (device sda1) in btrfs_run_delayed_refs:2963:
 errno=-17 Object already exists
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

# btrfs check /dev/sda1
Checking filesystem on /dev/sda1
UUID: 33f9089e-acc7-4a39-8b83-b18bb182faaf
checking extents
ref mismatch on [958277767168 5894144] extent item 0, found 1
Backref 958277767168 root 257 owner 15799573 offset 750342144 num_refs 0 
not found in extent tree
Incorrect local backref count on 958277767168 root 257 owner 15799573 
offset 750342144 found 1 wanted 0 back 0x15d380f90
backpointer mismatch on [958277767168 5894144]
ref mismatch on [958298935296 9666560] extent item 0, found 2
Backref 958298935296 root 257 owner 15799573 offset 559185920 num_refs 0 
not found in extent tree
Incorrect local backref count on 958298935296 root 257 owner 15799573 
offset 559185920 found 2 wanted 0 back 0x15d3809a0
backpointer mismatch on [958298935296 9666560]


about 859 of those ...

Then:

owner ref check failed [25737445867520 16384]
checking free space cache
There is no free space entry for 109105479680-109105496064
There is no free space entry for 109105479680-109551026176
cache appears valid but isn't 109014155264
There is no free space entry for 139709693952-139709710336
There is no free space entry for 139709693952-140152668160
cache appears valid but isn't 139615797248
Wanted offset 171291525120, found 171291426816
Wanted offset 171291525120, found 171291426816
cache appears valid but isn't 171291181056
Wanted offset 220146597888, found 220146532352
Wanted offset 220146597888, found 220146532352
cache appears valid but isn't 220146434048
btrfs: unable to add free space :-17
free-space-cache.c:824: btrfs_add_free_space: Assertion `ret == -EEXIST` 
failed.
btrfs[0x464af9]
btrfs(btrfs_add_free_space+0x154)[0x46531f]
btrfs(load_free_space_cache+0xab7)[0x465e36]
btrfs(cmd_check+0x22c7)[0x42db0e]
btrfs(main+0x155)[0x40a4fd]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7faad34cdf45]
btrfs[0x40a0f9]


and we crashed out of the check there.

-Matt

On 08/09/2016 08:06 PM, Chris Murphy wrote:
> On Tue, Aug 9, 2016 at 6:01 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> On Tue, Aug 9, 2016 at 5:15 PM, Matt McKinnon <matt@techsquare.com> wrote:
>>> Hello,
>>>
>>> Our server recently crashed and was rebooted.  When it returned our BTRFS
>>> volume is mounting read-only:
>>
>> What happens when you try mounting with -o usebackuproot ?
>>
>> If that fails, what output do you get for 'btrfs check' (without
>> --repair)? If you only get some "errors 400, nbytes wrong" then
>> --repair should fix the problem.
>
> This could also be a regression somewhere...
> https://bugzilla.kernel.org/show_bug.cgi?id=60522
>
>
