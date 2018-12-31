Return-Path: <SRS0=2sbY=PI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FEAC43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Dec 2018 15:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D902E206BB
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Dec 2018 15:52:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nuclearwinter.com header.i=@nuclearwinter.com header.b="EUjOITzh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbeLaPwO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 31 Dec 2018 10:52:14 -0500
Received: from titan.nuclearwinter.com ([205.185.120.7]:43214 "EHLO
        titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbeLaPwN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Dec 2018 10:52:13 -0500
Received: from [IPv6:2601:6c5:8000:6b90:54ff:ba2b:b29:792c] ([IPv6:2601:6c5:8000:6b90:54ff:ba2b:b29:792c])
        (authenticated bits=0)
        by titan.nuclearwinter.com (8.14.7/8.14.7) with ESMTP id wBVFq4LW023229
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO)
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Dec 2018 10:52:09 -0500
DKIM-Filter: OpenDKIM Filter v2.11.0 titan.nuclearwinter.com wBVFq4LW023229
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nuclearwinter.com;
        s=201211; t=1546271529;
        bh=gc5tKduCdVMY3Qu4Tl6ap0pf3LrIRDm6JiQTNatf0Ho=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=EUjOITzh6NZw3W597SjsIU7YR0HCmqDbiHoyTWONFi5VUALkowwP9ndTo7F8FOu7y
         ARG1spafD/4oTkt7r+i+cMQ4J3SLrL96cgbL4RyV2vc/GUJxXPIkzsPXESoAQhtWCw
         nKx6gkBAHhke1alefbsowT6hE585zWLll0RiHIGk=
Subject: Re: Scrub aborts due to corrupt leaf
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com>
 <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
 <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com>
 <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
 <dd08eb00-faf8-cd88-aeb6-e5ed75a2889f@nuclearwinter.com>
 <4652a690-26ed-fb90-9386-3020ee9e9841@applied-asynchrony.com>
 <CAJCQCtTV3a9rH6ystLCbLUVoh4b1LL5yXWiOBPp6Fa28efZf_w@mail.gmail.com>
 <35ccf3c1-c18d-cce9-23b8-d24a35fe5549@mendix.com>
 <9e6b268b-b545-bad1-f33a-b29ea1af7db0@nuclearwinter.com>
 <CAJCQCtSbLkpYnwEO05D5R2oXVznJ3KwBxjyfBDnM4PaGwSXUhg@mail.gmail.com>
 <3f3020c0-2643-074d-b88d-02123ece911c@nuclearwinter.com>
 <CAJCQCtTc49Qe3_zN7OVF7TQbONhdsh4-383=ttu_0i-5OOig7g@mail.gmail.com>
 <CAJCQCtQ68Oz=biJ=Z5fZJiqB0QzAR6mK_1eRvuqYXZjecL3bxw@mail.gmail.com>
From:   Larkin Lowrey <llowrey@nuclearwinter.com>
Message-ID: <b8b50f6e-60ed-6988-0556-50c94c077099@nuclearwinter.com>
Date:   Mon, 31 Dec 2018 10:52:00 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ68Oz=biJ=Z5fZJiqB0QzAR6mK_1eRvuqYXZjecL3bxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (titan.nuclearwinter.com [IPv6:2605:6400:20:950:ed61:983f:b93a:fc2b]); Mon, 31 Dec 2018 10:52:09 -0500 (EST)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 10/11/2018 12:15 AM, Chris Murphy wrote:
> Is this a 68T file system? Seems excessive.
> Haha, by excessive I mean nuking such a big fs just for being unable
> to remove the space tree. I'm quite sure the devs would like to get
> that crashing bug fixed, anyway.

A second FS just started failing. I never had this much trouble with 
space cache v1.

This host had a DIMM failure a couple of weeks ago which caused the 
system to halt due to uncorrectable ECC error(s). That was the only 
recent unsafe shutdown. Other than that, things have been running 
normally until today when the FS went read-only during backups. As with 
the other host, I tried to clear the space-cache (v2) before doing a 
'check --repair' but got this:

[root@fubar ~]# btrfs check --clear-space-cache=v2 /dev/Cached/Nearline
Opening filesystem to check...
Checking filesystem on /dev/Cached/Nearline
UUID: 68d31d5f-97a2-4a73-a398-c7c13ff439a5
Clear free space cache v2
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
bad tree block 271262429573120, bytenr mismatch, want=271262429573120, 
have=17478763091281320157
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
bad tree block 271262429573120, bytenr mismatch, want=271262429573120, 
have=17478763091281320157
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
bad tree block 271262429573120, bytenr mismatch, want=271262429573120, 
have=17478763091281320157
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
bad tree block 271262429573120, bytenr mismatch, want=271262429573120, 
have=17478763091281320157
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
bad tree block 271262429573120, bytenr mismatch, want=271262429573120, 
have=17478763091281320157
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
bad tree block 271262429573120, bytenr mismatch, want=271262429573120, 
have=17478763091281320157
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
bad tree block 271262429573120, bytenr mismatch, want=271262429573120, 
have=17478763091281320157
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
bad tree block 271262429573120, bytenr mismatch, want=271262429573120, 
have=17478763091281320157
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
bad tree block 271262429573120, bytenr mismatch, want=271262429573120, 
have=17478763091281320157
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
bad tree block 271262429573120, bytenr mismatch, want=271262429573120, 
have=17478763091281320157
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
bad tree block 271262429573120, bytenr mismatch, want=271262429573120, 
have=17478763091281320157
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
bad tree block 271262429573120, bytenr mismatch, want=271262429573120, 
have=17478763091281320157
extent-tree.c:2703: alloc_reserved_tree_block: BUG_ON `ret` triggered, 
value -17
btrfs(+0x1ff96)[0x55eae7dc5f96]
btrfs(+0x2109f)[0x55eae7dc709f]
btrfs(+0x2115e)[0x55eae7dc715e]
btrfs(+0x22054)[0x55eae7dc8054]
btrfs(+0x22c57)[0x55eae7dc8c57]
btrfs(btrfs_alloc_free_block+0xc2)[0x55eae7dcca72]
btrfs(__btrfs_cow_block+0x18a)[0x55eae7dbc05a]
btrfs(btrfs_cow_block+0x104)[0x55eae7dbc874]
btrfs(btrfs_search_slot+0x35f)[0x55eae7dbf6cf]
btrfs(btrfs_clear_free_space_tree+0x104)[0x55eae7de8b54]
btrfs(cmd_check+0xb11)[0x55eae7e0ce31]
btrfs(main+0x88)[0x55eae7dbaaa8]
/lib64/libc.so.6(__libc_start_main+0xf3)[0x7fead8094413]
btrfs(_start+0x2e)[0x55eae7dbabbe]
Aborted (core dumped)

# btrfs fi show /public/nearline/
Label: none  uuid: 68d31d5f-97a2-4a73-a398-c7c13ff439a5
         Total devices 1 FS bytes used 61.09TiB
         devid    1 size 65.25TiB used 61.45TiB path 
/dev/mapper/Cached-Nearline

# btrfs fi df /public/nearline/
Data, single: total=61.39TiB, used=61.03TiB
System, single: total=32.00MiB, used=6.59MiB
Metadata, single: total=67.00GiB, used=65.85GiB
GlobalReserve, single: total=512.00MiB, used=4.02MiB

# btrfs fi usage /public/nearline/
Overall:
     Device size:                  65.25TiB
     Device allocated:             61.45TiB
     Device unallocated:            3.79TiB
     Device missing:                  0.00B
     Used:                         61.09TiB
     Free (estimated):              4.15TiB      (min: 4.15TiB)
     Data ratio:                       1.00
     Metadata ratio:                   1.00
     Global reserve:              512.00MiB      (used: 4.02MiB)

Data,single: Size:61.39TiB, Used:61.03TiB
    /dev/mapper/Cached-Nearline    61.39TiB

Metadata,single: Size:67.00GiB, Used:65.85GiB
    /dev/mapper/Cached-Nearline    67.00GiB

System,single: Size:32.00MiB, Used:6.59MiB
    /dev/mapper/Cached-Nearline    32.00MiB

Unallocated:
    /dev/mapper/Cached-Nearline     3.79TiB

4.19.10-300.fc29.x86_64
btrfs-progs v4.17.1

I haven't nuked the other FS yet so I now have two that are either in 
the same or at least very similar states.

What additional information can I provide?

--Larkin
