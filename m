Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tango.0pointer.de ([85.214.72.216]:49271 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaCJXpv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 19:45:51 -0400
Date: Tue, 11 Mar 2014 00:45:47 +0100
From: Lennart Poettering <lennart@poettering.net>
To: kreijack@inwind.it
Cc: systemd-devel@lists.freedesktop.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
Message-ID: <20140310234547.GA31229@tango.0pointer.de>
References: <20140307182603.GA22874@tango.0pointer.de>
 <531E059B.1010509@libero.it>
 <20140310200228.GA18268@tango.0pointer.de>
 <531E3F10.3000908@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <531E3F10.3000908@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 10.03.14 23:39, Goffredo Baroncelli (kreijack@libero.it) wrote:

> > Well, the name is property of the admin really. There needs to be a way
> > how the admin can label his subvolumes, with a potentially localized
> > name. This makes it unsuitable for our purpose, we cannot just take
> > possession of this and leave the admin with nothing.
> 
> Instead of the name we can use the xattr to store these information.

Ah, using xattrs for this is indeed an option. That way we should be able
attach any kind of information we like to a subvolume.

Hmm, I figure though that there is no way currently to read xattrs off a
subvolume without first mounting them individually? Having to mount all
subvolumes before we can make sense of them and mount them to the right
place certainly sounds less than ideal...

> > On GPT there are also gpt partition labels and partition types. The
> > former are property of the admin, he can place there whatever he wants,
> > in whatever language he chooses... The latter however is how we make
> > sense of it on a semantical level.
> > 
> >> Or in another way we could group the different systems in subdirectories:
> >>
> >> @home		-> home of all the systems
> >> @srv		-> srv  of all the systems
> >> fedora/@	-> root of a fedora system
> >> fedora/@etc	-> etc of the fedora system
> >> fedora2/@	-> root of a fedora2 system
> >> fedora2/@etc	-> etc of the fedora2 system
> > 
> > I am pretty sure automatic discovery of mount points should not cover
> > the usecase where people install multiple distributions into the same
> > btrfs volume. THe automatic logic should cover the simple cases only,
> > and it sounds way over the top to support installing multiple OSes into
> > the same btrfs... I mean, people can do that, if they want to, they just
> > have to write a proper fstab, which I think is not too much too ask...
> 
> In your specification, you referred the use case of "container" (via
> nspawn / libvrt-lxc). which have to boot "a disk image". Why you don't
> mind to use a container on a btrfs snapshot ? I think that it will be
> reasonable to have different containers on a snapshots of the same
> filesystem-tree.

Hmm, dunno, you might have a point there...

Lennart

-- 
Lennart Poettering, Red Hat
