Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54028 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbbKWR5x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Nov 2015 12:57:53 -0500
Date: Mon, 23 Nov 2015 18:56:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 0/5] Make btrfs-progs really compatible with any
 kernel version
Message-ID: <20151123175608.GI31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 23, 2015 at 08:56:13PM +0800, Anand Jain wrote:
> Btrfs-progs is a tool for the btrfs kernel and we hope latest btrfs-progs
> be compatible w any set of older/newer kernels.
> 
> So far mkfs.btrfs and btrfs-convert sets the default features, for eg,
> skinny-metadata even if the running kernel does not supports it, and
> so the mount fails on the running.

So the default behaviour of mkfs will try to best guess the feature set
of currently running kernel. I think this is is the most common scenario
and justifies the change in default behaviours.

For the other cases I'd like to introduce some human-readable shortcuts
to the --features option. Eg. 'mkfs.btrfs -O compat-3.2' will pick all
options supported by the unpatched mainline kernel of version 3.2. This
would be present for all version, regardless if there was a change in the
options or not.

Similarly for convenience, add 'running' that would pick the options
from running kernel but will be explicit.

A remaining option should override the 'running' behaviour and pick the
latest mkfs options. Naming it 'defaults' sounds a bit ambiguous so the
name is yet to be determined.

> Here in this set of patches will make sure the progs understands the
> kernel supported features.
> 
> So in this patch, checks if sysfs tells whether the feature is
> supported if not, then it will relay on static kernel version which
> provided that feature (skinny-metadata here in this example), next
> if for some reason the running kernel does not provide the kernel
> version, then it will fall back to the original method to enable
> the feature with a hope that kernel will support it.
> 
> Also the last patch adds a warning when we fail to read either
> sysfs features or the running kernel version.

Your patchset is a good start, the additional options I've described can
be added on top of that. We might need to switch the version
representation from string to KERNEL_VERSION but that's an
implementation detail.
