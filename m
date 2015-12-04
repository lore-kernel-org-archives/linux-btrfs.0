Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24819 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbbLDSX1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 13:23:27 -0500
Date: Fri, 4 Dec 2015 10:23:04 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Make btrfs-progs really compatible with any
 kernel version
Message-ID: <20151204182304.GB8792@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
 <20151123175608.GI31035@twin.jikos.cz>
 <20151204014402.GF19589@localhost.localdomain>
 <5660F5A3.3080409@cn.fujitsu.com>
 <20151204025309.GI19589@localhost.localdomain>
 <56610F43.4060306@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56610F43.4060306@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 04, 2015 at 11:57:55AM +0800, Qu Wenruo wrote:
> 
> 
> Liu Bo wrote on 2015/12/03 18:53 -0800:
> >On Fri, Dec 04, 2015 at 10:08:35AM +0800, Qu Wenruo wrote:
> >>
> >>
> >>Liu Bo wrote on 2015/12/03 17:44 -0800:
> >>>On Mon, Nov 23, 2015 at 06:56:09PM +0100, David Sterba wrote:
> >>>>On Mon, Nov 23, 2015 at 08:56:13PM +0800, Anand Jain wrote:
> >>>>>Btrfs-progs is a tool for the btrfs kernel and we hope latest btrfs-progs
> >>>>>be compatible w any set of older/newer kernels.
> >>>>>
> >>>>>So far mkfs.btrfs and btrfs-convert sets the default features, for eg,
> >>>>>skinny-metadata even if the running kernel does not supports it, and
> >>>>>so the mount fails on the running.
> >>>>
> >>>>So the default behaviour of mkfs will try to best guess the feature set
> >>>>of currently running kernel. I think this is is the most common scenario
> >>>>and justifies the change in default behaviours.
> >>>>
> >>>>For the other cases I'd like to introduce some human-readable shortcuts
> >>>>to the --features option. Eg. 'mkfs.btrfs -O compat-3.2' will pick all
> >>>>options supported by the unpatched mainline kernel of version 3.2. This
> >>>>would be present for all version, regardless if there was a change in the
> >>>>options or not.
> >>>>
> >>>>Similarly for convenience, add 'running' that would pick the options
> >>>>from running kernel but will be explicit.
> >>>>
> >>>>A remaining option should override the 'running' behaviour and pick the
> >>>>latest mkfs options. Naming it 'defaults' sounds a bit ambiguous so the
> >>>>name is yet to be determined.
> >>>>
> >>>>>Here in this set of patches will make sure the progs understands the
> >>>>>kernel supported features.
> >>>>>
> >>>>>So in this patch, checks if sysfs tells whether the feature is
> >>>>>supported if not, then it will relay on static kernel version which
> >>>>>provided that feature (skinny-metadata here in this example), next
> >>>>>if for some reason the running kernel does not provide the kernel
> >>>>>version, then it will fall back to the original method to enable
> >>>>>the feature with a hope that kernel will support it.
> >>>>>
> >>>>>Also the last patch adds a warning when we fail to read either
> >>>>>sysfs features or the running kernel version.
> >>>>
> >>>>Your patchset is a good start, the additional options I've described can
> >>>>be added on top of that. We might need to switch the version
> >>>>representation from string to KERNEL_VERSION but that's an
> >>>>implementation detail.
> >>>
> >>>Depending on sysfs is stable but depending on kernel version may be not,
> >>>we may have a distro kernel which backports some incompat features from
> >>>upstream, then we have to decide based on sysfs interface.
> >>
> >>+1.
> >>
> >>Although sysfs does not always show up even for supported kernel, e.g btrfs
> >>modules is not loaded after boot.
> >>So we need to consider twice before choosing a fallback method.
> >>
> >>>
> >>>However, this brings another problems, for very old kernels, they don't
> >>>have sysfs, do you have any suggestions for that?
> >>
> >>Other fs, like xfs/ext* doesn't even have sysfs feature interface, only
> >>release announcement mentioning default behavior change.
> >>And I don't see many users complaining about it.
> >>
> >>Here is the example of xfsprogs changed its default feature recently:
> >>In 10th, June, 2015, xfsprogs v3.2.3 is released, with new default feature
> >>of enabling CRC for fs.
> >>The first supported kernel is 3.15, which is release in 8th Jun, 2014.
> >>Almost one year ago.
> >
> >It's the same thing, if you use a earlier version(before v5) xfs and a
> >v5 xfsprogs, you are not going to mount it.
> >
> >>
> >>On the other hand, the sysfs feature is introduced at the end of year 2013.
> >>It's already over 2 years.
> >>
> >>So just forgot the extra minor case of super old kernel would be good
> >>enough.
> >
> >Sorry we're not able to do that since most users won't keep up upgrading their
> >kernels to the latest one, instead they use the stable one they think.
> >
> >The fact is that btrfs has way more incompatible features than either ext4 or xfs,
> >and no complain on ext4/xfs from them won't solve our btrfs issue anyway.
> >
> >The problem is much more serious for enterprise users which are sort of
> >conservative, they would backport what they need, if they use
> >btrfs they will experience the painful things.
> 
> Only if enterprise really think btrfs is stable enough.
> For this point, xfs is considered more stable than btrfs, but v5 xfs recent
> change doesn't introduce such facility to do that compatibility check in
> xfsprogs.

Xfs on kernel side obviously refuses to mount if you create an incompatible
feature with a recent xfsprogs but try to mount it with older kernel.

STATIC int
xfs_mount_validate_sb()
{
	...
	if (xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_UNKNOWN)) {         
		xfs_warn(mp,                                             
		"Superblock has unknown incompatible features (0x%x) enabled.",                  
                                 (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_UNKNOWN));  
		xfs_warn(mp,
		"Filesystem can not be safely mounted by this kernel.");                         
		return -EINVAL;                                          
	}                                                                
	...
}


And this did happen:
http://comments.gmane.org/gmane.comp.file-systems.xfs.general/69514

> 
> >
> >There're plenty of fixes for progs code, people needs stabler recovery
> >tools rather than new features they may not use.
> >
> >So we'd like to have a univeral progs code for old kernels.
> 
> Overall, btrfs is considered as a fast-moving and not that stable fs (at
> least not as stable as ext4/xfs).
> And users are always encourages to use latest kernel for these reason.
> 
> Shouldn't we do such thing when btrfs is stable enough?

That's not true, we use a stable kernel instead, which has a stable btrfs,
it's not latest kernel but stable kernel that is more suitable for production use.

We offer btrfs support as the customers requested, I asked for this
because our customer needs btrfs-progs to be wiser on this feature selecting stuff.

Thanks,

-liubo
