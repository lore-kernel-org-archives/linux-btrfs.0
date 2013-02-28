Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:58342 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab3B1VVY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Feb 2013 16:21:24 -0500
Date: Thu, 28 Feb 2013 22:21:19 +0100
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Running Apache Derby on 3.8 and BTRFS cause kernel oops
Message-ID: <20130228212119.GE13516@mother.jarsat.pl>
References: <op.ws51z2nllpxuyk@kozzifx.lan>
 <20130227132513.GG19641@localhost.localdomain>
 <op.ws6fu8smlpxuyk@kozzifx.lan>
 <CAEzrpqcmapgs67M2PrVz=XB3MYXV7CN6Roze-WsyS9JR-7jVvw@mail.gmail.com>
 <512E8FD7.8020700@orcaware.com>
 <20130228154721.GJ19641@localhost.localdomain>
 <op.ws8a2dx4lpxuyk@kozzifx.lan>
 <20130228183521.GK19641@localhost.localdomain>
 <512FA4E0.7040701@orcaware.com>
 <20130228200503.GL19641@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130228200503.GL19641@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 28, 2013 at 03:05:03PM -0500, Josef Bacik wrote:
> > >>>> I use the cloud image from here, boot of an Ubuntu CD-ROM ISO to change
> > >>>> from ext4 to btrfs, then installed openjdk.
> > >>>>
> > >>>> http://cloud-images.ubuntu.com/raring/current/raring-server-cloudimg-amd64-disk1.img
> > >>>>
> > >>>> I could make my image available for download later if you need it, in a
> > >>>> pre-failure state.  Let me know.
> > >>>>
> > >>>
> > >>> Yeah I still can't reproduce, can either of you send me your kernel
> > >>> config so I
> > >>> can see if it's something in my config that's causing problems?  Thanks,
> > >>>
> > >>> Josef
> > >>
> > >> Yes, here is it
> > >>
> > >
> > > Great I'll set this up on both of my boxes and see if I can reproduce.  In the
> > > meantime will you try btrfs-next?  I just pushed a tree-log fix that I don't
> > > think will fix your problem but since I don't know what your problem is yet it
> > > might, so I'd like to at least eliminate it.  Thanks,
> > 
> > I put a KVM image up at that you can try:
> > 
> > http://www-devel.orcaware.com/blair/btrfs/2013-02-28/
> > 
> Ok so now that I have it reproducing, how do I go about getting a custom kernel
> on there?  I'm used to libvirt where all the networking stuff is done for me,
> this doesn't seem to connect to the network at all and it also doesn't seem to
> have mount.nfs so I can't do what I normally do and mount my local drive as nfs
> and install the new kernel.  What is the best way to go about doing this?

  You can run start image by invoking qemu-kvm with custom kernel:
-kernel bzImage use 'bzImage' as kernel image
-append cmdline use 'cmdline' as kernel command line
-initrd file    use 'file' as initial ram disk


-- 
Tomasz Torcz                Only gods can safely risk perfection,
xmpp: zdzichubg@chrome.pl     it's a dangerous thing for a man.  -- Alia

