Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:46112 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751755AbdHARZt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Aug 2017 13:25:49 -0400
Date: Tue, 1 Aug 2017 22:25:47 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
Message-ID: <20170801222547.35d1bd03@natsu>
In-Reply-To: <20170801161439.13426-1-bo.li.liu@oracle.com>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue,  1 Aug 2017 10:14:23 -0600
Liu Bo <bo.li.liu@oracle.com> wrote:

> This aims to fix write hole issue on btrfs raid5/6 setup by adding a
> separate disk as a journal (aka raid5/6 log), so that after unclean
> shutdown we can make sure data and parity are consistent on the raid
> array by replaying the journal.

Could it be possible to designate areas on the in-array devices to be used as
journal?

While md doesn't have much spare room in its metadata for extraneous things
like this, Btrfs could use almost as much as it wants to, adding to size of the
FS metadata areas. Reliability-wise, the log could be stored as RAID1 chunks.

It doesn't seem convenient to need having an additional storage device around
just for the log, and also needing to maintain its fault tolerance yourself (so
the log device would better be on a mirror, such as mdadm RAID1? more expense
and maintenance complexity).

-- 
With respect,
Roman
