Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36632 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751947AbdA1VEL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 28 Jan 2017 16:04:11 -0500
Received: by mail-wm0-f42.google.com with SMTP id c85so162570793wmi.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Jan 2017 13:04:08 -0800 (PST)
Subject: Re: btrfs recovery
References: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
 <20170126092559.GD24076@carfax.org.uk>
 <24f6cfb2-d008-af12-ad94-4a4da1be1ee2@googlemail.com>
 <9c38e493-e4aa-a718-c6a8-d400bcff0df8@googlemail.com>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <3255da6a-c4a6-c464-7bc7-56fcff281937@googlemail.com>
Date: Sat, 28 Jan 2017 22:04:06 +0100
MIME-Version: 1.0
In-Reply-To: <9c38e493-e4aa-a718-c6a8-d400bcff0df8@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 26.01.2017 um 12:01 schrieb Oliver Freyermuth:
>Am 26.01.2017 um 11:00 schrieb Hugo Mills:
>>    We can probably talk you through fixing this by hand with a decent
>> hex editor. I've done it before...
>>
> That would be nice! Is it fine via the mailing list? 
> Potentially, the instructions could be helpful for future reference, and "real" IRC is not accessible from my current location. 
> 
> Do you have suggestions for a decent hexeditor for this job? Until now, I have been mainly using emacs, 
> classic hexedit (http://rigaux.org/hexedit.html), or okteta (beware, it's graphical!), but of course these were made for a few MiB of files and are not so well suited for a block device. 
> 
> The first thing to do would then probably just be to jump to the offset where 0xd89500014da12000 is written (can I get that via inspect-internal, or do I have to search for it?), fix that to read 
> 0x00a800014da12000
> (if I understood correctly) and then probably adapt a checksum? 
>
My external backup via btrfs-restore is now done successfully, so I am ready for anything you throw at me. 
Since I was able to pull all data, though, it would mainly be something educational (for me, and likely other list readers). 
If you think that this manual procedure is not worth it, I can also just scratch and recreate the FS. 

Cheers, 
	Oliver
