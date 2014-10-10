Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaJJHjz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 03:39:55 -0400
Date: Fri, 10 Oct 2014 09:39:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2] btrfs-progs: force overwrite should wipe stale SB
Message-ID: <20141010073949.GE22943@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20141001112606.GO11436@twin.jikos.cz>
 <1412205729-20938-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412205729-20938-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 02, 2014 at 07:22:09AM +0800, Anand Jain wrote:
> (I am unable to reproduce the issue, tried to go back with progs versions
> but still the same. So as of now this code remains untested, suggest to
> wait till we have a reproducible test case).
> 
> Here is a test case which says it all..
> 
> mkfs.xfs -f $DEV
> mkfs.btrfs -f $DEV
> mount $DEV $MNT
> mount: /dev/vdiskc: more filesystems detected. This should not happen,
>        use -t <type> to explicitly specify the filesystem type or
>        use wipefs(8) to clean up the device.
> 
> mount: you must specify the filesystem type
> 
> with this patch btrfs_prepare_device() also wipes old FS if any,
> btrfs_prepare_device() is called after we have verified that
> user has provided -f option.
> 
> v2: to satisfy the backward compatibility issue, replace
> blkid_do_wipe() with local wipe function.

Thank you, works for me, added to 3.17 queue.
