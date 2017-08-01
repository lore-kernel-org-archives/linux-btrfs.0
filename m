Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40159 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751970AbdHASEn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 14:04:43 -0400
Date: Tue, 1 Aug 2017 11:03:33 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
Message-ID: <20170801170333.GC26357@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
 <20170801222547.35d1bd03@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170801222547.35d1bd03@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 01, 2017 at 10:25:47PM +0500, Roman Mamedov wrote:
> On Tue,  1 Aug 2017 10:14:23 -0600
> Liu Bo <bo.li.liu@oracle.com> wrote:
> 
> > This aims to fix write hole issue on btrfs raid5/6 setup by adding a
> > separate disk as a journal (aka raid5/6 log), so that after unclean
> > shutdown we can make sure data and parity are consistent on the raid
> > array by replaying the journal.
> 
> Could it be possible to designate areas on the in-array devices to be used as
> journal?
>
> While md doesn't have much spare room in its metadata for extraneous things
> like this, Btrfs could use almost as much as it wants to, adding to size of the
> FS metadata areas. Reliability-wise, the log could be stored as RAID1 chunks.
> 

Yes, it makes sense, we could definitely do that, that was actually
the original idea.  I started with adding a new device for log as it
looks easier to me, but I could try that now.

> It doesn't seem convenient to need having an additional storage device around
> just for the log, and also needing to maintain its fault tolerance yourself (so
> the log device would better be on a mirror, such as mdadm RAID1? more expense
> and maintenance complexity).
>

That's true.  Thanks for the suggestions.

Thanks,

-liubo
