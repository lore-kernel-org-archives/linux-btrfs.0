Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38073 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155Ab3GJQbH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jul 2013 12:31:07 -0400
Date: Wed, 10 Jul 2013 09:31:05 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: dsterba@suse.cz, Andrew Vagin <avagin@gmail.com>,
        Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        kzak@redhat.com, xemul@openvz.org
Subject: Re: btrfs: stat(2) and /proc/pid/maps returns different devices
Message-ID: <20130710163105.GR32502@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20130704095138.GB12359@gmail.com> <20130708215446.GH18204@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130708215446.GH18204@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 08, 2013 at 11:54:46PM +0200, David Sterba wrote:
> On Thu, Jul 04, 2013 at 01:51:38PM +0400, Andrew Vagin wrote:
> > We are not first who suffer from this problem:
> > https://bugzilla.redhat.com/show_bug.cgi?id=711881
> > http://marc.info/?l=linux-btrfs&m=130074451403261
> > https://bugzilla.openvz.org/show_bug.cgi?id=2653
> 
> > And about 2 years ago Mark Fasheh tried to fix this problem:
> > http://thr3ads.net/btrfs-devel/2011/05/2346176-RFC-PATCH-0-2-btrfs-vfs-Return-same-device-in-stat-2-and-proc-pid-maps

And basically nobody cared :/


> > Eric Biederman sugested to not create a new method and use vfs_getattr,
> > but here is a few problems:
> > * fanotify doesn't have dentry, but its fdinfo contains device.
> > * vfs_getattr can fail and which device should be shown in this case?
> > * vfs_getattr gets much more parameters, so here is a question about
> >   performance degradation.
> > 
> > So I have a question: Can two inodes from different subvolumes have
> > equal inode numbers?
> 
> Yes, subvolumes are separate inode number spaces.
> 
> > If someone have any suggestions how to fix this problem or any
> > explanation why this is not a problem at all, please write here.
> 
> The xstat syscall instead of the potentially heavyweight vfs_getattr
> could fix that, but it's not merged. For suse kernels we've taken the
> hackish approach of patching fs/proc/task_mmu.c:show_map_vma() (and the
> nommu variant) and use vfs_getattr only for btrfs.
> 
> http://kernel.opensuse.org/cgit/kernel-source/tree/patches.suse/btrfs-use-correct-device-for-maps.patch?id=2434fa6ee93a83b117461eb13f24272606677fec
> 
> Only a temporary and not upstreamable solution, but without it the core
> packaging tool zypper would not work correctly.

As far as I can tell we'll be carrying this patch until a better
solution is possible.

When that will happen, I don't know.
	--Mark

--
Mark Fasheh
