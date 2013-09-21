Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:52396 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3IUCeS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 22:34:18 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 04FF37C068F
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 20:34:18 -0600 (MDT)
Date: Fri, 20 Sep 2013 22:34:15 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [REGRESSION] 3.12-rc1: Trying to create snapshot corrupted
 filesystem
Message-ID: <20130921023415.GE5672@localhost.localdomain>
References: <5021349.IU75SGaY0J@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5021349.IU75SGaY0J@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 21, 2013 at 12:25:02AM +0200, Martin Steigerwald wrote:
> Hi!
> 
> I tried to create a snapshot today like this:
> 
> merkaba:/mnt/debian-zeit> ls -l
> insgesamt 0
> drwxr-xr-x 1 root root 210 Sep 20 11:48 root
> merkaba:/mnt/debian-zeit> btrfs subvol list /
> ID 256 gen 21382 top level 5 path root
> merkaba:/mnt/debian-zeit> btrfs subvol snap -r root root-2013-09-20
> merkaba:/mnt/debian-zeit#1>
> 

You will want the patch I just sent,

Btrfs: create the uuid tree on remount rw

and that should fix the snapshot problems.  Thanks,

Josef
