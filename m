Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tango.0pointer.de ([85.214.72.216]:47984 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbaCJVJI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 17:09:08 -0400
Date: Mon, 10 Mar 2014 22:09:03 +0100
From: Lennart Poettering <lennart@poettering.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Chris Mason <clm@fb.com>, kreijack@inwind.it,
        systemd-devel@lists.freedesktop.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
Message-ID: <20140310210901.GA22199@tango.0pointer.de>
References: <20140307182603.GA22874@tango.0pointer.de>
 <531E059B.1010509@libero.it>
 <20140310200228.GA18268@tango.0pointer.de>
 <531E1EBA.1090404@fb.com>
 <1A252834-430D-482F-96C7-761A85D2DA74@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1A252834-430D-482F-96C7-761A85D2DA74@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 10.03.14 14:53, Chris Murphy (lists@colorremedies.com) wrote:

> Since it's not a given whether a parent or child subvolume is the one
> being updated, it's ambiguous which one to use/automount if there is
> inheritance of the proposed subvolumetypeGUID at snapshot
> time. Inheritance of the proposed GUID at snapshot time sounds
> untenable.
> 
> Failsafe for rootfs is to snapshot, mount it, apply updates to the
> snapshot in a chroot. That way a failed update means the snapshot can
> be immediately deleted. And the OS is overall more stable by not
> having running binaries modified or yanked out from under it. Here,
> using the current subvolume at reboot is the rollback; changing to the
> snapshot is the upgrade.
> 
> Whereas for home, rebooting to the snapshot is a rollback, which I
> certainly don't want by default.
> 
> I don't see the right way to handle this automatically or by default.

I am in no way bound to the idea of having subvolume type UUIDs for
this. There are other options. For example, there's already the concept
of having "default" subvolumes ("btrfs subvolume set-default"...), maybe
we can extend that a little bit, and allow different kinds of default
subvolumes, one "default /home subvolume", one "default /srv subvolume",
and so on, plus one "default root subvolume", and so on. The vocabulary
for the available "default" subvolumes could be a free-form string where
the empty string would be the existing default subvolume. Or so...

When people play games with subvolumes and snapshots we could then
simply ask them to update where these "default" subvolumes point... Of
course this simply exports to the admin the problem of combining
subvolumes properly.

Another option would be to introduce a high level concept of a
"subvolume set" or so, which binds subvolumes together, and of which
there could be a "default subvolume set". Within such a subvolume set
could then use type uuids or so to mount things properly. Or something
like that...

Lennart

-- 
Lennart Poettering, Red Hat
