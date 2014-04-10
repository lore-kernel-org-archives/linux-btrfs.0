Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:52720 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbaDJWZn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 18:25:43 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so3473803eek.20
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 15:25:42 -0700 (PDT)
Received: from honzk.localnet (nat-11.starnet.cz. [178.255.168.11])
        by mx.google.com with ESMTPSA id y51sm13044190eeu.0.2014.04.10.15.25.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 10 Apr 2014 15:25:41 -0700 (PDT)
From: Jan Kouba <kouba.honza@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Copying a disk containing a btrfs filesystem
Date: Fri, 11 Apr 2014 00:25:41 +0200
Message-ID: <1646501.RvAOndPxnd@honzk>
In-Reply-To: <1809379.6bJCFjA2Oa@fuchsia>
References: <4783411.VVGoQz5kVU@fuchsia> <1632469.6TRA6yZMTn@honzk> <1809379.6bJCFjA2Oa@fuchsia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dne Čt 10. dubna 2014 20:36:32, Michael Schuerig napsal(a):
> On Thursday 10 April 2014 19:17:13 Jan Kouba wrote:
> > Dne Čt 10. dubna 2014 15:21:01, Michael Schuerig napsal(a):
> > > SMART indicates that my notebook disk may soon be failing (an
> > > unreadable/uncorrectable sector), therefore I intend to exchange it.
> > > The disk contains a single btrfs filesystem with several nested(!)
> > > subvolumes, each with several read-only snapshots in a .snapshots
> > > subdirectory.
> > > 
> > > As far as I can tell, btrfs currently does not offer a sensible way
> > > to duplicate the entire contents of the old disk onto a new one.
> > 
> > Yes it does
> > 
> > You can make the old disk a seeding device and use it to seed the new
> 
> > one like this:
> Intriguing. I didn't find much on the topic, but these pages seem
> pertinent
> 
> http://en.wikipedia.org/wiki/Btrfs#Seed_devices
> https://btrfs.wiki.kernel.org/index.php/Seed-device
> http://unix.stackexchange.com/a/97819/64935
> 
> > btrfstune -S 1 <old_device>
> 
> Does the "1" mean "true" or is this indeed an integer-value arg? I've
> only seen the "1" in examples, are there other possible values?
Yes, "1" means "true", "0" false. If you run it twice with the same argument, 
it says something like "Seeding flag already set/unset.".
> 
> > mount <old_device> /mnt
> > # this will be mounted read-only
> > 
> > btrfs dev add <new_device> /mnt
> > 
> > mount -o remount,rw /mnt
> > 
> > btrfs dev delete <old_device>
> 
> Is the last one the step where data is copied from the seed device to
> the second device? No balance required before deleting the device?
Yes, everything is copied, no balance needed.


Well actually if you don't need to preserve the filesystem on the old device, 
you can just add the new device into the filesystem and remove the old one like 
this:

mount <old_device> /mnt
btrfs dev add <new_device> /mnt
btrfs dev delete <old_device> /mnt

The last command will copy everything from <old_device> to the <new_device> 
and somehow wipe the <old_device> so it can't be mounted anymore.
 
This method will also preserve the UUID of the filesystem so there is no need 
to change any config files.


Jan Kouba
