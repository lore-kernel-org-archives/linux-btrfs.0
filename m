Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50086 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaLKTAH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 14:00:07 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
Date: Thu, 11 Dec 2014 20:00:04 +0100
Message-ID: <3280153.UGqVGf8Kx1@merkaba>
In-Reply-To: <547D09D8.1060103@cn.fujitsu.com>
References: <547BCB43.5020505@cn.fujitsu.com> <547C64B4.2050802@gmail.com> <547D09D8.1060103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

Am Dienstag, 2. Dezember 2014, 08:37:44 schrieb Qu Wenruo:
> -------- Original Message --------
> Subject: Re: Crazy idea of cleanup the inode_record btrfsck things with SQL?
> From: Austin S Hemmelgarn <ahferroin7@gmail.com>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs
> <linux-btrfs@vger.kernel.org>
> Date: 2014年12月01日 20:53
> 
> > On 2014-11-30 20:58, Qu Wenruo wrote:
> >> [snipped]
> > 
> > So, I think this does a good job of highlighting one of the bigger
> > issues with btrfsck when it is compared to ext* and/or xfs. Despite
> > this being a problem, I really don't think using a rdbms is the way to
> > fix it, both for reasons outlined in other responses, and because fsck
> > should be as fast as possible when nothing is wrong with the fs.
> 
> Although I am not stick to the crazy idea, I think it is still needed to
> point out that,
> even btrfsck is ran on a clean btrfs, it still needs to iterate all the
> extents, metadata.
> So it may not be as fast as you thought even with the current implement.
> 
> Anyway thanks for the feedback.

As to my knowledge at some time xfs_repair struggled with memory issues as 
well. And the developers of it made an attempt at reducing memory usage. I 
think with e2fsck this has been an issue as well. So maybe might be an idea at 
the approaches the devs of these two filesystem checking tools used to reduce 
memory usage.

On the other hand it may be that XFS and Ext4 is just too different to BTRFS to 
adapt those approaches. But in the end they are all filesystems, so there may 
be enough similarities to port over some ideas.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
