Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.robertbuhren.de ([78.46.128.139]:57388 "EHLO
	mail.robertbuhren.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab3DGJHB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2013 05:07:01 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.robertbuhren.de (Postfix) with ESMTP id 7570D20420
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Apr 2013 10:58:50 +0200 (CEST)
Received: from mail.robertbuhren.de ([127.0.0.1])
	by localhost (mail.robertbuhren.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iTK4EUYchrU9 for <linux-btrfs@vger.kernel.org>;
	Sun,  7 Apr 2013 10:58:50 +0200 (CEST)
Received: from [192.168.178.36] (dslb-178-000-098-045.pools.arcor-ip.net [178.0.98.45])
	by mail.robertbuhren.de (Postfix) with ESMTPSA id 0B06F1FF20
	for <linux-btrfs@vger.kernel.org>; Sun,  7 Apr 2013 10:58:49 +0200 (CEST)
Message-ID: <51613541.3080009@robertbuhren.de>
Date: Sun, 07 Apr 2013 10:58:41 +0200
From: Robert Buhren <robert@robertbuhren.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: "btrfs send" fails with having too many open fd's
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

i'm trying to send/receive a snapshot of my home dir for some time now, 
but in the end it always fails because the maximum number of open fd's 
is exceeded.

Kern log says:

"6,7226,15012711248,-;VFS: file-max limit 799969 reached"


My setup is as follows:

Kernel: 3.9-rc5
btrfs-progs: compiled from git commit: commit 
7854c8b667654502f69e05584729146a06827bc6

btrfs fi show:

Label: none  uuid: ccedbef9-417b-454c-b1d4-8b4220111e6a
     Total devices 1 FS bytes used 177.79GB
     devid    1 size 210.85GB used 210.85GB path /dev/dm-0

Label: 'BACKUP'  uuid: 019e75e4-aa2e-495d-9711-28ef7150b1f3
     Total devices 2 FS bytes used 137.35GB
     devid    2 size 298.09GB used 142.01GB path /dev/sdc1
     devid    1 size 298.09GB used 142.03GB path /dev/sdb1


The send fs is on a dm-crypt device and the receive on a btrfs raid1
A scrub for both fs ran fine without errors.I can however send/receive 
my root fs which is much smaller (~17GB).

The error occurs also if i just use "btrfs send" and pipe the output to 
a file.
It takes a very long time before my system crashes (several hours) so i 
wasn't able to monitor when exactly the fd's increase.
In the beginning "btrfs send" just opens less than 10 fd's, but at some 
point "btrfs send" must open much more.

If further information is needed, i'd be happy to help. I'm also in 
#btrfs on freenode.

Regards,

Robert


PS: Please respond to my email, i'm not subscribed to the list.

