Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:56379 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbbKJIQk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 03:16:40 -0500
Subject: Re: Ideas for btrfs-convert fix(or rework)
To: Roman Mamedov <rm@romanrm.net>
References: <56418E5D.9020604@gmx.com> <20151110125501.1aa6f155@natsu>
Cc: btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5641A7DA.6010102@gmx.com>
Date: Tue, 10 Nov 2015 16:16:26 +0800
MIME-Version: 1.0
In-Reply-To: <20151110125501.1aa6f155@natsu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Roman Mamedov wrote on 2015/11/10 12:55 +0500:
> On Tue, 10 Nov 2015 14:27:41 +0800
> Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>>      But without such work, btrfs-convert will always be a mess and no
>>      real support for balance.
>
> I wonder, what happened to the current btrfs-convert?
>
> Perhaps a couple of years ago I converted a 7TB and ~70% full Ext4 filesystem
> into Btrfs. At first the result showed up to have about 3TB of Metadata
> chunks, but several iterations of balance reclassified this as Data (and thus
> made it practical to also enable Metadata DUP). Everything went flawlessly and
> with no data loss whatsoever.

Old btrfs-convert works well, since it's using mixed block group and 
using it correctly.
It's quite hard to mess chunk types up if they can be both data and 
metadata.

But in that case, kernel doesn't support to convert mixed block group 
into separate ones.

Which means you will only get mixed block groups, and no method to get 
normal separate data/meta block groups.

So if things are correct, the btrfs you converted should still be in 
mixed-bg mode.
A recent 'btrfs fi df' command should show things like:
Data+Metadata, DUP: total=512.00MiB, used=68.23MiB

>
> But as we know recently there were reports that it now causes corruption or
> does not work. So I wonder what happened that broke it, and is there really no
> simpler fix? Even if requiring the user to balance to get rid of the bloated
> Metadata like I had to.
>

Yes, current btrfs-convert has problem on marking chunk meta or data.
Resulting some data extents may lay in metadata chunk, and vice verse.
At least it won't pass latest btrfsck.

In that incorrect chunk layout, I'm not surprised any thing go wrong.


For alternative fix, David mentioned one, but that's going to land in 
kernel, to support convert mixed block group.
And then we can still use the old mixed-bg method for btrfs-convert.
But I'm not sure if it

Thanks,
Qu
