Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:41669 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaFOVb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 17:31:58 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org, systemd-devel@lists.freedesktop.org
Subject: Re: Slow startup of systemd-journal on BTRFS
Date: Sun, 15 Jun 2014 23:31:07 +0200
Message-ID: <2067769.SxD8Z17WRg@merkaba>
In-Reply-To: <pan$625ac$a8aa7477$d0179ebe$c66ba817@cox.net>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <539B78F3.9070607@libero.it> <pan$625ac$a8aa7477$d0179ebe$c66ba817@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 14. Juni 2014, 02:53:20 schrieb Duncan:
> > I am reaching the conclusion that fallocate is not the problem. The
> > fallocate increase the filesize of about 8MB, which is enough for some
> > logging. So it is not called very often.
> 
> But... 
> 
> If a file isn't (properly[1]) set NOCOW (and the btrfs isn't mounted with 
> nodatacow), then an fallocate of 8 MiB will increase the file size by 8 
> MiB and write that out.  So far so good as at that point the 8 MiB should 
> be a single extent.  But then, data gets written into 4 KiB blocks of 
> that 8 MiB one at a time, and because btrfs is COW, the new data in the 
> block must be written to a new location.
> 
> Which effectively means that by the time the 8 MiB is filled, each 4 KiB 
> block has been rewritten to a new location and is now an extent unto 
> itself.  So now that 8 MiB is composed of 2048 new extents, each one a 
> single 4 KiB block in size.

I always thought that the whole point of fallocate is that it *doesn´t* write 
out anything, but just reserves the space. Thus I don´t see how COW can have 
any adverse effect here.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
