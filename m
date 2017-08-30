Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40644 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751263AbdH3KuB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Aug 2017 06:50:01 -0400
Date: Wed, 30 Aug 2017 12:48:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Aleksa Sarai <asarai@suse.de>
Cc: Nikolay Borisov <nborisov@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: resume qgroup rescan on rw remount
Message-ID: <20170830104833.GO2866@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170704114906.8419-1-asarai@suse.de>
 <725eb058-4fb4-a167-9ba4-a062de718555@suse.com>
 <532a6e98-1745-4181-260a-38f4d5015857@suse.com>
 <20170711170335.GV2866@twin.jikos.cz>
 <dd27c645-b952-c2a2-161e-0ee543a49739@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <dd27c645-b952-c2a2-161e-0ee543a49739@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 26, 2017 at 04:39:02PM +1000, Aleksa Sarai wrote:
> On 07/12/2017 03:03 AM, David Sterba wrote:
> > On Mon, Jul 10, 2017 at 04:56:36PM +0300, Nikolay Borisov wrote:
> >> On 10.07.2017 16:12, Nikolay Borisov wrote:
> >>> On  4.07.2017 14:49, Aleksa Sarai wrote:
> >>>> Several distributions mount the "proper root" as ro during initrd and
> >>>> then remount it as rw before pivot_root(2). Thus, if a rescan had been
> >>>> aborted by a previous shutdown, the rescan would never be resumed.
> >>>>
> >>>> This issue would manifest itself as several btrfs ioctl(2)s causing the
> >>>> entire machine to hang when btrfs_qgroup_wait_for_completion was hit
> >>>> (due to the fs_info->qgroup_rescan_running flag being set but the rescan
> >>>> itself not being resumed). Notably, Docker's btrfs storage driver makes
> >>>> regular use of BTRFS_QUOTA_CTL_DISABLE and BTRFS_IOC_QUOTA_RESCAN_WAIT
> >>>> (causing this problem to be manifested on boot for some machines).
> >>>>
> >>>> Cc: <stable@vger.kernel.org> # v3.11+
> >>>> Cc: Jeff Mahoney <jeffm@suse.com>
> >>>> Fixes: b382a324b60f ("Btrfs: fix qgroup rescan resume on mount")
> >>>> Signed-off-by: Aleksa Sarai <asarai@suse.de>
> >>>
> >>> Indeed, looking at the code it seems that b382a324b60f ("Btrfs: fix
> >>> qgroup rescan resume on mount") missed adding the qgroup_rescan_resume
> >>> in the remount path. One thing which I couldn't verify though is whether
> >>> reading fs_info->qgroup_flags without any locking is safe from remount
> >>> context.
> >>>
> >>> During remount I don't see any locks taken that prevent operations which
> >>> can modify qgroup_flags.
> >>
> >> Further inspection reveals that the access rules to qgroup_flags are
> >> somewhat broken so this patch doesn't really make things any worse than
> >> they are.
> > 
> > The usage follows a pattern for a bitfield, updated by set_bit/clear_bit
> > etc. The updates to the state or inconsistency is not safe, so some
> > updates could get lost under some circumstances.
> > 
> > Patch added to devel queue, possibly will be submitted to 4.13 so stable
> > can pick it.
> 
> Looks like it wasn't merged in the 4.13 window (so stable hasn't picked 
> it), will this be submitted for 4.14? Thanks.

Sorry this didn't make it to 4.13, the patch is in the queue for 4.14.
