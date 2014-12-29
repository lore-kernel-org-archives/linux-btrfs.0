Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60355 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaL2NZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 08:25:10 -0500
Received: from merkaba.localnet (host-188-174-199-225.customer.m-online.net [188.174.199.225])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id AD3E3206
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Dec 2014 14:24:18 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: fstrim not working on one of three BTRFS filesystems
Date: Mon, 29 Dec 2014 14:23:38 +0100
Message-ID: <2085969.4UDoZBNBiV@merkaba>
In-Reply-To: <3979684.puYLD8DjTq@merkaba>
References: <3979684.puYLD8DjTq@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 28. Dezember 2014, 17:58:17 schrieb Martin Steigerwald:
> Hi!
> 
> After my recent tests with my /home filesystem and the up and downsizing of
> it I get:
> 
> 
> merkaba:~> LANG=C fstrim -v /home
> /home: 0 B (0 bytes) trimmed
> merkaba:~> LANG=C fstrim -v /    
> /: 24.5 GiB (26257555456 bytes) trimmed
> merkaba:~> LANG=C fstrim -v /daten
> /daten: 2.8 GiB (3016101888 bytes) trimmed
> 
> 
> The fstrim on /home returns immediately. It does not even seem to trim
> anything. What could be the cause for that?

I have a 3.19-rc2 with a patch and a working fstrim now:

merkaba:~> btrfs scrub status /home
scrub status for […]
        scrub started at Mon Dec 29 13:48:17 2014 and finished after 568 seconds
        total bytes scrubbed: 272.73GiB with 0 errors

merkaba:~> fstrim -v /home
/home: 18,5 GiB (19873382400 Bytes) getrimmt

merkaba:~> btrfs scrub status /home
scrub status for […]
        scrub started at Mon Dec 29 14:02:58 2014 and finished after 576 seconds
        total bytes scrubbed: 272.82GiB with 0 errors

merkaba:~> btrfs fi df /home
Data, RAID1: total=139.93GiB, used=133.19GiB
System, RAID1: total=32.00MiB, used=48.00KiB
Metadata, RAID1: total=4.99GiB, used=3.24GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

merkaba:~> LANG=C df -hT /home
Filesystem             Type   Size  Used Avail Use% Mounted on
/dev/mapper/msata-home btrfs  170G  137G   32G  82% /home



I wonder about the trimmed size tough:

139,93 - 133,19 = 6,74

4,99 - 3,24 = 1,74

( 6,74 + 1,74 ) * 2 =  16,96 GiB


It is more than whats free inside the chunks but less than the total unused
space. Well it may have been up to what has been allocated as chunks
as I had more chunks allocated in it.


I leave it to the patch author to come up with it on the mailing list :)

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
