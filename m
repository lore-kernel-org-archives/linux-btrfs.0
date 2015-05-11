Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:65079 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbbEKUDf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 16:03:35 -0400
Received: from [127.0.0.1] ([88.71.40.7]) by mrelayeu.kundenserver.de
 (mreue002) with ESMTPA (Nemesis) id 0MFDEx-1YyocI25Pf-00GIhz for
 <linux-btrfs@vger.kernel.org>; Mon, 11 May 2015 22:03:33 +0200
Message-ID: <55510B14.7090204@friedels.name>
Date: Mon, 11 May 2015 22:03:32 +0200
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: raid 5 and different device size
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I need your advice for the following scenario:
I do have three -identical- 3TB HDD. On these I store:
-Backups (Images of my Families Laptop; Backup of the Machines (the one 
with the HDD) running System).
-Videos (recordings, not essential)
-HomeVideos (Familiy, essential)
-Photos
-Documents

Now I intend to:
* increase the available disc space
* stop worrying how much space is available on which drive
* create redundancy
* have low operating cost (power-consumption)


So, I need to buy one additional HDD.
And I want to combine the drives to one big volume.

I am aware that raid is no backup.
Thus, I backup the HomeVideos and the Photos on an external drive not 
connected to the power supply and USB.

I think, that I do not need raid5, depending on the definition of 'not 
essential'. Nevertheless, raid5 would efficiently (at low cost) decrease 
the likelyhood of loss of the 'non-essential' data.
Furthermore, raid5 would fill the gap that I have between backups (the 
fact, that I do these backup manually means that I do not do them every 
day) and at least safe me from hardware failures.

So, yes, I think I do want raid5 and I want to combine.
But what size of HDD do I want to buy? The best value (cost per TB) I 
get for 3TB drives. So I could by two 3TB drives, one for additional 
space, the other for the parity information.
Or I could by one bigger drive, with potentially lower power 
consumption. But how would the raid5 look in this case? I fear, only 3TB 
of the 6 would be redundant and the other 3 would be not redundant, right?


Now the last point: Power consumption: Under which conditions can the 
drives spin down in case of raid5? I assume that all drives have to run 
as in case the data is written on any one of the drives, right?
Is that also true during reading of data, i.e. is the parity also 
checked for read operations?

Thanks for your advice in advance,
Hendrik





---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
http://www.avast.com

