Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47306 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbbLDOV2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Dec 2015 09:21:28 -0500
Date: Fri, 4 Dec 2015 15:19:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: bo.li.liu@oracle.com, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Make btrfs-progs really compatible with any
 kernel version
Message-ID: <20151204141936.GH31035@suse.cz>
Reply-To: dsterba@suse.cz
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
 <20151123175608.GI31035@twin.jikos.cz>
 <20151204014402.GF19589@localhost.localdomain>
 <5660F5A3.3080409@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5660F5A3.3080409@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 04, 2015 at 10:08:35AM +0800, Qu Wenruo wrote:
> Liu Bo wrote on 2015/12/03 17:44 -0800:
> > On Mon, Nov 23, 2015 at 06:56:09PM +0100, David Sterba wrote:
> >> On Mon, Nov 23, 2015 at 08:56:13PM +0800, Anand Jain wrote:
> >>> Btrfs-progs is a tool for the btrfs kernel and we hope latest btrfs-progs
> >>> be compatible w any set of older/newer kernels.
> >>>
> >>> So far mkfs.btrfs and btrfs-convert sets the default features, for eg,
> >>> skinny-metadata even if the running kernel does not supports it, and
> >>> so the mount fails on the running.
> >>
> >> So the default behaviour of mkfs will try to best guess the feature set
> >> of currently running kernel. I think this is is the most common scenario
> >> and justifies the change in default behaviours.
> >>
> >> For the other cases I'd like to introduce some human-readable shortcuts
> >> to the --features option. Eg. 'mkfs.btrfs -O compat-3.2' will pick all
> >> options supported by the unpatched mainline kernel of version 3.2. This
> >> would be present for all version, regardless if there was a change in the
> >> options or not.
> >>
> >> Similarly for convenience, add 'running' that would pick the options
> >> from running kernel but will be explicit.
> >>
> >> A remaining option should override the 'running' behaviour and pick the
> >> latest mkfs options. Naming it 'defaults' sounds a bit ambiguous so the
> >> name is yet to be determined.
> >>
> >>> Here in this set of patches will make sure the progs understands the
> >>> kernel supported features.
> >>>
> >>> So in this patch, checks if sysfs tells whether the feature is
> >>> supported if not, then it will relay on static kernel version which
> >>> provided that feature (skinny-metadata here in this example), next
> >>> if for some reason the running kernel does not provide the kernel
> >>> version, then it will fall back to the original method to enable
> >>> the feature with a hope that kernel will support it.
> >>>
> >>> Also the last patch adds a warning when we fail to read either
> >>> sysfs features or the running kernel version.
> >>
> >> Your patchset is a good start, the additional options I've described can
> >> be added on top of that. We might need to switch the version
> >> representation from string to KERNEL_VERSION but that's an
> >> implementation detail.
> >
> > Depending on sysfs is stable but depending on kernel version may be not,
> > we may have a distro kernel which backports some incompat features from
> > upstream, then we have to decide based on sysfs interface.
> 
> +1.
> 
> Although sysfs does not always show up even for supported kernel, e.g 
> btrfs modules is not loaded after boot.
> So we need to consider twice before choosing a fallback method.

There are several factors that we have to take into account for the
default behaviour and fallback. I'm close to a final proposal yet missed
the possibility of unloaded module that would remove the access to
sysfs, as you point out.
