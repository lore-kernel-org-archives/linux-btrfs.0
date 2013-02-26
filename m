Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47634 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3BZKad (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 05:30:33 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: lvm volume like support
Date: Tue, 26 Feb 2013 11:30:31 +0100
Cc: "Fajar A. Nugraha" <list@fajar.net>,
        Mike Fleetwood <mike.fleetwood@googlemail.com>,
        Suman C <schakrava@gmail.com>
References: <CAPF83msjTJWjWJgJOAWsQ2GoxAC-cZ4GkK_+H11tAyA689KD_w@mail.gmail.com> <CAMU1PDhQqm6s5FUbVJa5nwOD4Ewf-6Cr2gx2khHHwrBxUqsQDA@mail.gmail.com> <CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com> (sfid-20130226_100033_972763_9AF0DA19)
In-Reply-To: <CAG1y0scOg2QGCZdCTkKHBn5xxNh5GGmdXTcS8rOesup4r1JsXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201302261130.31494.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag, 26. Februar 2013 schrieb Fajar A. Nugraha:
> On Tue, Feb 26, 2013 at 11:59 AM, Mike Fleetwood
> 
> <mike.fleetwood@googlemail.com> wrote:
> > On 25 February 2013 23:35, Suman C <schakrava@gmail.com> wrote:
> >> Hi,
> >> 
> >> I think it would be great if there is a lvm volume or zfs zvol type
> >> support in btrfs.
> > 
> > Btrfs already has capabilities to add and remove block devices on the
> > fly.  Data can be stripped or mirrored or both.  Raid 5/6 is in
> > testing at the moment.
> > https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devic
> > es https://btrfs.wiki.kernel.org/index.php/UseCases#RAID
> > 
> > Which specific features do you think btrfs is lacking?
> 
> I think he's talking about zvol-like feature.
> 
> In zfs, instead of creating a
> filesystem-that-is-accessible-as-a-directory, you can create a zvol
> which behaves just like any other standard block device (e.g. you can
> use it as swap, or create ext4 filesystem on top of it). But it would
> also have most of the benefits that a normal zfs filesystem has, like:
> - thin provisioning (sparse allocation, snapshot & clone)
> - compression
> - integrity check (via checksum)
> 
> Typical use cases would be:
> - swap in a pure-zfs system
> - virtualization (xen, kvm, etc)
> - NAS which exports the block device using iscsi/AoE
> 
> AFAIK no such feature exist in btrfs yet.

Sounds like the RADOS block device stuff for Ceph.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
