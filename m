Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:52332 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3IUCQK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 22:16:10 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 73E837C067E
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 20:16:10 -0600 (MDT)
Date: Fri, 20 Sep 2013 22:16:08 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [REGRESSION] 3.12-rc1: Trying to create snapshot corrupted
 filesystem
Message-ID: <20130921021608.GB5672@localhost.localdomain>
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

Nevermind I've reproduced it, sorry about that I will get it fixed up and a
patch sent out right away.  Thanks,

Josef
