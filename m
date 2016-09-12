Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:51321 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755843AbcILMqo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 08:46:44 -0400
Subject: Re: btrfstune -x -> extent-tree.c:2688: btrfs_reserve_extent:
 Assertion `ret` failed.
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <478c1cee-80f0-c8f3-0bb9-c8c8932a9fb5@mendix.com>
 <20160912123946.GC16983@twin.jikos.cz>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <a6c78673-935e-7774-e2f8-f6f80130d5f5@mendix.com>
Date: Mon, 12 Sep 2016 14:46:37 +0200
MIME-Version: 1.0
In-Reply-To: <20160912123946.GC16983@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/12/2016 02:39 PM, David Sterba wrote:
> On Fri, Sep 09, 2016 at 11:37:21PM +0200, Hans van Kranenburg wrote:
>> Hi,
>>
>> While trying to enable skinny metadata on a filesystem, I got this error
>> (after minutes of reading from disk by the program):
>>
>> -# btrfstune -x /dev/xvdb
>> extent-tree.c:2688: btrfs_reserve_extent: Assertion `ret` failed.
>> btrfstune[0x410ef6]
>> btrfstune[0x410f1d]
>> btrfstune(btrfs_reserve_extent+0x781)[0x41522e]
>> btrfstune(btrfs_alloc_free_block+0x63)[0x415413]
>> btrfstune(__btrfs_cow_block+0xfc)[0x409176]
>> btrfstune(btrfs_cow_block+0x8b)[0x409718]
>> btrfstune[0x40d8ad]
>> btrfstune(btrfs_commit_transaction+0xb8)[0x40f10d]
>> btrfstune(main+0x3b3)[0x407e31]
>> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7f945fa06700]
>> btrfstune(_start+0x29)[0x408509]
>>
>> This is a ~40TiB filesystem that was created about one and a half year
>> ago, has grown from 1TiB to this size now and has always been running
>> with the Debian 3.16-ckt kernel.
>>
>> # uname -a
>> Linux backups-dolly 4.7.0-1-amd64 #1 SMP Debian 4.7.2-1 (2016-08-28)
>> x86_64 GNU/Linux
>>
>> # btrfs version
>> btrfs-progs v4.7.1
>>
>> One of the things I already did earlier today was switching to
>> space_cache=v2
>>
>> Does the shown error ring a bell? What's the next step to debug this?
> 
> It's a bug in the incompat bit handling the free-space-tree. Opening the
> filesystem for read-write should not be allowed, but was mistakenly
> enabled by me.
> 
>> The filesystem is a clone of the production filesystem (not btrfs clone,
>> but lower level, on iSCSI storage) meant to be used for upgrade-testing
>> and performance testing, so if anything goes wrong in whatever way,
>> there will be no panicing involved.
> 
> The fix is in devel, but it'd mean that writing to a v2-enabled
> filesystem will not work (which also means changing some fatures via
> btrfstune as it uses the transaction mechanism that needs to cow blocks
> and update free space etc).

As I replied this morning, I tried it again on a fresh clone of the
underlying snapshot, before doing anything else first with it.

So that means at that point it's a filesystem that has only seen 3.16
kernels before, and does still have old free space cache in place, no v2
tree.

And, it still blows up.

-- 
Hans van Kranenburg
