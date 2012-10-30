Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49463 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab2J3U7I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 16:59:08 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so734860oag.19
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2012 13:59:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <508F2B44.5090408@oracle.com>
References: <1351333721-3220-1-git-send-email-bo.li.liu@oracle.com>
	<CAKcLGm_sWkwROKfYA_7cUt=kBSL_WWsoO7AegeCFG8GPczs2kw@mail.gmail.com>
	<508F2B44.5090408@oracle.com>
Date: Tue, 30 Oct 2012 15:59:07 -0500
Message-ID: <CAKcLGm_Qg7Kvv5=bxPZA4hZn75j3Kr-FwZ3PXqARKrdZ+8XNiA@mail.gmail.com>
Subject: Re: [PATCH 1/2 v4] Btrfs: snapshot-aware defrag
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 29, 2012 at 8:20 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On 10/30/2012 04:06 AM, Mitch Harder wrote:
>> On Sat, Oct 27, 2012 at 5:28 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>>> This comes from one of btrfs's project ideas,
>>> As we defragment files, we break any sharing from other snapshots.
>>> The balancing code will preserve the sharing, and defrag needs to grow this
>>> as well.
>>>
>>> Now we're able to fill the blank with this patch, in which we make full use of
>>> backref walking stuff.
>>>
>>> Here is the basic idea,
>>> o  set the writeback ranges started by defragment with flag EXTENT_DEFRAG
>>> o  at endio, after we finish updating fs tree, we use backref walking to find
>>>    all parents of the ranges and re-link them with the new COWed file layout by
>>>    adding corresponding backrefs.
>>>
>>> Originally patch by Li Zefan <lizf@cn.fujitsu.com>
>>> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
>>> ---
>>> v3->v4:
>>>       - fix duplicated refs bugs detected by mounting with autodefrag, thanks
>>>         for the bug report from Mitch and Chris.
>>>
>>
>> I'm picking up many WARN_ON messages while testing this patch.
>>
>> I'm testing a snapshot script that uses kernel git sources along with
>> some git manipulations.
>>
>> The kernel is a 3.6.4 kernel merged with the latest for-linus branch.
>>
>> I mounted with -o compress-force=lzo,autodefrag.
>>
>> I also have the second patch in this set (Btrfs: make snapshot-aware
>> defrag as a mount option).  However, I did not mount with
>> 'snap_aware_defrag'.
>>
>> I did not find any corrupted data, and the partition passes a btrfsck
>> without error after these warnings were observed.
>>
>
> Hi Mitch,
>
> Well, good report, but I don't think it has anything to do with this patch(since you
> didn't mount with 'snap_aware_defrag' :)
>

I've re-run my my testing script with a combination of no compression
and lzo compression, combined with no further options, only -o
autodefrag, and -o autodefrag,snap_aware_defrag.

I only get the WARN_ONs when I run with autodefrag only (no snap_aware_defrag).

My logs are clean when I avoid all defrag options, or use both
autodefrag and snap_aware_defrag.

> After going through the below messages, the bug comes from the space side where we
> must have mis-used our reservation somehow.
>
> So can you show me your script so that I can give it a shot to reproduce locally?
>
