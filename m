Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:43504 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbJBDyl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Oct 2015 23:54:41 -0400
From: Russell Coker <russell@coker.com.au>
To: Chris Murphy <lists@colorremedies.com>
Subject: Re: strange i/o errors with btrfs on raid/lvm
Date: Fri, 2 Oct 2015 13:54:36 +1000
Cc: Jogi =?utf-8?q?Hofm=C3=BCller?= <jogi@mur.at>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <560409E7.5020500@mur.at> <5605ADE4.5090800@mur.at> <CAJCQCtTaagpqurnjLeN7Mw8oBv59uWYtMbOb5REo8NgiP+UjjA@mail.gmail.com>
In-Reply-To: <CAJCQCtTaagpqurnjLeN7Mw8oBv59uWYtMbOb5REo8NgiP+UjjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201510021354.36255.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 26 Sep 2015 06:47:26 AM Chris Murphy wrote:
> And then
> 
> Aug 28 17:06:49 host mdadm[2751]: RebuildFinished event detected on md
> device /dev/md/0, component device  mismatches found: 2048 (on raid
> level 10)
> Aug 28 17:06:49 host mdadm[2751]: SpareActive event detected on md
> device /dev/md/0, component device /dev/sdd1

https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=405919#41

For Linux Software RAID-1 it's expected that you get a multiple of 128 
mismatches found every time you do a scan.  I don't know why that is, but 
systems running like that don't appear to have any problems.  This even 
appears to happen on arrays that aren't in any noticable use (EG swap on a 
server that has heaps of RAM so swap doesn't get used).  The above URL 
describes part of the problem but if that was the entire explanation then I'd 
expect multiples of 8 not 128.  Also the explanation that Neil offers doesn't 
seem to cover the case of 10,000+ mismatches occurring in the weekly scrubs.

Linux Software RAID-10 works the same way in this regard.  So I'm not sure 
that the log entries in question mean anything other than a known bug in Linux 
Software RAID.

I have servers that have been running well for years while repeatedly 
reporting such errors on Linux Software RAID-1 and not getting any FSCK 
problems.  Note that the servers in question don't run BTRFS because years ago 
it really wasn't suitable for server use.  It is possible that there are 
errors that aren't detected by e2fsck, don't result in corruption of gzip 
compressed data, don't give MySQL data consistency errors, and don't corrupt 
any user data in a noticable way.  But it seems to be evidence in support of 
the theory that such mismatches don't matter.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
