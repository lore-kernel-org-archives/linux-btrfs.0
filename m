Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:39687 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369Ab3BVRoG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 12:44:06 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id BDEBF7C041A
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 10:44:05 -0700 (MST)
Date: Fri, 22 Feb 2013 12:44:01 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Mace Moneta <moneta.mace@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: at fs/btrfs/extent_io.c:4718
 map_private_extent_buffer+0xd4/0xe0 [btrfs]()
Message-ID: <20130222174401.GF2062@localhost.localdomain>
References: <CAMfhy91avz+euv1vtomHMv87o-f57paUDAgegEXtn9gQ==W3Fg@mail.gmail.com>
 <20130222165302.GE2062@localhost.localdomain>
 <CAMfhy91KbFSdCyNdQo1a4whWtqg2TbXKLuJdCiRTfj9E3oOePw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAMfhy91KbFSdCyNdQo1a4whWtqg2TbXKLuJdCiRTfj9E3oOePw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 22, 2013 at 10:22:04AM -0700, Mace Moneta wrote:
> On Fri, Feb 22, 2013 at 11:53 AM, Josef Bacik <jbacik@fusionio.com> wrote:
> > On Fri, Feb 22, 2013 at 07:46:16AM -0700, Mace Moneta wrote:
> >> https://bugzilla.redhat.com/show_bug.cgi?id=906142
> >>
> >> With 3.8 kernels in Fedora 18, using encfs on btrfs I get the
> >> following error.  It can take hours of use before I get a
> >> reoccurrence, and I need to btrfsck, btrfs-zero-log, and/or mount with
> >> '-o recovery' to get the filesystem back after a reboot.  No data
> >> appears to be lost, and a scrub runs to completion with no errors.
> >
> > Could you do
> >
> > gdb btrfs.ko
> > list *(btrfs_log_inode+0x3b8)
> >
> > and tell me what it says?  Thanks,
> >
> > Josef
> 
> # uname -r
> 3.8.0-0.rc7.git0.1.fc19.x86_64
> 
> # gdb /usr/lib/modules/3.8.0-0.rc7.git0.1.fc19.x86_64/kernel/fs/btrfs/btrfs.ko
> 

Sigh sorry, I miseed the other line because of line wrapping, can you do

list *(btrfs_log_changed_extents+0x384)

Thanks,

Josef
