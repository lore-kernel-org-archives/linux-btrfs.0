Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:51163 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3CNXSA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 19:18:00 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Debian 3.7.1 BTRFS crash
Date: Fri, 15 Mar 2013 00:17:31 +0100
Cc: "Norbert Scheibner" <scno@gmx.net>
References: <201303131238.33692.russell@coker.com.au> <51406375.6050502@petaramesh.org> <op.wtx9w60ur07q8e@tron.scheibner.rb> (sfid-20130314_213144_871524_DFD07D4F)
In-Reply-To: <op.wtx9w60ur07q8e@tron.scheibner.rb>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201303150017.31524.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 14. März 2013 schrieb Norbert Scheibner:
> Am 13.03.2013, 12:31 Uhr, schrieb Swâmi Petaramesh <swami@petaramesh.org>:
> > Le 13/03/2013 11:56, Bart Noordervliet a écrit :
> >> USB flash drives are rubbish for any filesystem except FAT32 and then
> >> still only gracefully accept large sequential writes. A few years ago
> >> I thought it would be a good idea to put the root partition of a few
> >> of my small Debian servers on USB flash, so that the harddisks could
> >> spin down at night and I could easily prepare and switch a new
> >> Debian-version. However, each and every USB stick got trashed within a
> >> year
> > 
> > I have an ARM box that runs a little Debian server (typically an
> > advanced NAS), it uses an USB key as an ext2 root filesystem.
> > Everything but big storage is there, and it's been up and running 24/7
> > for 3+ years without any USB key incident...
> 
> The difference is the fs. Ext3 uses a journal which uses always the same
> physical sectors on disc. If the disc is a hard disk, it does not matter,
> rewrites are no problem for platters. If it is an modern SSD, the SSD-
> controller takes care and redirects the writes to different physical
> sectors. USB-sticks have no smart controller and so the writes hit
> always the same physical sector, it's like burning a hole in the flash
> chip. If the commit time is standard for desktops set to 5 seconds, then
> a whole year means a lot of writes to the same sector on an USB-stick.

Are you sure that modern, high quality USB sticks don´t do any wear 
leveling?

On some SD cards there is some FAT optimizition in place[1][2]. I.e. good 
random access at beginning of drive, where FAT table and thus random I/O 
metadata accesses are. Ext3 places metadata elsewhere - I believe in about 
the middle of the partition.

[1] Flash memory card design, FAT optimization

https://wiki.linaro.org/WorkingGroups/KernelArchived/Projects/FlashCardSurvey

[2] Arnd Bergmann, Optimizing Linux with cheap flash drives

https://lwn.net/Articles/428584/

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
