Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:45543 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756052AbaITS3Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Sep 2014 14:29:16 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49693 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XVPPH-002t2T-NV
	for linux-btrfs@vger.kernel.org; Sat, 20 Sep 2014 12:29:15 -0600
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Performance Issues
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <lvk073$56j$1@ger.gmane.org>
Date: Sat, 20 Sep 2014 12:29:14 -0600
Message-Id: <44654894-DA31-47AC-B6D8-AB1E64CC0733@colorremedies.com>
References: <1411129114.1811.7.camel@zarniwoop.blob> <pan.2014.09.19.13.51.22@googlemail.com> <1678306.dObPo7E7s7@fb07-iapwap2> <lvk073$56j$1@ger.gmane.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 20, 2014, at 7:41 AM, Martin <m_btrfs@ml1.co.uk> wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 20/09/14 09:23, Marc Dietrich wrote:
>> Am Freitag, 19. September 2014, 13:51:22 schrieb Holger
>> Hoffstätte:
>>> 
>>> On Fri, 19 Sep 2014 13:18:34 +0100, Rob Spanton wrote:
>>> 
>>>> I have a particularly uncomplicated setup (a desktop PC with a
>>>> hard disk) and I'm seeing particularly slow performance from
>>>> btrfs.  A `git status` in the linux source tree takes about 46
>>>> seconds after dropping caches, whereas on other machines using
>>>> ext4 this takes about 13s.  My mail client (evolution) also
>>>> seems to perform particularly poorly on this setup, and my
>>>> hunch is that it's spending a lot of time waiting on the
>>>> filesystem.
>>> 
>>> This is - unfortunately - a particular btrfs
>>> oddity/characteristic/flaw, whatever you want to call it. git
>>> relies a lot on fast stat() calls, and those seem to be
>>> particularly slow with btrfs esp. on rotational media. I have the
>>> same problem with rsync on a freshly mounted volume; it gets fast
>>> (quite so!) after the first run.
>> 
>> my favorite benchmark is "ls -l /usr/bin":
>> 
>> ext4:     0.934s btrfs:   21.814s
> 
> 
> So... On my old low power slow Atom SSD ext4 system:
[snip]
> On a comparatively super dual core Athlon64 SSD btrfs three disk btrfs
> raid1 system:
[snip]

Yeah between XFS and Btrfs in the same VM I'm not seeing anything like Marc's numbers. Both fs's are newish but have been significantly updated, and the Btrfs one has a pile of debuginfo rpms installed.

XFS:
time mount /mnt/xfs
time ls -l /mnt/xfs/usr/bin
real 0m0.205s
ls -l /mnt/xfs/usr/bin | wc
1625	14978	100833

Btrfs:
time mount /mnt/btrfs
time ls -l /mnt/btrfs/usr/bin
real 0m0.482s
ls -l /mnt/btrfs/usr/bin | wc
1817	16724	110364


XFS:
time tree -al /mnt/xfs/usr
14050 dirs, 193464 files
real 18.336

Btrfs:
time tree -al /mnt/btrfs/usr
15552 dirs, 165958 files
real 21.029s


> (Yes, there is the manual fix of NOCOW... I also put such horrors into
> tmpfs and snapshot that... All well and good but all unnecessary admin
> tasks!)

This is kinda interesting. 20 lines of code.
http://blog.delphix.com/uday/2013/02/19/78/

I'm curious what pathologies it'd reveal in Btrfs, but also say XFS on LVM thinp with and without snapshots.


Chris Murphy

