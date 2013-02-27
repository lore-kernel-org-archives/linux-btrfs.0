Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55892 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697Ab3B0ImG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 03:42:06 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Roman Mamedov <rm@romanrm.ru>
Subject: Re: lvm volume like support
Date: Wed, 27 Feb 2013 09:42:02 +0100
Cc: "Fajar A. Nugraha" <list@fajar.net>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>,
        Mike Fleetwood <mike.fleetwood@googlemail.com>,
        Suman C <schakrava@gmail.com>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com> <CAG1y0sfYqcZTyHffV=t95R09qyJc911ZE-F-YPM1rKmV1wj7CA@mail.gmail.com> <20130227100558.37d86d82@natsu> (sfid-20130227_093816_118988_B48DD80A)
In-Reply-To: <20130227100558.37d86d82@natsu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201302270942.03347.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 27. Februar 2013 schrieb Roman Mamedov:
> On Wed, 27 Feb 2013 13:23:23 +1100
> 
> "Fajar A. Nugraha" <list@fajar.net> wrote:
> > Not to mention the hassle in accessing the data if it resides on a 
> > partition inside the file (e.g. you need losetup + kpartx to access it,
> > and you must remember to do the reverse when you're finished with it).
> >
> > 
> >
> > In zfsonlinux it's very easy to do so since a zvol is treated pretty
> > much like a disk, and whenever there's a partition inside a zvol, a
> > coressponding device noed is also created automatically.
> 
> So I'd say what you (we) need is a generic Linux kernel framework that
> would allow treating any regular file pretty much like a disk. Not some
> filesystem-specific block device emulation kludge.
> 
> Btw some years ago there was a patchset adding proper automatic partition
> support to 'loop'; but it seems like that went nowhere, and I have no
> idea why something this useful did not end up being added into the
> mainline kernel.

Are you sure about the partition support? I thought something related to 
loop partition support has gone into some not so recent kernel.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
