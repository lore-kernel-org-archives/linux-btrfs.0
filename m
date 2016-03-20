Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36692 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbcCTUjj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 16:39:39 -0400
Received: by mail-ig0-f174.google.com with SMTP id nk17so58402113igb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Mar 2016 13:39:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <trinity-c626d556-a9b3-4f61-b648-b95b2a2d08d9-1458502296153@3capp-gmx-bs09>
References: <trinity-c626d556-a9b3-4f61-b648-b95b2a2d08d9-1458502296153@3capp-gmx-bs09>
Date: Sun, 20 Mar 2016 14:39:38 -0600
Message-ID: <CAJCQCtTtOG9E2BiwaY4d4L1sgMQPumehLuecNApQhMff_2cTog@mail.gmail.com>
Subject: Re: Re: unable to mount btrfs partition, please help :(
From: Chris Murphy <lists@colorremedies.com>
To: Patrick Tschackert <Killing-Time@gmx.de>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 20, 2016 at 1:31 PM, Patrick Tschackert <Killing-Time@gmx.de> wrote:
> My raid is done with the scrub now, this is what i get:
>
> $ cat /sys/block/md0/md/mismatch_cnt
> 311936608

I think this is an assembly problem. Read errors don't result in
mismatch counts. An md mismatch count happens when there's a mismatch
between data strip and parity strip(s). So this is a lot of
mismatches.

I think you need to take this problem to the linux-raid@ list, I don't
think anyone on this list is going to be able to help with this
portion of the problem. I'm only semi-literate with this, and you need
to find out why there are so many mismatches and confirm whether the
array is being assembled correctly.

In your writeup for the list you can include the URL for the first
post to this list. I wouldn't repeat any of the VM crashing stuff
because it's not really relevant. You'll need to include the kernel
you were using at the time of the problem, the kernel you're using for
the scrub, the version of mdadm, and all the device metadata (-E for
each device) and the array (-D), and smartctl -A for each device (you
could put smartctl -x for each drive into a file and the put the file
up somewhere like dropbox or google drive, or individually pastebin
them if you can keep it all separate, -x is really verbose but
sometimes contains read error information) to show bad sectors.


The summary line is basically: this was working, after a VM crash
followed by shutdown -r now, the Btrfs filesystem won't mount. A drive
was faulty and rebuilt with a spare. You just did a check scrub and
have all these errors in mismatch_cnt. The question is: how to confirm
the array is properly assembled? Because that's too many errors, and
the file system on that array will not mount. Further complicating
matters is even after rebuild you have another drive that has some
read errors. Those weren't being fixed this whole time (during rebuild
for example) likely because of the timeout vs SCT ERC
misconfiguration, other wise they would have been fixed.


>
> I also attached my dmesg output to this mail. Here's an excerpt:
> [12235.372901] sd 7:0:0:0: [sdh] tag#15 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [12235.372906] sd 7:0:0:0: [sdh] tag#15 Sense Key : Medium Error [current] [descriptor]
> [12235.372909] sd 7:0:0:0: [sdh] tag#15 Add. Sense: Unrecovered read error - auto reallocate failed
> [12235.372913] sd 7:0:0:0: [sdh] tag#15 CDB: Read(16) 88 00 00 00 00 00 af b2 bb 48 00 00 05 40 00 00
> [12235.372916] blk_update_request: I/O error, dev sdh, sector 2947727304
> [12235.372941] ata8: EH complete
> [12266.856747] ata8.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 action 0x0
> [12266.856753] ata8.00: irq_stat 0x40000008
> [12266.856756] ata8.00: failed command: READ FPDMA QUEUED
> [12266.856762] ata8.00: cmd 60/40:d8:08:17:b5/05:00:af:00:00/40 tag 27 ncq 688128 in
>          res 41/40:00:18:1b:b5/00:00:af:00:00/40 Emask 0x409 (media error) <F>
> [12266.856765] ata8.00: status: { DRDY ERR }
> [12266.856767] ata8.00: error: { UNC }
> [12266.858112] ata8.00: configured for UDMA/133

What do you get for
smartctl -x /dev/sdh


I see this too:
[11440.088441] ata8.00: status: { DRDY }
[11440.088443] ata8.00: failed command: READ FPDMA QUEUED
[11440.088447] ata8.00: cmd 60/40:c8:e8:bc:15/05:00:ab:00:00/40 tag 25
ncq 688128 in
         res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x1 (device error)

That's weird. You have several other identical model drives, so I
doubt this is some sort of NCQ incompatibility with this model drive,
no other drive is complaining like this. So I wonder if there's just
something wrong with this drive aside from the bad sectors (?) I can't
really tell but it's suspicious.



> If I understand correctly, my /dev/sdh drive is having trouble.
> Could this be the problem? Should I set the drive to failed and rebuild on a spare disk?

You need to really slow down and understand the problem first. Every
data loss case I've ever come across with md/mdadm raid6 was user
induced because they changed too much stuff too fast without
consulting people who know better. They got impatient. So I suggest
going to the linux-raid@ list and asking there what's going on. The
less you change the better because most of the changes md/mdadm does
are irreversible.


-- 
Chris Murphy
