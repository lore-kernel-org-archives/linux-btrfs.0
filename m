Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61200 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab2IEXPa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Sep 2012 19:15:30 -0400
Received: by wgbdr13 with SMTP id dr13so1083798wgb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Sep 2012 16:15:29 -0700 (PDT)
Message-ID: <5047DD0F.9040501@statystyka.net>
Date: Thu, 06 Sep 2012 01:15:27 +0200
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Seagate Momentus XT and btrfs corruption
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Welcome,

I experience continuus degradation of btrfs system partition on hybrid 
750GB Seagate Momentus XT-2  (ATA ST750LX003-1AC15, rev. SM12). dmesg 
fills with hundreds of errors like "btrfs csum failed ino 93608 off 
425984 csum 2316250426 private 3579463503".

I had simmilar problems with the older model, Seagate Momentus XT bought 
two years ago, where firmware update didn't solve them (cf. 
http://superuser.com/questions/313447/seagate-momentus-xt-corrupting-files-linux-and-mac 
and 
http://forums.seagate.com/t5/Momentus-XT-Momentus-Momentus/Momentus-XT-corrupting-large-files-Linux/m-p/109008). 


Now I want to give Linux another try on this amazingly fast hardrive. 
Yes - the drive perfectly well under default drivers on Windows XP. I 
use it everyday and I never lost a single byte under Windows.

What can I do on my part to help you troubleshoot the problem? I guess I 
might do some sort of tripwiring files to see that their contents 
actually degrades, but I think it the result is obvious and not very 
helpful to you.

If you can't help me, please advise me, how to heal the partition - the 
offline btrfsck (from btrfs-tools 0.19 available on Mint 13) doesn't fix 
anything here.

Is there any way to tell which files are getting broken?

I use Mint 13, 3.2.0-30-generic 64-bit kernel.

-- 

Adam Ryczkowski
Skype:sisteczko <skype:sisteczko>

