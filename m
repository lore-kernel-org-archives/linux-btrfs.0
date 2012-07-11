Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay02.libero.it ([212.52.84.102]:44230 "EHLO
	outrelay02.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab2GKMAT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jul 2012 08:00:19 -0400
Message-ID: <33267066.1581931342008009968.JavaMail.defaultUser@defaultHost>
Date: Wed, 11 Jul 2012 14:00:09 +0200 (CEST)
From: "kreijack@inwind.it" <kreijack@inwind.it>
Reply-To: "kreijack@inwind.it" <kreijack@inwind.it>
To: <arnd@arndnet.de>
Subject: R: Re: 3.5.0-rc6: btrfs and LVM snapshots -> wrong devicename in
 /proc/mounts
Cc: Goffredo Baroncelli <kreijack@libero.it>,
        Christian Robert <christian.robert@polymtl.ca>,
        <linux-btrfs@vger.kernel.org>, Josef Bacik <jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>----Messaggio originale----
>Da: arnd@arndnet.de
>Data: 10/07/2012 22.09
>A: <kreijack@inwind.it>
>Cc: "Goffredo Baroncelli"<kreijack@libero.it>, "Christian Robert"<christian.
robert@polymtl.ca>, <linux-btrfs@vger.kernel.org>
>Ogg: Re: 3.5.0-rc6: btrfs and LVM snapshots -&gt; wrong devicename in 
/proc/mounts
>
>Hi Goffredo,
>
>Am 10.07.2012 20:42, schrieb Goffredo Baroncelli:
>> Hi Arnd,
>> 
>> I am trying to reproduce this bug. Which kernel version are you using ?
>
>I'm using linus' vanilla tree from Sunday which is 3.5.0-rc6
>plus some unsuspicious commits.

Right, a recent Josef Bacik's patch[1] changes how the device name is 
computated. This explains why on a 3.4.4 
kernel I was not able to reproduce the bug. Anyway the problem is not in the 
Bacik's patch 
but in the fact that btrfs allow to replace an already mounted device. I am 
working on a patch which doesn't allow that.

BR
G.Baroncelli

>
>Best regards
>Arnd
>

[1] http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg16994.html


