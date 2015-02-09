Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35521 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932799AbbBIU2G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:28:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YKuw8-0008Tr-Sj
	for linux-btrfs@vger.kernel.org; Mon, 09 Feb 2015 21:28:04 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 21:28:04 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Feb 2015 21:28:04 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs features
Date: Mon, 09 Feb 2015 21:08:51 +0100
Message-ID: <jngnqb-34a.ln1@hurikhan77.spdns.de>
References: <CAGwxe4hr=6WW=-JuqbitNZTHE9HV-G4=Q6RYh03mh2iLN6Qtzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tobias Holst <tobby@tobby.eu> schrieb:

> Hi
> 
> I am just looking at the features enabled on my btrfs volume.
>> ls /sys/fs/btrfs/[UUID]/features/
> shows the following output:
>> big_metadata  compress_lzo  extended_iref  mixed_backref  raid56
> 
> So "big_metadata" means I am not using "skinny-metadata",

No, both can be enabled at the same time. "big_metadata" means you are using 
the new default 16k nodesize vs the old default 4k nodesize. I have two 
btrfs, the main one created early and missing "big_metadata" (it can only be 
enabled at fs-creation time) and my backup volume which was recreated later 
from scratch. Both are having "skinny_extents", tho.

> "compress_lzo" means I am using compression. "raid56" means I am using
> the experimental RAID-features of btrfs.

Yep.

> But the other two flags are a little bit unclear... I think "extended
> _iref" is the "extref" feature of mkfs.btrfs - right?

Probably yes. Here's a list you can check against:

https://btrfs.wiki.kernel.org/index.php/Changelog

> I am not sure about the "mixed_backref" feature. What does it mean? Is
> this the "mixed-bg"-feature of mkfs.btrfs?

I have this, too. But I think, mixed-bg (mixed block groups, default on very 
small devices) is different because I certainly don't use that but still 
have "mixed_backref". So, I cannot say what it is except that it is not the 
same.

> Also I try to change these features. I am missing the skinny extends,
> this can be enabled by "btrfstune -x [one device of my raid]",
> correct?

Yep. Ensure running a capable kernel and use it on the unmounted device. 
I've done that in the past and it works.

> And how can I enable the missing "no-holes"-feature on my volume?

Didn't know of that yet, I'd be interested, too. ;-)

> Regards,
> Tobias

Here's some additional info explaining the purpose of various features and 
defaults:
https://btrfs.wiki.kernel.org/index.php/FAQ

-- 
Replies to list only preferred.

