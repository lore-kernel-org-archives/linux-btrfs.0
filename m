Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay01.libero.it ([212.52.84.101]:57466 "EHLO
	outrelay01.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaFLLFF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 07:05:05 -0400
Message-ID: <1008028489.2721751402571101092.JavaMail.defaultUser@defaultHost>
Date: Thu, 12 Jun 2014 13:05:01 +0200 (CEST)
From: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
Reply-To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
To: <lists@colorremedies.com>
Subject: R: Re: Slow startup of systemd-journal on BTRFS
Cc: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>----Messaggio originale----
>Da: lists@colorremedies.com
>Data: 12/06/2014 2.40
>A: <kreijack@inwind.it>, "Goffredo Baroncelli"<kreijack@libero.it>
>Cc: "systemd Mailing List"<systemd-devel@lists.freedesktop.org>, "linux-btrfs"
<linux-btrfs@vger.kernel.org>
>Ogg: Re: Slow startup of systemd-journal on BTRFS
>
>
>On Jun 11, 2014, at 3:28 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
>> 
>> If someone is able to suggest me how FRAGMENT the log file, I can try to 
collect more scientific data.
>
>So long as you're not using compression, filefrag will show you fragments of 
systemd-journald journals. I can vouch for the behavior 
> you experience without xattr +C or autodefrag, but further it also causes 
much slowness when reading journal contents. LIke if I want to 
> search all boots for a particular error message to see how far back it 
started, this takes quite a bit longer than on other file systems. 
> So far I'm not experiencing this problem with autodefrag or any other 
negative side effects, but my understanding is this code is still in flux.
>
>Since the journals have their own checksumming I'm not overly concerned about 
setting xattr +C.

This is true; but it can be a general solution: the checksum of the data are 
needed during a 
scrub and/or a RAID rebuilding.

I want to investigate doing an explicit defrag once a week.


>
>Chris Murphy
G.Baroncelli

