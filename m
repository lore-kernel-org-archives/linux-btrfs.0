Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:34584 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaCKOaq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 10:30:46 -0400
Received: by mail-ie0-f169.google.com with SMTP id to1so8966314ieb.14
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Mar 2014 07:30:45 -0700 (PDT)
Message-ID: <1394548243.23116.24.camel@sasami.ottawa.blindsidenetworks.com>
Subject: Re: [systemd-devel] [HEADS-UP] Discoverable Partitions Spec
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Lennart Poettering <lennart@poettering.net>
Cc: kreijack@inwind.it, systemd-devel@lists.freedesktop.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Tue, 11 Mar 2014 10:30:43 -0400
In-Reply-To: <20140310234547.GA31229@tango.0pointer.de>
References: <20140307182603.GA22874@tango.0pointer.de>
	 <531E059B.1010509@libero.it> <20140310200228.GA18268@tango.0pointer.de>
	 <531E3F10.3000908@libero.it> <20140310234547.GA31229@tango.0pointer.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2014-03-11 at 00:45 +0100, Lennart Poettering wrote:
> On Mon, 10.03.14 23:39, Goffredo Baroncelli (kreijack@libero.it) wrote:
> 
> > > Well, the name is property of the admin really. There needs to be a way
> > > how the admin can label his subvolumes, with a potentially localized
> > > name. This makes it unsuitable for our purpose, we cannot just take
> > > possession of this and leave the admin with nothing.
> > 
> > Instead of the name we can use the xattr to store these information.
> 
> Ah, using xattrs for this is indeed an option. That way we should be able
> attach any kind of information we like to a subvolume.
> 
> Hmm, I figure though that there is no way currently to read xattrs off a
> subvolume without first mounting them individually? Having to mount all
> subvolumes before we can make sense of them and mount them to the right
> place certainly sounds less than ideal...

One thing to remember about the way btrfs snapshots/subvolumes work is
that they simply show up as directories within the filesystem tree.
There is no separate namespace for storing subvolumes; they all end up
in a single unified filesystem tree along with regular files and
directories.

As a result, you can simply mount the root of the filesystem, and then
read xattrs off any and all of the subvolumes.

In fact, mounting a the subvolume "/@home" to "/home" in btrfs is
effectively equivalent to

mount -t btrfs -o subvolid=0 /dev/sda1 /home
mount --bind /home/@home /home

except done as a single step in one mount command.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

