Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:53952 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3CUSAW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 14:00:22 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 508B89A0365
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 12:00:22 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <514ABEB8.3090104@profihost.ag>
In-Reply-To: <514ABEB8.3090104@profihost.ag>
Message-ID: <20130321180020.30044.84729@localhost.localdomain>
Subject: Re: No space left on device (28)
Date: Thu, 21 Mar 2013 14:00:20 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Stefan Priebe - Profihost AG (2013-03-21 04:03:04)
> Hi,
> 
> while copying a 15GB file to my btrfs volume i'm getting "No space left
> on device".
> 
> Some information:
> 
> # btrfs filesystem df /mnt/
> Data: total=18.14TB, used=15.05TB
> System, DUP: total=8.00MB, used=1.94MB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=23.98GB, used=17.97GB
> Metadata: total=8.00MB, used=0.00
> 
> # df -h
> Filesystem             Size  Used Avail Use% Mounted on
> /dev/mapper/raid54tb1   19T   16T  3,1T  84% /mnt
> 
> # btrfs fi show
> Label: none  uuid: fc23c4a8-a351-4c91-96a2-ee6abeffe59a
>         Total devices 1 FS bytes used 15.07TB
>         devid    1 size 18.19TB used 18.19TB path /dev/dm-3
> 
> # btrfs fi balance start -dusage=5 /mnt/
> Done, had to relocate 0 out of 18604 chunks
> 
> What wrong here? What is about the last 3TB?

Which kernel are you running?

-chris

