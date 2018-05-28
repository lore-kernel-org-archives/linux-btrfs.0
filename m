Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51459 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932473AbeE1QZX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 12:25:23 -0400
Received: from relay2.suse.de (charybdis-ext-too.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 88D04AB3D
        for <linux-btrfs@vger.kernel.org>; Mon, 28 May 2018 16:25:22 +0000 (UTC)
Date: Mon, 28 May 2018 18:22:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/2] btrfs: qgroup: Search commit root for rescan to
 avoid missing extent
Message-ID: <20180528162236.GG6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180514013813.30763-1-wqu@suse.com>
 <20180523072939.23538-1-wqu@suse.com>
 <4bcfd274-9ce0-81b4-ab0a-e5f7e8aa9ed4@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4bcfd274-9ce0-81b4-ab0a-e5f7e8aa9ed4@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 23, 2018 at 10:32:13AM +0300, Nikolay Borisov wrote:
> 
> 
> On 23.05.2018 10:29, Qu Wenruo wrote:
> > When doing qgroup rescan using the following script (modified from
> > btrfs/017 test case), we can sometimes hit qgroup corruption.
> > 
> > ------
> > umount $dev &> /dev/null
> > umount $mnt &> /dev/null
> > 
> > mkfs.btrfs -f -n 64k $dev
> > mount $dev $mnt
> > 
> > extent_size=8192
> > 
> > xfs_io -f -d -c "pwrite 0 $extent_size" $mnt/foo > /dev/null
> > btrfs subvolume snapshot $mnt $mnt/snap
> > 
> > xfs_io -f -c "reflink $mnt/foo" $mnt/foo-reflink > /dev/null
> > xfs_io -f -c "reflink $mnt/foo" $mnt/snap/foo-reflink > /dev/null
> > xfs_io -f -c "reflink $mnt/foo" $mnt/snap/foo-reflink2 > /dev/unll
> > btrfs quota enable $mnt
> > 
> >  # -W is the new option to only wait rescan while not starting new one
> > btrfs quota rescan -W $mnt
> > btrfs qgroup show -prce $mnt
> > umount $mnt
> > 
> >  # Need to patch btrfs-progs to report qgroup mismatch as error
> > btrfs check $dev || _fail
> > ------
> > 
> > For fast machine, we can hit some corruption which missed accounting
> > tree blocks:
> > ------
> > qgroupid         rfer         excl     max_rfer     max_excl parent  child
> > --------         ----         ----     --------     -------- ------  -----
> > 0/5           8.00KiB        0.00B         none         none ---     ---
> > 0/257         8.00KiB        0.00B         none         none ---     ---
> > ------
> > 
> > This is due to the fact that we're always searching commit root for
> > btrfs_find_all_roots() at qgroup_rescan_leaf(), but the leaf we get is
> > from current transaction, not commit root.
> > 
> > And if our tree blocks get modified in current transaction, we won't
> > find any owner in commit root, thus causing the corruption.
> > 
> > Fix it by searching commit root for extent tree for
> > qgroup_rescan_leaf().
> > 
> > Reported-by: Nikolay Borisov <nborisov@suse.com>
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

V3 replaced in misc-next, thanks.
