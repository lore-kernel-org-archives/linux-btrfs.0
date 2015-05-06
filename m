Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbbEFPns (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 May 2015 11:43:48 -0400
Date: Wed, 6 May 2015 17:43:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8] Introduce offline fsid/chunk tree uuid change for
 btrfstune.
Message-ID: <20150506154347.GC23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150505152055.GH5099@twin.jikos.cz>
 <5549651D.6020005@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5549651D.6020005@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 06, 2015 at 08:49:33AM +0800, Qu Wenruo wrote:
> > Code looks good to me. I'm not sure whether it should land in btrfstune
> > or in 'btrfs' proper.
> >
> > * btrfstune should go away at some point, so I'd rather not add new
> >    features there
> >
> > * 'btrfs property set -t filesystem uuid' seems best to me at this moment
> Good idea.
> 
> I'll change it to property in next version.

I've realized this later on.  The original purpose of the properties is
to manipulate objects on a mounted filesystem, so this might need some
adjustnments on the progs side. I'd really want to avoid another
separate tool, so we should make sure that the interface is sane even if
it could mix online/offline filesystem changes.

Respecting the current syntax, the way to set the uuid is:

 btrfs prop set -t filesytem /dev/sdx uuid ...UUID...

In this special case, the property handler should check if the device is
unmounted (and is a btrfs filesystem) and then do the rest.

> > A minor suggestion: set BTRFS_SUPER_FLAG_ERROR on the filesystem during
> > the conversion and drop it after it finishes successfully. It's merely a
> > hint that there's something wrong with the filesytem, the mount will
> > fail because filesystem uuid would not match the device id.
> >
> Nice idea too.
> But I'd like to use more specific flags like
> BTRFS_SUPER_FLAG_UUID_CHANGING to give better info if kernel can't mount it.

Yeah that would be better and we'd use that for the on-line uuid change
as well. I've outlined the idea here
https://btrfs.wiki.kernel.org/index.php/Project_ideas#Filesystem_UUID_change_-_on-line

The code should really support only 2 UUIDs, so we should check if the
UUIDs specified by user matches one of them if the superblock flag is
set. Ie. a partial uuid conversion must be finished before another
UUID change (though it's a rare case, we have to be ready for that).
