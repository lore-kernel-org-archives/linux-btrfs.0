Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:36441 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518AbbEWMuA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 May 2015 08:50:00 -0400
Received: by wgbgq6 with SMTP id gq6so39046349wgb.3
        for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2015 05:49:58 -0700 (PDT)
Received: from Arch-1 (p3E9EE9FB.dip0.t-ipconnect.de. [62.158.233.251])
        by mx.google.com with ESMTPSA id v3sm2861488wiz.14.2015.05.23.05.49.57
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 May 2015 05:49:57 -0700 (PDT)
From: Philip Seeger <p0h0i0l0i0p@gmail.com>
Message-ID: <1432385390.4187.15.camel@googlemail.com>
Subject: Re: Got 10 csum errors according to dmesg but 0 errors according to
 dev stats
To: linux-btrfs@vger.kernel.org
Date: Sat, 23 May 2015 14:49:50 +0200
In-Reply-To: <pan$f32b4$a31b2df$ac4903ed$b7bd68b4@cox.net>
References: <554F6D43.2060806@googlemail.com>
	 <554F7232.9080804@googlemail.com> <5557F490.5000606@googlemail.com>
	 <pan$f32b4$a31b2df$ac4903ed$b7bd68b4@cox.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2015-05-17 at 08:19 +0000, Duncan wrote:
> 
> I can't answer the corruption bit, but answering the df metadata 
> question...
> 
> Normally, btrfs on a single device defaults to dup metadata type, 
> single 
> data type.  The one /normal/ exception to that is when mkfs.btrfs 
> detects 
> an ssd, where it defaults to single data due to ssd firmware often 
> canceling out the intended redundancy of dup anyway.[1]
> 
> However, conversion from ext* is a bit of a different ball game, and 
> while it /should/ default to dup metadata as well, on 4.0 and into 
> 4.1-rcs 
> as a proper fix hasn't been posted, there's a balance-conversion bug 
> that's keeping type conversion from occurring, both in the normal 
> btrfs 
> balance convert case and in the ext* conversion case.  Thus, ext* 
> conversions remain metadata-single mode and cannot be converted to 
> metadata-dup until this bug is fixed.
> 

Thanks for the detailed explanation. I might take a look at the commit
you're referring to when I have some more time. For now, I simply used
an older live system (3.16) to balance the filesystem (btrfs balance
start), which worked. Before that, I deleted the corrupted files.

Arch after balance:
# btrfs fi df /
Data, single: total=25.72GiB, used=19.47GiB
System, DUP: total=32.00MiB, used=12.00KiB
Metadata, DUP: total=1.25GiB, used=742.27MiB
GlobalReserve, single: total=248.00MiB, used=0.00B

I have copied my files back (that were corrupted in this vm) and this
system is working fine now, no more corruption (so far). It seems the
balance has fixed it.

Is this a known side effect, that files could get corrupted if no
balance is run (not counting the balance with 4.0 which doesn't work
due to that commit) after an ext4 conversion?



-- 
Philip

