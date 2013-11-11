Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39651 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824Ab3KKX6j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Nov 2013 18:58:39 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vg1NN-0002Nb-Ew
	for linux-btrfs@vger.kernel.org; Tue, 12 Nov 2013 00:58:37 +0100
Received: from dyndsl-085-016-236-031.ewe-ip-backbone.de ([85.16.236.31])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 00:58:37 +0100
Received: from hurikhan77+btrfs by dyndsl-085-016-236-031.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 00:58:37 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: btrfsck errors is it save to fix?
Date: Tue, 12 Nov 2013 00:58:59 +0100
Message-ID: <3j78la-3nn.ln1@hurikhan77.spdns.de>
References: <52742B59.3060405@friedels.name> <CAE5mzvijfSOi9dP0MWCMd6=R5MW3bhabote4QYmFnqNEerDifw@mail.gmail.com> <5274BEC8.5060804@friedels.name> <52780E20.8020405@friedels.name> <CAE5mzvgrKqrv3LpmiF6iUK=GYsnGOQnSwLTM0dSfBE8ZP-4AuA@mail.gmail.com> <5279E581.4000700@friedels.name> <527BE712.40304@friedels.name> <pan$2f107$ddc92f2a$30381770$58497a03@cox.net> <527DF34B.2030309@friedels.name> <52812AAA.1080106@friedels.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hendrik Friedel <hendrik@friedels.name> schrieb:

> I re-post this:
> 
[...]
>> root 256 inode 9579 errors 100
>> root 256 inode 9580 errors 100
>> root 256 inode 14258 errors 100
>> root 256 inode 14259 errors 100
>> root 4444 inode 9579 errors 100
>> root 4444 inode 9580 errors 100
>> root 4444 inode 14258 errors 100
>> root 4444 inode 14259 errors 100
>> found 2895817096773 bytes used err is 1

100 is I_ERR_FILE_EXTENT_DISCOUNT. I'm not sure what kind of problem this 
indicates but btrfsck does not seem to fix this currently - it just detects 
it.

I'm living with errors 400 (I_ERR_FILE_NBYTES_WRONG) and 2000 
(I_ERR_LINK_COUNT_WRONG) and had no problem with that yet. I suppose you can 
simply ignore it for the time being, ensure you have a working backup and 
hope the kernel handles it well when it encounters such "broken" inodes.

And from what I've read in the past btrfs is designed to handle and fix most 
errors on the fly from within the kernel. So it may just "fix" it when such 
an inode is modified. Thus, btrfsck is meant just as a tool to fix errors 
that can't be handled in kernel space. I may be wrong however, experts on 
the list could give a more detailed insight.

BTW, my first impression was that "errors 400" means something like "400 
errors" - but that is just a hex bitmask which shows what errors have been 
found. So "errors 100" is just _one_ bit set, thus only _one_ error.

You can use "btrfs subvolume list" to identify which subvolume 4444 is and 
maybe recreate it or just delete it if it is disposable. The errors should 
be gone then. That won't work for subvolume 256, however, for it being the 
root subvolume obviously.

The last of the quoted errors, by pure guessing, probably indicates a 
problem with the space cache. But I think you already tried discarding it. 
Did you run btrfsck right after discarding it without regenerating the space 
cache? Does it still show that error then?

Regards,
Kai

