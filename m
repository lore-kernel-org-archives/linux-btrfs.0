Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55314 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751878AbdF3QdI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Jun 2017 12:33:08 -0400
Date: Fri, 30 Jun 2017 18:31:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Sargun Dhillon <sargun@sargun.me>
Cc: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com, mkh@rqc.ru
Subject: Re: [PATCH v2 2/4] btrfs: Add new ioctl uapis for qgroup creation /
 removal
Message-ID: <20170630163157.GY2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170526204414.GA18176@ircssh-2.c.rugged-nimbus-611.internal>
 <20170526204439.GA18200@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170526204439.GA18200@ircssh-2.c.rugged-nimbus-611.internal>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 26, 2017 at 08:44:41PM +0000, Sargun Dhillon wrote:
> This patch introduces two new ioctls to create, and remove qgroups. These
> offer a somewhat more intuitive set of operations with the opportunity
> to add flags that gate to unintentional manipulation of qgroups.
> 
> The create qgroup ioctl has a a new semantic which level-0 qgroups cannot
> be created unless a matching subvolume ID is created.
> 
> The delete qgroup ioctl has the new semantic that it will not let you
> delete a currently utilized (referenced by a subvolume) level-0
> qgroup unless you pass the BTRFS_QGROUP_NO_SUBVOL_CHECK flag.

I'm fine with the qgroup ioctl revisions, if only to address the lack of
the flags or reserved fields. The updated semantics also justify a new
ioctl number.

On the implementation side, options are to do one ioctl per action or do
the "swiss army knife" style (multiple actions under on ioctl number).

Adding a special data structure for each ioctl is not necessary, as you
can see, btrfs_ioctl_qgroup_create_args_v2 and
btrfs_ioctl_qgroup_remove_args_v2 are the same. Although we could extend
them in different ways in the future, this could also happen if it were
just one structure and flags are set to denote meaning of whatever new
struct members would be added.

I'd go for something similar as the subvolume creation/deletion ioctls,
to have separate ioctl numbers assigned but use the same structure.

Similar to the mount options, new ioctls need some time to settle, but
merging this patchset in 4.13 seems still doable.
