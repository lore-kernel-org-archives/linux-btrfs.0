Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45199 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389Ab3CNTFH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Mar 2013 15:05:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UGDSx-0004uJ-9W
	for linux-btrfs@vger.kernel.org; Thu, 14 Mar 2013 20:05:27 +0100
Received: from p5dc4a722.dip.t-dialin.net ([93.196.167.34])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 20:05:27 +0100
Received: from scno by p5dc4a722.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Mar 2013 20:05:27 +0100
To: linux-btrfs@vger.kernel.org
From: "Norbert Scheibner" <scno@gmx.net>
Subject: Re: Debian 3.7.1 BTRFS crash
Date: Thu, 14 Mar 2013 20:04:08 +0100
Message-ID: <op.wtx9w60ur07q8e@tron.scheibner.rb>
References: <201303131238.33692.russell@coker.com.au>
 <513FDE67.1050907@redhat.com>
 <CALJXSJqNermOKN7KZ_8x2SP0J8-f7F=tRiEMym6UWum7_Vf-4A@mail.gmail.com>
 <CAGy7Uthf3P-4eefV-RbJQ=mW=OpjR3CXauPfCSbiv5eKMa5H8Q@mail.gmail.com>
 <51406375.6050502@petaramesh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 13.03.2013, 12:31 Uhr, schrieb Swâmi Petaramesh <swami@petaramesh.org>:

> Le 13/03/2013 11:56, Bart Noordervliet a écrit :
>> USB flash drives are rubbish for any filesystem except FAT32 and then
>> still only gracefully accept large sequential writes. A few years ago
>> I thought it would be a good idea to put the root partition of a few
>> of my small Debian servers on USB flash, so that the harddisks could
>> spin down at night and I could easily prepare and switch a new
>> Debian-version. However, each and every USB stick got trashed within a
>> year
> I have an ARM box that runs a little Debian server (typically an
> advanced NAS), it uses an USB key as an ext2 root filesystem. Everything
> but big storage is there, and it's been up and running 24/7 for 3+ years
> without any USB key incident...

The difference is the fs. Ext3 uses a journal which uses always the same
physical sectors on disc. If the disc is a hard disk, it does not matter,
rewrites are no problem for platters. If it is an modern SSD, the SSD-
controller takes care and redirects the writes to different physical
sectors. USB-sticks have no smart controller and so the writes hit
always the same physical sector, it's like burning a hole in the flash
chip. If the commit time is standard for desktops set to 5 seconds, then
a whole year means a lot of writes to the same sector on an USB-stick.

Regards
   Norbert

