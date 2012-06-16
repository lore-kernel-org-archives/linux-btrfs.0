Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38183 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab2FPUjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Jun 2012 16:39:08 -0400
Received: from merkaba.localnet (ppp-93-104-149-2.dynamic.mnet-online.de [93.104.149.2])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id F0B9FB9
	for <linux-btrfs@vger.kernel.org>; Sat, 16 Jun 2012 22:39:07 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: kernel got struck while scrubbing BTRFS with node- and leafsize 32768
Date: Sat, 16 Jun 2012 22:39:07 +0200
References: <201206162223.20392.Martin@lichtvoll.de> <201206162238.23317.Martin@lichtvoll.de> (sfid-20120616_223830_843642_2480E24F)
In-Reply-To: <201206162238.23317.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201206162239.07546.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 16. Juni 2012 schrieb Martin Steigerwald:
> Am Samstag, 16. Juni 2012 schrieb Martin Steigerwald:
> > merkaba:~> date ; btrfs scrub status /mnt/amazon-daten
> > Sa 16. Jun 22:06:33 CEST 2012
> > scrub status for bd94ea73-6e77-4c81-b053-2401b4f52b3e
> > 
> >         scrub started at Sat Jun 16 21:44:09 2012, running for 1341
> > 
> > seconds total bytes scrubbed: 90.30GB with 0 errors
> > merkaba:~> date ; btrfs scrub cancel /mnt/amazon-daten
> > Sa 16. Jun 22:06:47 CEST 2012
> > [… hangs here …]
> 
> btrfs-readahead is stuck:
> 
> merkaba:~> ps aux | egrep "(USER| D)"
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME
> COMMAND root     11920  0.0  0.0      0     0 ?        D    21:46  
> 0:00 [btrfs-readahead] root     13649  0.0  0.0  10544   396 pts/0   
> D+   22:06   0:00 btrfs scrub cancel /mnt/amazon-daten root     16309 
> 0.0  0.0   9816   948 pts/1    S+   22:24   0:00 egrep (USER| D)
> 
> I created a bug report with a
> 
> kern.log including echo t > /proc/sysrq-trigger with stuck readahead

There we go:

Bug 43491 - BTRFS hangs while scrubbing with node- and leafsize 32768 
https://bugzilla.kernel.org/show_bug.cgi?id=43491

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
