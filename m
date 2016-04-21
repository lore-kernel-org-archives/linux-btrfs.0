Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35578 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbcDUR1r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 13:27:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1atIO6-00081X-BR
	for linux-btrfs@vger.kernel.org; Thu, 21 Apr 2016 19:27:34 +0200
Received: from p50908ea2.dip0.t-ipconnect.de ([80.144.142.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Apr 2016 19:27:34 +0200
Received: from matthias by p50908ea2.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Apr 2016 19:27:34 +0200
To: linux-btrfs@vger.kernel.org
From: Matthias Bodenbinder <matthias@bodenbinder.de>
Subject: Re: Question: raid1 behaviour on failure
Date: Thu, 21 Apr 2016 19:27:23 +0200
Message-ID: <nfb2hr$6i0$1@ger.gmane.org>
References: <nf1q0j$ug4$1@ger.gmane.org> <57148B2E.6010904@cn.fujitsu.com>
 <nf73cv$7vh$1@ger.gmane.org> <571871FC.2010101@jp.fujitsu.com>
 <CAPmG0jZd7AaH+u52_gqBmke-3S=yH_i9Pmk1R=mOFmdnsj6BgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAPmG0jZd7AaH+u52_gqBmke-3S=yH_i9Pmk1R=mOFmdnsj6BgQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 21.04.2016 um 13:28 schrieb Henk Slager:
>> Can anyone explain this behavior?
> 
> All 4 drives (WD20, WD75, WD50, SP2504C) get a disconnect twice in
> this test. What is on WD20 is unclear to me, but the raid1 array is
> {WD75, WD50, SP2504C}
> So the test as described by Matthias is not what actually happens.
> In fact, the whole btrfs fs is 'disconnected on the lower layers of
> the kernel' but there is no unmount.  You can see the scsi items go
> from 8?.0.0.x to
> 9.0.0.x to 10.0.0.x. In the 9.0.0.x state, the tools show then 1 dev
> missing (WD75), but in fact the whole fs state is messed up. So as
> indicated by Anand already, it is a bad test and it is what one can
> expect from an unpatched 4.4.0 kernel. ( I'm curious to know how md
> raidX would handle this ).
> 
> a) My best guess is that the 4 drives are in a USB connected drivebay
> and that Matthias unplugged WD75 (so cut its power and SATA
> connection), did the file copy trial and then plugged in the WD75
> again into the drivebay. The (un)plug of a harddisk is then assumed to
> trigger a USB link re-init by the chipset in the drivebay.
> 
> b) Another possibility is that due to (un)plug of WD75 cause the host
> USB chipset to re-init the USB link due to (too big?) changes in
> electrical current. And likely separate USB cables and maybe some
> SATA.
> 
> c) Or some flaw in the LMDE2 distribution in combination with btrfs. I
> don't what is in the  linux-image-4.4.0-0.bpo.1-amd64
> 

Just to clarify my setup. I HDs are mounted into a FANTEC QB-35US3-6G case. According to the handbook it has "Hot-Plug for  USB / eSATA interface".

It is equipped with 4 HDs. 3 of them are part of the raid1. The fourth HD is a 2 TB device with ext4 filesystem and no relevance for this thread.

Matthias

