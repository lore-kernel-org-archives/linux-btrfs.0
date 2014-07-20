Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:4273 "EHLO server"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753028AbaGTTX5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 15:23:57 -0400
Message-ID: <53CC1553.1020908@shiftmail.org>
Date: Sun, 20 Jul 2014 21:15:31 +0200
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: TM <tmjuju@yahoo.com>, linux-btrfs@vger.kernel.org
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
References: <loom.20140720T102642-239@post.gmane.org>
In-Reply-To: <loom.20140720T102642-239@post.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/07/2014 10:45, TM wrote:
> Hi,
>
> I have a raid10 with 4x 3TB disks on a microserver
> http://n40l.wikia.com/wiki/Base_Hardware_N54L , 8Gb RAM
>
> Recently one disk started to fail (smart errors), so I replaced it
> Mounted as degraded, added new disk, removed old
> Started yesterday
> I am monitoring /var/log/messages and it seems it will take a long time
> Started at about 8010631739392
> And 20 hours later I am at 6910631739392
> btrfs: relocating block group 6910631739392 flags 65
>
> At this rate it will take a week to complete the raid rebuild!!!
>
> Furthermore it seems that the operation is getting slower and slower
> When the rebuild started I had a new message every half a minute, now it’s
> getting to OneAndHalf minutes
> Most files are small files like flac/jpeg
>

Hi TM, are you doing other significant filesystem activity during this 
rebuild, especially random accesses?
This can reduce performances a lot on HDDs.
E.g. if you were doing strenous multithreaded random writes in the 
meanwhile, I could expect even less than 5MB/sec overall...

