Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34749 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbcGOTPS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jul 2016 15:15:18 -0400
Received: by mail-pa0-f45.google.com with SMTP id fi15so41721168pac.1
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jul 2016 12:15:17 -0700 (PDT)
Date: Fri, 15 Jul 2016 12:15:15 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/3] Btrfs: fix free space tree bitmaps+tests on
 big-endian systems
Message-ID: <20160715191515.GA13357@vader.DHCP.thefacebook.com>
References: <cover.1468538030.git.osandov@fb.com>
 <7d7ada29-f53a-bcc8-9344-85733f030c4b@fb.com>
 <48955009.Up9FeqXyzx@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48955009.Up9FeqXyzx@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 15, 2016 at 12:34:10PM +0530, Chandan Rajendra wrote:
> On Thursday, July 14, 2016 07:47:04 PM Chris Mason wrote:
> > On 07/14/2016 07:31 PM, Omar Sandoval wrote:
> > > From: Omar Sandoval <osandov@fb.com>
> > >
> > > So it turns out that the free space tree bitmap handling has always been
> > > broken on big-endian systems. Totally my bad.
> > >
> > > Patch 1 fixes this. Technically, it's a disk format change for
> > > big-endian systems, but it never could have worked before, so I won't go
> > > through the trouble of any incompat bits. If you've somehow been using
> > > space_cache=v2 on a big-endian system (I doubt anyone is), you're going
> > > to want to mount with nospace_cache to clear it and wait for this to go
> > > in.
> > >
> > > Patch 2 fixes a similar error in the sanity tests (it's the same as the
> > > v2 I posted here [1]) and patch 3 expands the sanity tests to catch the
> > > oversight that patch 1 fixes.
> > >
> > > Applies to v4.7-rc7. No regressions in xfstests, and the sanity tests
> > > pass on x86_64 and MIPS.
> > 
> > Thanks for fixing this up Omar.  Any big endian friends want to try this 
> > out in extended testing and make sure we've nailed it down?
> >
> 
> Hi Omar & Chris,
> 
> I will run fstests with this patchset applied on ppc64 BE and inform you about
> the results.
> 

Thanks, Chandan! I set up my xfstests for space_cache=v2 by doing:

    mkfs.btrfs "$TEST_DEV"
    mount -o space_cache=v2 "$TEST_DEV" "$TEST_DIR"
    umount "$TEST_DEV"

and adding

    export MOUNT_OPTIONS="-o space_cache=v2"

to local.config. btrfsck also needs the patch here [1].

Thanks again.

1: http://thread.gmane.org/gmane.comp.file-systems.btrfs/58382

-- 
Omar
