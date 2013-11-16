Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:54006 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752984Ab3KPVuF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 16:50:05 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:52054 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1Vhnkg-003ZEu-Ai
	for linux-btrfs@vger.kernel.org; Sat, 16 Nov 2013 14:50:02 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs fi show
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$daf92$6b3b3c71$c97cb6b7$f9d238aa@cox.net>
Date: Sat, 16 Nov 2013 14:50:00 -0700
Message-Id: <74A706D5-8983-43D3-A21A-5C577E4ED695@colorremedies.com>
References: <528787FB.4040100@czarc.net> <8A471BDA-8355-4267-BA6F-44046F6422BD@colorremedies.com> <pan$daf92$6b3b3c71$c97cb6b7$f9d238aa@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 16, 2013, at 1:33 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> Meanwhile, in plain English based on my observation here, the new 
> behavior works like this:
> 
> 1) If you run a generic btrfs filesystem show (without options or path), 
> you *WILL* likely get the same base filesystem listed multiple times, as 
> the default lookup appears to get the info from at least two different 
> places, one appearing right away that only appears to include currently 
> mounted filesystems, then a pause, then a more complete listing that 
> includes currently unmounted btrfs volumes as well.

Thanks for the explanation. I'm still considering it a bug though. Duplicates of the same UUID should be filtered out.

In my case, there's no pause. Two identical listings are instantly produced for one btrfs volume.

> 
> 3) If you use -d, you'll get a different list, based on devices in /dev 
> so it includes unmounted filesystems (and thus the pause), but at least 
> here, this list is BOTH comprehensive AND avoids dups!

This does show me a single instance of the singular volume I have.


Chris Murphy

