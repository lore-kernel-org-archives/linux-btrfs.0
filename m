Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:44733 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750741AbdHQIEs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 04:04:48 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1diFnC-0004qF-Bi
        for linux-btrfs@vger.kernel.org; Thu, 17 Aug 2017 10:04:38 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: qcow2 images make scrub believe the filesystem is corrupted.
Date: Thu, 17 Aug 2017 08:04:27 +0000 (UTC)
Message-ID: <pan$b0a14$8f1e0555$f8f395d6$3ede559@cox.net>
References: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
        <CAJCQCtQPMNnC4wHfubV1aHstdUnZXQoRMuss85=_ZAv51qFpSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Wed, 16 Aug 2017 17:32:36 -0600 as excerpted:


> On Tue, Aug 15, 2017 at 7:12 PM, Paulo Dias
> <paulo.miguel.dias@gmail.com> wrote:
> Device Model:     Samsung SSD 850 EVO M.2 500GB Serial Number:   
> S33DNX0H812686V LU WWN Device Id: 5 002538 d4130d027 Firmware Version:
> EMT21B6Q
>>>>
>>>>
> Unfortunately no firmware updates listed with Samsung for this model.
> It's worth filing a bug report with them, and then try not using either
> fstrim or discard for a while and see if the problem reoccurs.
> If not, then that suggests trim bug in the firmware. If it does still
> occur it could just be defective hardware.

Heh, may not be worth filing a bug after all, unless they've changed 
policy recently.

Google samsung ssds queued trim.  They had a bad firmware that was 
/supposed/ to support the new ATA standard with queued-trim/discard, but 
apparently it simply didn't (and there remains an open question as to 
whether the hardware can actually support it at all).  The MS side of 
things worked just fine with the firmware... because apparently no MS 
Windows supported queued-trim yet.  But Linux users had all sorts of 
problems, and...

*** Samsung support *refused* to support Linux on the devices, saying it 
was because "anyone" could change the code! ***

They repeatedly told a number of people the same thing, refusing Linux 
support.  One of the kernel block/ATA subsystem folks finally got them to 
investigate and eventually update the firmware to turn off queued-trim 
again, by omitting any reference to Linux, instead saying he was 
developing a new SATA chipset and was having trouble verifying queued-
trim on Samsung ssds.

Meanwhile, on the kernel side, *all* samsung ssds now have queued-trim 
blacklisted.  (OTOH, while there has been so much trouble with devices 
lying about flush and returning before it's actually done in ordered to 
enhance their performance scores, Samsung devices are among the few 
actually whitelisted for reliable flushing, so it's not /all/ bad news.)


The point being, as I said, unless Samsung's changed policy recently, 
there's no point in filing Linux related bug reports with them.  All 
you're likely to get is them putting their fingers in their ears while 
singing loudly about not supporting Linux.

Unfortunately, I found all this out /after/ having bought a pair of 1 TB 
Samsung evo 850s myself (after seeing them recommended here...), while 
googling, as suggested above, samsung ssd queued trim (tho I actually put 
in evo 850 since that's what I had), in ordered to see if I could safely 
mount with discard and not have it hurt performance due to lack of queued-
trim support.  Obviously not, so I'm running without discard, and letting 
the systemd fstrim timer do its thing every week, instead.

Tho to be fair I've had no problems with them... if only because I'm not 
trying to mount with discard, and the kernel blacklisting would turn of 
queued-trim if I did try it (tho I don't believe my firmware's actually 
one of the lying ones anyway, it doesn't claim support of whatever ATA 
revision made support mandatory, as the lying firmware apparently did).

But I'd have been rather unlikely to buy samsung if I knew they /refused/ 
to support Linux users because "anyone" can modify the code, that's for 
sure!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

