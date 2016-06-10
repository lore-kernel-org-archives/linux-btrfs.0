Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aarghimedes.fi ([62.75.165.48]:37169 "EHLO aarghimedes.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbcFJS42 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 14:56:28 -0400
Received: from [192.168.2.120] (79-134-100-39.cust.suomicom.net [79.134.100.39])
	by aarghimedes.fi (Postfix) with ESMTPSA id C9C0C63C559D
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 21:56:22 +0300 (EEST)
Subject: Re: Replacing drives with larger ones in a 4 drive raid1
To: linux-btrfs@vger.kernel.org
References: <022F65B5-228D-4EEF-95C9-3C269B63B290@bueechi.net>
 <pan$6ab4$792ded48$cf23daab$a8e4c2@cox.net>
From: Jukka Larja <roskakori@aarghimedes.fi>
Message-ID: <575B0D5B.8040601@aarghimedes.fi>
Date: Fri, 10 Jun 2016 21:56:27 +0300
MIME-Version: 1.0
In-Reply-To: <pan$6ab4$792ded48$cf23daab$a8e4c2@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is somewhat off topic but...

9.6.2016, 18.20, Duncan kirjoitti:

> Are those the 8 TB SMR "archive" drives?
>
> I haven't been following the issue very closely, but be aware that there
> were serious issues with those drives a few kernels back, and that while
> those issues are now fixed, the drives themselves operate rather
> differently than normal drives, and simply don't work well in normal
> usage.

Either the issues were not fixed or LSI Logic / Symbios Logic SAS3008 is 
incompatible with the drives (and an older model of theirs, which I don't 
have anymore) as well as Intel Corporation 8 Series/C220 Series Chipset 
Family 6-port SATA Controller 1 [AHCI mode] (rev 05).

I haven't been able to get the disks to fail with any other load but Btrfs. 
However, with that they fail spectacularly. They drop out and make enough 
mess to corrupt things beyond repair. (See 
https://www.spinics.net/lists/linux-btrfs/msg55218.html for more info.)

There's a slight change that I missed some relevant kernel update. When I 
get new disks and can get the array fixed (it still only mounts read-only), 
I'll do some testing with the SMR drives. If they work, that's great, but at 
the moment I wouldn't buy them for Btrfs use even if the workload or 
environmental characteristics wouldn't be a problem.

-- 
      ...Elämälle vierasta toimintaa...
     Jukka Larja, Roskakori@aarghimedes.fi

"Are we feeling better then?"
"I'm naming all the stars."
"You can't see the stars, love. That's the ceiling. Also, it's day."
"I can see them. But I've named them all the same name, and there's terrible 
confusion..."
- Spike & Drusilla, Buffy the Vampire Slayer -

