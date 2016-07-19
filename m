Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56897 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753408AbcGSQGL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jul 2016 12:06:11 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6JG40pK032772
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Jul 2016 12:06:10 -0400
Received: from e23smtp04.au.ibm.com (e23smtp04.au.ibm.com [202.81.31.146])
	by mx0b-001b2d01.pphosted.com with ESMTP id 2495r89y2n-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Tue, 19 Jul 2016 12:06:10 -0400
Received: from localhost
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 20 Jul 2016 02:06:07 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 705593578052
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Jul 2016 02:06:05 +1000 (EST)
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u6JG65qY15138982
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Jul 2016 02:06:05 +1000
Received: from d23av04.au.ibm.com (localhost [127.0.0.1])
	by d23av04.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u6JG644o018915
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Jul 2016 02:06:05 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/3] Btrfs: fix free space tree bitmaps+tests on big-endian systems
Date: Tue, 19 Jul 2016 21:36:01 +0530
In-Reply-To: <20160718223104.GA6681@vader.DHCP.thefacebook.com>
References: <cover.1468538030.git.osandov@fb.com> <399ec92c-9905-0ede-d5b0-ea3b0bf922e4@fb.com> <20160718223104.GA6681@vader.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2544227.upOtQjWuiQ@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, July 18, 2016 03:31:04 PM Omar Sandoval wrote:
> On Mon, Jul 18, 2016 at 02:43:26PM -0400, Chris Mason wrote:
> > 
> > 
> > On 07/17/2016 08:19 AM, Chandan Rajendra wrote:
> > > On Friday, July 15, 2016 12:15:15 PM Omar Sandoval wrote:
> > > > On Fri, Jul 15, 2016 at 12:34:10PM +0530, Chandan Rajendra wrote:
> > > > > On Thursday, July 14, 2016 07:47:04 PM Chris Mason wrote:
> > > > > > On 07/14/2016 07:31 PM, Omar Sandoval wrote:
> > > > > > > From: Omar Sandoval <osandov@fb.com>
> > > > > > > 
> > > > > > > So it turns out that the free space tree bitmap handling has always been
> > > > > > > broken on big-endian systems. Totally my bad.
> > > > > > > 
> > > > > > > Patch 1 fixes this. Technically, it's a disk format change for
> > > > > > > big-endian systems, but it never could have worked before, so I won't go
> > > > > > > through the trouble of any incompat bits. If you've somehow been using
> > > > > > > space_cache=v2 on a big-endian system (I doubt anyone is), you're going
> > > > > > > to want to mount with nospace_cache to clear it and wait for this to go
> > > > > > > in.
> > > > > > > 
> > > > > > > Patch 2 fixes a similar error in the sanity tests (it's the same as the
> > > > > > > v2 I posted here [1]) and patch 3 expands the sanity tests to catch the
> > > > > > > oversight that patch 1 fixes.
> > > > > > > 
> > > > > > > Applies to v4.7-rc7. No regressions in xfstests, and the sanity tests
> > > > > > > pass on x86_64 and MIPS.
> > > > > > 
> > > > > > Thanks for fixing this up Omar.  Any big endian friends want to try this
> > > > > > out in extended testing and make sure we've nailed it down?
> > > > > > 
> > > > > 
> > > > > Hi Omar & Chris,
> > > > > 
> > > > > I will run fstests with this patchset applied on ppc64 BE and inform you about
> > > > > the results.
> > > > > 
> > > > 
> > > > Thanks, Chandan! I set up my xfstests for space_cache=v2 by doing:
> > > > 
> > > >     mkfs.btrfs "$TEST_DEV"
> > > >     mount -o space_cache=v2 "$TEST_DEV" "$TEST_DIR"
> > > >     umount "$TEST_DEV"
> > > > 
> > > > and adding
> > > > 
> > > >     export MOUNT_OPTIONS="-o space_cache=v2"
> > > > 
> > > > to local.config. btrfsck also needs the patch here [1].
> > > > 
> > > > 
> > > 
> > > Hi,
> > > 
> > > I did execute the fstests tests suite on ppc64 BE as per above configuration
> > > and there were no new regressions. Also, I did execute fsx (via generic/127)
> > > thrice on the same filesystem instance,
> > > 1. With the unpatched kernel and later
> > > 2. With the patched kernel and again
> > > 3. With the unpatched kernel
> > > ... there were no new regressions when executing the above steps.
> > 
> > Thanks Chandan!  But I'm a little confused.  If the patch is helping, we
> > should be storing bitmaps wrong on disk unpatched.  There should be problems
> > going back and forth.
> > 
> > -chris
> 
> Yeah, this should definitely not work. It's possible that things are
> just silently failing and getting corrupted if the module isn't built
> with CONFIG_BTRFS_ASSERT, but btrfsck v4.6.1 + my patch should catch
> that.
> 
> Chandan, is fsx creating enough fragmentation to trigger the switch to
> bitmaps? You can check with `btrfs inspect dump-tree`; there should be
> FREE_SPACE_BITMAP items. If there are only FREE_SPACE_EXTENT items, then
> it's not testing the right code path.
> 
> I have a script here [1] that I've been using to test the free space
> tree. When I ran it with `--check` on MIPS, it failed on the old kernel
> and passed with this series. If you stick a return after the call to
> `unlink_every_other_file()`, you'll get a nice, fragmented filesystem to
> feed to xfstests, as well.

You are right, There were only FREE_SPACE_EXTENT items in the filesystem that
was operated on by fsx. I executed fragment_free_space_tree.py to create a
filesystem with FREE_SPACE_BITMAP items. When such a filesystem is created
with the unpatched kernel, later mounted on a patched kernel and fsx executed
on it, I see that we fail assertion statements in free-space-tree.c. For e.g.

BTRFS error (device loop0): incorrect extent count for 289406976; counted 8186, expected 8192
BTRFS: assertion failed: 0, file: /root/repos/linux/fs/btrfs/free-space-tree.c, line: 1485

-- 
chandan

