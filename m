Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36840 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab2JGK7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2012 06:59:07 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, getting darn slower everyday
Date: Sun, 7 Oct 2012 12:59:05 +0200
References: <50714AC8.4010100@petaramesh.org> (sfid-20121007_121057_935818_E179B3F4)
In-Reply-To: <50714AC8.4010100@petaramesh.org>
Cc: =?iso-8859-1?q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210071259.05801.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 7. Oktober 2012 schrieb Swâmi Petaramesh:
> Hi,
> 
> I have 4 machines, all converted to BTRFS about 6 months ago, now all
> running Ubuntu Quantal with kernel 3.5.0-17
> 
> The matter is that all these machines are now getting slower and slower
> everyday, every disk access causing the disk to be 100% busy for long
> periods, to the point that I'm now seriously considering migrating
> everything back to ext4...
> 
> From the start BTRFS was "not very fast", still satisfactory, but now
> it becomes truly unusable.
> 
> On one machine, I know have a typical complete boot time to a usable
> GUI that is over 4 minutes, with the HD still very busy for a couple
> more minutes afterwards, where it used to be around 35-40 seconds in
> ext4 !
> 
> Is there anything I could do to speed things back (without losing all
> my snapshots or doubling the size of data on disk)...?
> 
> I already had made the move back from BTRFS to ext4 about 18 months
> ago, I found it had improved so was back to BTRFS, and I wouldn't have
> to revert back again :-/
> 
> Any advice or help greatly appreciated.

I experienced this on my oldest BTRFS filesystems on a ThinkPad T23 as 
well. Especially with fsync() based workloads like apt / aptitude dist-
upgrade. I use eatmydata for these operations for now on this laptop.

A balance didn´t work. I considering to redo those as node and leaf size 
16 KiB. But then anything above kernel 3.3 doesn´t resume reliably on the 
machine and I did not yet get into to finding out why. A kernel bisect 
would take ages on this machine unless I compile the kernels somewhere 
else.

Anyway, I think to better see what your issue is, it would be good to have 
some more information about free space and state of your BTRFS filesystem.

Such as

btrfs fi df (preferably with btrfs tools from Goffredo)
btrfs fi show

for starters.


[1] See Goffredo Baroncelli,
[PATCH][BTRFS-PROGS][V3] btrfs filesystem df last thursday:

You can pull this change from
   http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch
   disk_free

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
