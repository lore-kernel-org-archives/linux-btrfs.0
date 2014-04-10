Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:47946 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758726AbaDJRRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Apr 2014 13:17:15 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so3275996eek.13
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 10:17:14 -0700 (PDT)
Received: from honzk.localnet (nat-11.starnet.cz. [178.255.168.11])
        by mx.google.com with ESMTPSA id y7sm11327607eev.5.2014.04.10.10.17.13
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 10 Apr 2014 10:17:13 -0700 (PDT)
From: Jan Kouba <kouba.honza@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Copying a disk containing a btrfs filesystem
Date: Thu, 10 Apr 2014 19:17:13 +0200
Message-ID: <1632469.6TRA6yZMTn@honzk>
In-Reply-To: <4783411.VVGoQz5kVU@fuchsia>
References: <4783411.VVGoQz5kVU@fuchsia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dne Čt 10. dubna 2014 15:21:01, Michael Schuerig napsal(a):
> SMART indicates that my notebook disk may soon be failing (an
> unreadable/uncorrectable sector), therefore I intend to exchange it. The
> disk contains a single btrfs filesystem with several nested(!)
> subvolumes, each with several read-only snapshots in a .snapshots
> subdirectory.
> 
> As far as I can tell, btrfs currently does not offer a sensible way to
> duplicate the entire contents of the old disk onto a new one. 

Yes it does

You can make the old disk a seeding device and use it to seed the new one like 
this:


btrfstune -S 1 <old_device>

mount <old_device> /mnt
# this will be mounted read-only

btrfs dev add <new_device> /mnt

mount -o remount,rw /mnt

btrfs dev delete <old_device>

According to my experiments, the filesystem on the new device will have 
different UUID, so if you are mounting using UUIDs, you must change it 
everywhere, but other than that the new filesystem should have the same content 
as the old one (including subvolumes).


> I can use
> cp, rsync, or send/receive to copy the "main" subvolumes. But unless I'm
> missing something obvious, the snapshots are effectively lost. btrfs
> send optionally takes multiple clone sources, but I've never seen an
> example of its usage.
> 
> If that's what "experimental" means, I'm willing to accept it. However,
> I'd like to emphasize that there's still something missing. Of course,
> most of all I'd like to be proved wrong.
> 
> Michael

