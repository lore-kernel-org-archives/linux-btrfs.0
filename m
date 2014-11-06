Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:35287 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750999AbaKFD5K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Nov 2014 22:57:10 -0500
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:57185 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:RC4-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XmEC5-000mCS-2Y
	for linux-btrfs@vger.kernel.org; Wed, 05 Nov 2014 20:57:09 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [bug] btrfs fi show lists wrong (old) devid size after btrfs replace
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <E709B43E-A4B5-4DEC-940B-BBABE1116409@colorremedies.com>
Date: Wed, 5 Nov 2014 20:57:07 -0700
Message-Id: <4BEAF5A0-FA49-464B-8D32-9F29204043A3@colorremedies.com>
References: <EC620053-6EDC-4122-AAA5-0AC86814B04A@colorremedies.com> <E709B43E-A4B5-4DEC-940B-BBABE1116409@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 5, 2014, at 8:28 PM, Chris Murphy <lists@colorremedies.com> wrote:

> Filed a bug. The btrfs fi show, and (conventional) df command are the same with kernel-3.18.0-0.rc3.git0.1.fc22.x86_64
> https://bugzilla.kernel.org/show_bug.cgi?id=87851
> 
> I'm going to guess this is a btrfs-progs bug not resizing the file system to "max"; I'm pretty sure this was working at one time but it's been a while since I've done a replace, maybe not since progs 3.14.

# btrfs fi resize 2:max /mnt/btrfs1
Resize '/mnt/btrfs1' of '2:max'
[root@f21m ~]# btrfs fi show /mnt/btrfs1
Label: 'btrfs1'  uuid: 0f1c615f-30a0-4166-8a3c-987849551513
	Total devices 2 FS bytes used 282.03GiB
	devid    1 size 465.76GiB used 284.03GiB path /dev/sdc
	devid    2 size 698.64GiB used 284.03GiB path /dev/sdb
Btrfs v3.17


That appears to have fixed the problem. Uncertain if this is the intended behavior.


Chris Murphy