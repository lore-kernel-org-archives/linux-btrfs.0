Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:46006 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066Ab3BVQxG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 11:53:06 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id C4D3B9A04D8
	for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 09:53:04 -0700 (MST)
Date: Fri, 22 Feb 2013 11:53:02 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Mace Moneta <moneta.mace@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: at fs/btrfs/extent_io.c:4718
 map_private_extent_buffer+0xd4/0xe0 [btrfs]()
Message-ID: <20130222165302.GE2062@localhost.localdomain>
References: <CAMfhy91avz+euv1vtomHMv87o-f57paUDAgegEXtn9gQ==W3Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAMfhy91avz+euv1vtomHMv87o-f57paUDAgegEXtn9gQ==W3Fg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 22, 2013 at 07:46:16AM -0700, Mace Moneta wrote:
> https://bugzilla.redhat.com/show_bug.cgi?id=906142
> 
> With 3.8 kernels in Fedora 18, using encfs on btrfs I get the
> following error.  It can take hours of use before I get a
> reoccurrence, and I need to btrfsck, btrfs-zero-log, and/or mount with
> '-o recovery' to get the filesystem back after a reboot.  No data
> appears to be lost, and a scrub runs to completion with no errors.

Could you do

gdb btrfs.ko
list *(btrfs_log_inode+0x3b8)

and tell me what it says?  Thanks,

Josef
