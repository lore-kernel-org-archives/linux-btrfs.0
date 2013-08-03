Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.201]:50012 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524Ab3HCLjG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Aug 2013 07:39:06 -0400
Received: from mailout-us.gmx.com ([172.19.198.48]) by mrigmx.server.lan
 (mrigmxus002) with ESMTP (Nemesis) id 0M25b5-1UDBy73JZT-00u2ML for
 <linux-btrfs@vger.kernel.org>; Sat, 03 Aug 2013 13:39:04 +0200
Cc: "David Sterba" <dsterba@suse.cz>, sbehrens@giantdisaster.de
Content-Type: text/plain; charset="utf-8"
Date: Sat, 03 Aug 2013 07:39:01 -0400
From: "Mike Audia" <mikey_a@gmx.com>
Message-ID: <20130803113901.157540@gmx.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] btrfs: add mount option to set commit interval
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > Another newbie question is which version of the kernel do I need to
> > have in order to cleanly apply this patch?  I am finding that it fails
> > to apply to the current stable kernel code (as of now it is v3.10.4)
> > which makes me think your patch has to be applied to a newer one?  Are
> > you patching against the linux git tree meaning I have to use the 3.11
> > series to try your code?
> 
> Try Josef's btrfs-next repo:
> 
>  https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#Integration_repository_.28btrfs-next.29

OK!  I can patch successfully into that git repo:

% cd /tmp/work
% git clone git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
% cd btrfs
% patch -Np1 -i btrfs_add_mount_option_to_set_commit_interval.patch
patching file fs/btrfs/ctree.h
patching file fs/btrfs/disk-io.c
patching file fs/btrfs/super.c
Hunk #3 succeeded at 647 (offset 19 lines).
Hunk #4 succeeded at 1006 with fuzz 1 (offset 39 lines).

If I am not mistaken, btrfs-next is the entire kernel's code?  The wiki suggests running anything compiled therein from the build dir.  If I want to compile this into the official 3.10.4 tree, how can I do it?
