Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33460 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751832AbdHARkD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 13:40:03 -0400
Received: by mail-io0-f196.google.com with SMTP id q64so2050449ioi.0
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Aug 2017 10:40:03 -0700 (PDT)
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
To: Roman Mamedov <rm@romanrm.net>, Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
 <20170801222547.35d1bd03@natsu>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <50312ea2-a0bf-09f7-8bc0-804c3a087ae4@gmail.com>
Date: Tue, 1 Aug 2017 13:39:59 -0400
MIME-Version: 1.0
In-Reply-To: <20170801222547.35d1bd03@natsu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-01 13:25, Roman Mamedov wrote:
> On Tue,  1 Aug 2017 10:14:23 -0600
> Liu Bo <bo.li.liu@oracle.com> wrote:
> 
>> This aims to fix write hole issue on btrfs raid5/6 setup by adding a
>> separate disk as a journal (aka raid5/6 log), so that after unclean
>> shutdown we can make sure data and parity are consistent on the raid
>> array by replaying the journal.
> 
> Could it be possible to designate areas on the in-array devices to be used as
> journal?
> 
> While md doesn't have much spare room in its metadata for extraneous things
> like this, Btrfs could use almost as much as it wants to, adding to size of the
> FS metadata areas. Reliability-wise, the log could be stored as RAID1 chunks.
> 
> It doesn't seem convenient to need having an additional storage device around
> just for the log, and also needing to maintain its fault tolerance yourself (so
> the log device would better be on a mirror, such as mdadm RAID1? more expense
> and maintenance complexity).
> 
I agree, MD pretty much needs a separate device simply because they 
can't allocate arbitrary space on the other array members.  BTRFS can do 
that though, and I would actually think that that would be _easier_ to 
implement than having a separate device.

That said, I do think that it would need to be a separate chunk type, 
because things could get really complicated if the metadata is itself 
using a parity raid profile.
