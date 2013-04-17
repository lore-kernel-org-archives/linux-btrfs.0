Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965303Ab3DQRMG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Apr 2013 13:12:06 -0400
Date: Wed, 17 Apr 2013 19:12:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: a copy of superblock is zero may not mean
 btrfs is not there
Message-ID: <20130417171204.GB16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1365753306-19412-1-git-send-email-anand.jain@oracle.com>
 <20130416115756.GJ18193@twin.jikos.cz>
 <516E069D.4070103@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <516E069D.4070103@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 17, 2013 at 10:19:09AM +0800, Anand Jain wrote:
> 
> 
> On 04/16/2013 07:57 PM, David Sterba wrote:
> >On Fri, Apr 12, 2013 at 03:55:06PM +0800, Anand Jain wrote:
> >>If one of the copy of the superblock is zero it does not
> >>confirm to us that btrfs isn't there on that disk. When
> >>we are having more than one copy of superblock we should
> >>rather let the for loop to continue to check other copies.
> >>
> >>the following test case and results would justify the
> >>fix
> >>
> >>mkfs.btrfs /dev/sdb /dev/sdc -f
> >>mount /dev/sdb /btrfs
> >>dd if=/dev/zero bs=1 count=8 of=/dev/sdc seek=$((64*1024+64))
> >>~/before/btrfs-select-super -s 1 /dev/sdc
> >>using SB copy 1, bytenr 67108864
> >>
> >>here btrfs-select-super just wrote superblock to a mounted btrfs
> >
> >Why does not check_mounted() catch this in the first place? Ie. based on
> >the status in /proc/mounts not on random bytes in the superblock.
> 
>  the reason is, as of now /proc/mounts just knows about the devid 1.

My oversight, it's mkfs on sdb and select-super on sdc, but then sdc is
already open and the open(O_EXCL) should prevent that, right? The same
way mkfs checks whether all the devices are available.

david
