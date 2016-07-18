Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34521 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbcGRWbG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 18:31:06 -0400
Received: by mail-pa0-f45.google.com with SMTP id fi15so248035pac.1
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Jul 2016 15:31:06 -0700 (PDT)
Date: Mon, 18 Jul 2016 15:31:04 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 0/3] Btrfs: fix free space tree bitmaps+tests on
 big-endian systems
Message-ID: <20160718223104.GA6681@vader.DHCP.thefacebook.com>
References: <cover.1468538030.git.osandov@fb.com>
 <48955009.Up9FeqXyzx@localhost.localdomain>
 <20160715191515.GA13357@vader.DHCP.thefacebook.com>
 <3006396.dOAW6WHiJC@localhost.localdomain>
 <399ec92c-9905-0ede-d5b0-ea3b0bf922e4@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <399ec92c-9905-0ede-d5b0-ea3b0bf922e4@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 18, 2016 at 02:43:26PM -0400, Chris Mason wrote:
> 
> 
> On 07/17/2016 08:19 AM, Chandan Rajendra wrote:
> > On Friday, July 15, 2016 12:15:15 PM Omar Sandoval wrote:
> > > On Fri, Jul 15, 2016 at 12:34:10PM +0530, Chandan Rajendra wrote:
> > > > On Thursday, July 14, 2016 07:47:04 PM Chris Mason wrote:
> > > > > On 07/14/2016 07:31 PM, Omar Sandoval wrote:
> > > > > > From: Omar Sandoval <osandov@fb.com>
> > > > > > 
> > > > > > So it turns out that the free space tree bitmap handling has always been
> > > > > > broken on big-endian systems. Totally my bad.
> > > > > > 
> > > > > > Patch 1 fixes this. Technically, it's a disk format change for
> > > > > > big-endian systems, but it never could have worked before, so I won't go
> > > > > > through the trouble of any incompat bits. If you've somehow been using
> > > > > > space_cache=v2 on a big-endian system (I doubt anyone is), you're going
> > > > > > to want to mount with nospace_cache to clear it and wait for this to go
> > > > > > in.
> > > > > > 
> > > > > > Patch 2 fixes a similar error in the sanity tests (it's the same as the
> > > > > > v2 I posted here [1]) and patch 3 expands the sanity tests to catch the
> > > > > > oversight that patch 1 fixes.
> > > > > > 
> > > > > > Applies to v4.7-rc7. No regressions in xfstests, and the sanity tests
> > > > > > pass on x86_64 and MIPS.
> > > > > 
> > > > > Thanks for fixing this up Omar.  Any big endian friends want to try this
> > > > > out in extended testing and make sure we've nailed it down?
> > > > > 
> > > > 
> > > > Hi Omar & Chris,
> > > > 
> > > > I will run fstests with this patchset applied on ppc64 BE and inform you about
> > > > the results.
> > > > 
> > > 
> > > Thanks, Chandan! I set up my xfstests for space_cache=v2 by doing:
> > > 
> > >     mkfs.btrfs "$TEST_DEV"
> > >     mount -o space_cache=v2 "$TEST_DEV" "$TEST_DIR"
> > >     umount "$TEST_DEV"
> > > 
> > > and adding
> > > 
> > >     export MOUNT_OPTIONS="-o space_cache=v2"
> > > 
> > > to local.config. btrfsck also needs the patch here [1].
> > > 
> > > 
> > 
> > Hi,
> > 
> > I did execute the fstests tests suite on ppc64 BE as per above configuration
> > and there were no new regressions. Also, I did execute fsx (via generic/127)
> > thrice on the same filesystem instance,
> > 1. With the unpatched kernel and later
> > 2. With the patched kernel and again
> > 3. With the unpatched kernel
> > ... there were no new regressions when executing the above steps.
> 
> Thanks Chandan!  But I'm a little confused.  If the patch is helping, we
> should be storing bitmaps wrong on disk unpatched.  There should be problems
> going back and forth.
> 
> -chris

Yeah, this should definitely not work. It's possible that things are
just silently failing and getting corrupted if the module isn't built
with CONFIG_BTRFS_ASSERT, but btrfsck v4.6.1 + my patch should catch
that.

Chandan, is fsx creating enough fragmentation to trigger the switch to
bitmaps? You can check with `btrfs inspect dump-tree`; there should be
FREE_SPACE_BITMAP items. If there are only FREE_SPACE_EXTENT items, then
it's not testing the right code path.

I have a script here [1] that I've been using to test the free space
tree. When I ran it with `--check` on MIPS, it failed on the old kernel
and passed with this series. If you stick a return after the call to
`unlink_every_other_file()`, you'll get a nice, fragmented filesystem to
feed to xfstests, as well.

1: https://github.com/osandov/osandov-linux/blob/master/scripts/fragment_free_space_tree.py

-- 
Omar
