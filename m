Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:33653 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753797AbaAaDAi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 22:00:38 -0500
Received: from 70-89-167-59-colorado-co.hfc.comcastbusiness.net ([70.89.167.59]:2169 helo=[10.18.80.7])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W94LN-000cvh-Ar
	for linux-btrfs@vger.kernel.org; Thu, 30 Jan 2014 20:00:37 -0700
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: lost with degraded RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$3f5b6$fcf027de$d8c8fe27$ce2a7e6f@cox.net>
Date: Thu, 30 Jan 2014 20:00:39 -0700
Message-Id: <8FF7CD63-3B07-42CB-88C3-E88D39280892@colorremedies.com>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com> <CABgvyo_Tn-u7Lfo4NPeWyiiSFj2ZFG9MM2z3CAD9f3hjfLM44g@mail.gmail.com> <pan$3f5b6$fcf027de$d8c8fe27$ce2a7e6f@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 30, 2014, at 3:18 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> IOW, I guess I don't agree with that patch as it was apparently 
> committed.  There needs to be a force option as well.

-o degraded is the force option. I think the problem here is that there's sufficient damage to the one remaining device, that it cannot be mounted rw. It's sort of a chicken - egg problem, the single device available has a file system that's sufficiently damaged that it undamaged metadata to get a rw mount. Since there are too few devices for that, it fails to mount rw.

I'm not seeing it as any different from a single device volume with data/metadata profile single, with sufficient damage to cause it to not mount rw. If -o recovery can't fix it, I think it's done for.

So something Johan sent to me but didn't make the list (I've asked him to repost) is that his attempts to mount degraded,recovery,skip_balance, result in a:
/dev/mapper/bunkerA /mnt
mount: wrong fs type, bad option, bad superblock 

He gets other errors also, and he has the results of btrfs check that might be more revealing, but to say the least it looks pretty nasty.

Another question for Johann is what exact balance command was to go back to single? Was there -dconvert and -mconvert? Both are required to go from raid1/raid to single/DUP or single/single, and actually get rid of the 2nd device. And looking at the man page, I'm not sure how we do that conversion and specify which multiple device we're dropping:

[filesystem] balance start [options] <path>

With a missing device, presumably this is obvious, but…



Chris Murphy

