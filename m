Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:34632 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709AbaDJSge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 14:36:34 -0400
Received: from fuchsia.localnet (p57A571D5.dip0.t-ipconnect.de [87.165.113.213])
	by smtp.strato.de (RZmta 32.33 DYNA|AUTH)
	with ESMTPSA id g00a52q3AIaW3JX
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Thu, 10 Apr 2014 20:36:32 +0200 (CEST)
From: Michael Schuerig <michael.lists@schuerig.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Copying a disk containing a btrfs filesystem
Date: Thu, 10 Apr 2014 20:36:32 +0200
Message-ID: <1809379.6bJCFjA2Oa@fuchsia>
In-Reply-To: <1632469.6TRA6yZMTn@honzk>
References: <4783411.VVGoQz5kVU@fuchsia> <1632469.6TRA6yZMTn@honzk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 10 April 2014 19:17:13 Jan Kouba wrote:
> Dne Čt 10. dubna 2014 15:21:01, Michael Schuerig napsal(a):
> > SMART indicates that my notebook disk may soon be failing (an
> > unreadable/uncorrectable sector), therefore I intend to exchange it.
> > The disk contains a single btrfs filesystem with several nested(!)
> > subvolumes, each with several read-only snapshots in a .snapshots
> > subdirectory.
> > 
> > As far as I can tell, btrfs currently does not offer a sensible way
> > to duplicate the entire contents of the old disk onto a new one.
> Yes it does
> 
> You can make the old disk a seeding device and use it to seed the new
> one like this:

Intriguing. I didn't find much on the topic, but these pages seem 
pertinent

http://en.wikipedia.org/wiki/Btrfs#Seed_devices
https://btrfs.wiki.kernel.org/index.php/Seed-device
http://unix.stackexchange.com/a/97819/64935

> btrfstune -S 1 <old_device>

Does the "1" mean "true" or is this indeed an integer-value arg? I've 
only seen the "1" in examples, are there other possible values?

> mount <old_device> /mnt
> # this will be mounted read-only
> 
> btrfs dev add <new_device> /mnt
> 
> mount -o remount,rw /mnt
> 
> btrfs dev delete <old_device>

Is the last one the step where data is copied from the seed device to 
the second device? No balance required before deleting the device?

Thanks!

Michael

-- 
Michael Schuerig
mailto:michael@schuerig.de
http://www.schuerig.de/michael/

