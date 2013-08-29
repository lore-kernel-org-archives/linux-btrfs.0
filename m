Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab3H2NWA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 09:22:00 -0400
Date: Thu, 29 Aug 2013 15:21:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: btrfs/003: regression test for subvol delete V2
Message-ID: <20130829132158.GI23113@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1376422458-2339-1-git-send-email-jbacik@fusionio.com>
 <520A8B1D.60307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <520A8B1D.60307@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 13, 2013 at 02:38:05PM -0500, Eric Sandeen wrote:
> > +. ./common/rc
> > +. ./common/filter
> > +
> > +# real QA test starts here
> > +_supported_fs btrfs
> > +_supported_os Linux
> > +_require_scratch
> > +
> > +_scratch_mkfs > /dev/null 2>&1
> > +_scratch_mount
> > +
> > +# This will be set to subvolid 256.  If this ever changes in the future for
> > +# whatever reason we'll have to pull the subvolid out of the subvol list command
> > +# but since it's a newly mkfs'ed fs we should be fine with this.
> 
> . . . and then you grab it out of the subvol list command anyway ;)
> 
> So really this comment should go, and it sure would be nice to have 
> a btrfs_get_subvolid() helper for future generations...

This is available in the 'btrfs subvol show /subvol':

# btrfs subvol show subv1
/mnt/a15/subv1
        Name:                   subv1
        uuid:                   cf010ad0-38bf-7a42-88be-3360f68cd335
        Parent uuid:            e6543f70-5d38-1845-b976-d18095860bdf
        Creation time:          2013-08-29 15:18:18
        Object ID:              258
        Generation (Gen):       6
        Gen at creation:        6
        Parent:                 5
        Top Level:              5
        Flags:                  readonly
        Snapshot(s):

Though it involves grep as well.

david
