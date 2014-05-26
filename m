Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33650 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbaEZPVR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 May 2014 11:21:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wowi8-0002y1-Lg
	for linux-btrfs@vger.kernel.org; Mon, 26 May 2014 17:21:12 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 May 2014 17:21:12 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 26 May 2014 17:21:12 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Btrfs filesystem freezing during snapshots
Date: Mon, 26 May 2014 16:20:55 +0100
Message-ID: <llvm4o$9uv$1@ger.gmane.org>
References: <CA+3u+RcGa2Xr+mzwGL-V89A7DEa05B_NS+cgS-Es1b3d8b5xKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <CA+3u+RcGa2Xr+mzwGL-V89A7DEa05B_NS+cgS-Es1b3d8b5xKg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 26/05/14 13:28, David Bloquel wrote:
> Hi,
> 
> I have a problem with my btrfs filesystem which is freezing when I am
> doing snapshots.
> 
> I have a cron that is snapshoting around 70 sub volume every ten
> minutes. The sub volumes that btrfs is snapshoting are containers
> folders that are running through my virtual environment.
> Sub directories that btrfs is snapshoting are not that big (from 500MB
> to 10GB max and usually around 3GB) but there is a lot of IO on the
> filesystem because of the intensive use of the CTs and VMs.
> 
> At some point the snapshot process becomes really slow, at first it
> snapshot around one folder per seconds but then after a while it can
> take 30seconds or even few minutes to snapshot one single sub volumes.
> Subvolumes are really similar to each other in size and number of
> files so there is no reason that it takes 1second for one sub volume
> and then 3minutes for another one.
> 
> Moreover when my snapshot cron is running all my vms and containers
> are slowing down until the whole filesystem freezes which leads to
> frozen CT and VMs (which is a real problem for me).
> 
> Moreover I can see that my CPU load is really high during the process.
> 
> when I'm am looking to dmesg there is a lot of messages of this kind:
> 
> [96537.686467] BTRFS debug (device drbd0): unlinked 290 orphans
[...]

That looks to be running on top of drbd which will add a network write
overhead (unless you are dangerously running asynchronously!). Hence you
will see IO speed related limits a little sooner...

However, I will guess that your primary problem is likely due to
accumulating fragmentation due to adding ever more snapshots every 10
mins for the VMs/containers.


There are other people far more practised here than I, but some guesses
to try are:


Use "nocow" for the VM images (and container images);

Try using the btrfs auto defrag (beware your IO speed limit vs file size
to be defragged);

Avoid accumulating too many versions of any one snapshot.


Note also the "experimental" status for btrfs... I'm sure you will have
noticed the previous race problems for deleting snapshots.

Aside: I've held off from using kernel 3.12 and 3.13 due to curious
happenings on my test system. kernel 3.14.4 is behaving well so far.


Hope that gives a few clues.

Good luck,
Martin


