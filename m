Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay5.ptmail.sapo.pt ([212.55.154.25]:46050 "EHLO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751789AbcFZNGS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 09:06:18 -0400
Message-ID: <1466946315.4049.19.camel@sapo.pt>
Subject: Re: Bad hard drive - checksum verify failure forces readonly mount
From: Vasco Almeida <vascomalmeida@sapo.pt>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Sun, 26 Jun 2016 13:05:15 +0000
In-Reply-To: <CAJCQCtQ+q90r=Q38mtVKoBeAmXmPJPP2cp=dfLj3kBiEv66bzA@mail.gmail.com>
References: <loom.20160623T205347-371@post.gmane.org>
	 <CAJCQCtRO+FYrsfHF_ARSnPfoS7uzvLR4hB1V-TJ_YN4NcA6srw@mail.gmail.com>
 <5356822.A3RRKHDHNy@linux-omuo>
	 <CAJCQCtQ-xYrERT5R4gSC1C7OkoeP2LeS9W9UL5VY5SmDBXk71w@mail.gmail.com>
 <20160625010610.Horde.tUycS31CmgVWfy3CPu7qJCD@mail.sapo.pt>
 <CAJCQCtSGZO8JVXqVOwifT84KTLCkciux+Y6A_na4AA-PxPjjbw@mail.gmail.com>
	 <20160625211024.Horde.pL6RMZNJL6tnjtpglBZjDaB@mail.sapo.pt>
	 <CAJCQCtQ+q90r=Q38mtVKoBeAmXmPJPP2cp=dfLj3kBiEv66bzA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

A Sáb, 25-06-2016 às 14:54 -0600, Chris Murphy escreveu:
> On Sat, Jun 25, 2016 at 2:10 PM, Vasco Almeida <vascomalmeida@sapo.pt
> > wrote:
> > Citando Chris Murphy <lists@colorremedies.com>:
> > > 3. btrfs-image so that devs can see what's causing the problem
> > > that
> > > the current code isn't handling well enough.
> > 
> > 
> > btrfs-image does not create dump image:
> > 
> > # btrfs-image /dev/mapper/vg_pupu-lv_opensuse_root
> > btrfs-lv_opensuse_root.image
> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> > Csum didn't match
> > Error reading metadata block
> > Error adding block -5
> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
> > Csum didn't match
> > Error reading metadata block
> > Error flushing pending -5
> > create failed (Success)
> > # echo $?
> > 1
> 
> Well it's pretty strange to have DUP metadata and for the checksum
> verify to fail on both copies. I don't have much optimism that brfsck
> repair can fix it either. But still it's worth a shot since there's
> not much else to go on.

I have tried "btrfs check --repair /device" but that seems do not do
any good.
http://paste.fedoraproject.org/384960/66945936/

I then issued "mount /device /mnt" and, like before, it was mounted
readwrite and then forced readonly. Got some kernel oops and traces. 

I noticed that btrfs-balance was using ~100% CPU whilst btrfs device
was mounted readonly. I let it run for about 20 minutes.
Then had to reboot because the system was no responding well: was
unable to open or close applications, use internet. Did SysRq+reisu
(operations were enabled) and then pressed reset button on computer.

Unfortunately dmesg dumps were lost after resetting computer.

What else can I do or I must rebuild the file system?
