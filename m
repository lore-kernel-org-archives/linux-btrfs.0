Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64783 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2HNOux (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 10:50:53 -0400
Received: by yhmm54 with SMTP id m54so509970yhm.19
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 07:50:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG1y0seKBE-LMJq+G1ioB5Ls3PCD6rUiqd+5O-EpWSsDV1eOHg@mail.gmail.com>
References: <5027DDFC.60504@pocock.com.au>
	<CAG1y0scy=6NByQ9DBF_9m6MrmNrYe1WvX9-JkmbEUKWjd77w8Q@mail.gmail.com>
	<502A529B.8060201@pocock.com.au>
	<CAG1y0sdEePQbRUwvmbCqGMxfPqwCiUKxWcuxczFFEhtait1sNQ@mail.gmail.com>
	<CAE5mzvj_xX6dZVSd3joi9Pgn-yxiRA3Aa+Aqam3gj-VCbQ6C=Q@mail.gmail.com>
	<CAG1y0seKBE-LMJq+G1ioB5Ls3PCD6rUiqd+5O-EpWSsDV1eOHg@mail.gmail.com>
Date: Tue, 14 Aug 2012 08:50:52 -0600
Message-ID: <CAE5mzvhi72fVrL0aDc3ArLkoqv6TEZQA5E6uJNZ9eGXiaULUNQ@mail.gmail.com>
Subject: Re: raw partition or LV for btrfs?
From: cwillu <cwillu@cwillu.com>
To: "Fajar A. Nugraha" <list@fajar.net>
Cc: Daniel Pocock <daniel@pocock.com.au>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 14, 2012 at 8:21 AM, Fajar A. Nugraha <list@fajar.net> wrote:
> On Tue, Aug 14, 2012 at 9:09 PM, cwillu <cwillu@cwillu.com> wrote:
>>>> If I understand correctly, if I don't use LVM, then such move and resize
>>>> operations can't be done for an online filesystem and it has more risk.
>>>
>>> You can resize, add, and remove devices from btrfs online without the
>>> need for LVM. IIRC LVM has finer granularity though, you can do
>>> something like "move only the first 10GB now, I'll move the rest
>>> later".
>>
>> You can certainly resize the filesystem itself, but without lvm I
>> don't believe you can resize the underlying partition online.
>
> I'm pretty sure you can do that with parted. At least, when your
> version of parted is NOT 2.2.

block/ioctl.c:blkdev_reread_part calls into
block/partition-generic.c:rescan_partitions, which fails out early
with EBUSY if block/partition-generic.c:drop_partitions sees a
non-zero bdev->bd_part_count, which is a count of the open partition
bdev's.

Calvin mentions below that this may be changing shortly, but I'm going
to claim to be right on this one.
