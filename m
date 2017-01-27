Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36761 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932544AbdA0L3p (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Jan 2017 06:29:45 -0500
Received: by mail-wm0-f50.google.com with SMTP id c85so112413378wmi.1
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Jan 2017 03:29:39 -0800 (PST)
Subject: Re: btrfs recovery
References: <961e2f81-40e6-cced-f14a-7af7effe1e5e@googlemail.com>
 <20170126092559.GD24076@carfax.org.uk>
 <24f6cfb2-d008-af12-ad94-4a4da1be1ee2@googlemail.com>
 <9c38e493-e4aa-a718-c6a8-d400bcff0df8@googlemail.com>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org
From: Oliver Freyermuth <o.freyermuth@googlemail.com>
Message-ID: <2c02d0b6-859d-f66f-e259-748db131d38d@googlemail.com>
Date: Fri, 27 Jan 2017 12:01:43 +0100
MIME-Version: 1.0
In-Reply-To: <9c38e493-e4aa-a718-c6a8-d400bcff0df8@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I'm also running 'memtester 12G' right now, which at least tests 2/3 of the memory. I'll leave that running for a day or so, but of course it will not provide a clear answer... 

A small update: while the online memtester is without any errors still, I checked old syslogs from the machine and found something intriguing. 
Jan 16 10:03:11 xxx kernel: Corrupted low memory at ffff880000009000 (9000 phys) = 00098d39
Jan 16 10:18:33 xxx kernel: Corrupted low memory at ffff880000009000 (9000 phys) = 00099795
Jan 16 17:35:48 xxx kernel: Corrupted low memory at ffff880000009000 (9000 phys) = 000dd64e
This seems to be consistently happening from time to time (I have low memory corruption checking compiled in). 
The numbers always consistently increase, and after a reboot, start fresh from a small number again. 

I suppose this is a BIOS bug and it's storing some counter in low memory. I am unsure whether this could have triggered the BTRFS corruption, 
nor do I know what to do about it (are there kernel quirks for that?). 
The vendor does not provide any updates, as usual. 

If someone could confirm whether this might cause corruption for btrfs (and maybe direct me to the correct place to ask for a kernel quirk for this device - do I ask on MM, or somewhere else?), that would be much appreciated. 

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
Additionally, I found that "btrfs restore" works on this broken FS. I will take an external backup of the content within the next 24 hours using that, then I am ready to try anything you suggeest. 

Cheers and thanks!
	Oliver
