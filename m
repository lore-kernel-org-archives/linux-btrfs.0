Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42480 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750960Ab3LJXkn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 18:40:43 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com>
Date: Tue, 10 Dec 2013 16:40:40 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com> <01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com> <CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com>
To: Imran Geriskovan <imran.geriskovan@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 10, 2013, at 4:33 PM, Imran Geriskovan <imran.geriskovan@gmail.com> wrote:

>>> Currently, if you want to protect your data against bit-rot on
>>> a single device you must have 2 btrfs partitions and mount
>>> them as Raid1.
> 
>> No this also works:
>> mkfs.btrfs -d dup -m dup -M <device>
> 
> Thanks a lot.
> 
> I guess docs need an update:
> 
> https://btrfs.wiki.kernel.org/index.php/Mkfs.btrfs:
> "-d": Data profile, values like metadata. EXCEPT DUP CANNOT BE USED
> 
> man mkfs.btrfs (btrfs-tools 0.19+20130705)
> -d, --data type
>              Specify  how  the data must be spanned across
>              the devices specified. Valid values are raid0, raid1,
>              raid5,  raid6,  raid10  or single.

Current btrfs-progs is v3.12. 0.19 is a bit old. But yes, looks like the wiki also needs updating. 

Anyway I just tried it on an 8GB stick and it works, but -M (mixed data+metadata) is required, which documentation also says incurs a performance hit, although I'm uncertain of the significance.


Chris Murphy