Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49236 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750994AbaAPUFs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jan 2014 15:05:48 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [newb] btrfs send problem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <lb8ue0$hic$1@ger.gmane.org>
Date: Thu, 16 Jan 2014 13:05:41 -0700
Cc: Users Fedora <users@lists.fedoraproject.org>
Message-Id: <AA1BAEB9-93C6-4D28-9C70-CB5705EA81FF@colorremedies.com>
References: <lb8ue0$hic$1@ger.gmane.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 16, 2014, at 8:38 AM, Neal Becker <ndbecker2@gmail.com> wrote:

> I hope this is an appropriate place to ask user questions.
> 
> I'm trying out snapshot and replication.  I have
> 
> /dev/sda3 on / type btrfs (rw,relatime,ssd,space_cache)
> /dev/sda3 on /home type btrfs (rw,relatime,ssd,space_cache)
> 
> create a subvolume for snapshots:
> 
> #btrfs sub create /.snapshots
> Create subvolume '//.snapshots'
> 
> [root@nbecker1 nbecker]# btrfs subvolume list /
> ID 256 gen 563396 top level 5 path home
> ID 258 gen 563396 top level 5 path root
> ID 372 gen 563396 top level 258 path .snapshots
> 
> [root@nbecker1 nbecker]# btrfs sub snapshot -r /home /.snapshots
> Create a readonly snapshot of '/home' in '/.snapshots/home'
> 
> [root@nbecker1 nbecker]# btrfs subvolume list /
> ID 256 gen 563398 top level 5 path home
> ID 258 gen 563398 top level 5 path root
> ID 372 gen 563398 top level 258 path .snapshots
> ID 373 gen 563398 top level 258 path .snapshots/home
> 
> [root@nbecker1 nbecker]# btrfs send /.snapshots/home > /dev/null
> At subvol /.snapshots/home
> ERROR: open root/.snapshots/home failed. No such file or directory

It's not OK to multipost. You should have crossposted. Or better, pick one list, wait some reasonable time for an answer, then post to a different list. Otherwise you look impatient and are just wasting people's time reading and answering emails they've already read or answered elsewhere. 

Like I said on Fedora Users, this command:
> btrfs sub snapshot -r /home /.snapshots

has created a read-only snapshot of /home, inside <TOP_level>/root/.snapshots/home

And this:
> [root@nbecker1 nbecker]# btrfs send /.snapshots/home > /dev/null
> At subvol /.snapshots/home
> ERROR: open root/.snapshots/home failed. No such file or directory

That could be a bug. I'm able to reproduce this on 3.13.0-0.rc8.

Chris Murphy