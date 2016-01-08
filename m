Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:33486 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbcAHPBo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jan 2016 10:01:44 -0500
Received: by mail-io0-f174.google.com with SMTP id q21so288323245iod.0
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jan 2016 07:01:44 -0800 (PST)
Subject: Re: send/receive for encrypted backup purposes
To: Martin Steigerwald <martin@lichtvoll.de>, linux-btrfs@vger.kernel.org
References: <1827847.pVfOzZHEoP@merkaba>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <568FCF45.1060007@gmail.com>
Date: Fri, 8 Jan 2016 10:01:25 -0500
MIME-Version: 1.0
In-Reply-To: <1827847.pVfOzZHEoP@merkaba>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-08 08:44, Martin Steigerwald wrote:
> Hi!
>
> Given that the Omnia Turris router has an mSATA slot and two USB 3 connectors,
> I am pondering the feasibility for using it for backups of my home dir.
>
> I pondered checking out zbackup, attic or obnam for that, of which at least
> zbackup and obnam can do encrypted backups¹²³.
>
> Yet then I thought why not using btrfs send and receive directly? I found two
> answers:
>
> Client doesn´t encrypt. And even tough I think the Omnia will be pretty secure
> unless I configure a hole into it, I´d not feel that comfortable putting my
> whole home directory there unsecured.
>
> So my question is, would it be possible to have btrfs send/receive encrypted?
> So far I have only three ideas about it, the first two are similar:
>
> 1) Mount a dm-crypted loopback file formatted with BTRFS from the router on
> the client. Of course dm-crypt stuff need to happen on the client then. And I
> wonder whether I would loose most of the probably performance benefit of using
> btrfs send/receive this way. I could export the file with nfs for example.
This really depends on what you are using it for, and how it's 
configured.  In the case of the backup side, I wouldn't worry as much 
about performance, as backups are ideally write once, read once 
(assuming you verify them that is), and therefore aren't really 
performance critical.  If you can get the router set up with dm-crypt, 
you could transfer the send stream over SSH (or something similar) and 
avoid some of the networking overhead.
>
> 2) Export a block device from the Omnia directly wie NBD or iSCSI or whatnot
> and use it with dm-crypt on the client.
This is probably your best bet as far as efficiency goes.  In general, 
I'd recommend NBD over iSCSI for this type of thing, as it's a lot more 
lightweight (and thus more efficient in most respects).  If you only 
ever need to access the device locally on the network served by the 
router however, I'd actually suggest ATAoE over iSCSI or NBD, it's a lot 
more efficient and technically more secure because it's non-routable (it 
runs directly over the link layer, which means you avoid the overhead of 
IP and TCP, and has the added advantage that you technically don't need 
anything but the kernel driver on the client side).
>
> 3) Have all home directories crypted via ecryptfs and only send/receive the
> subvolumes with the ecryptfs files.
This would work, but has the potential to be highly error prone, and 
likely very inefficient (at least, as compared to either of the above 
options).  There's also small amounts of metadata that get inherently 
leaked by using in-line encryption at the VFS layer (the impact of this 
is small for most people, but should still be considered).
>
>
> Any other ideas?
>
>
> Something like this would also be nice to have to store on cloud storage.
> Something along the line to send a crypted btrfs send/receive stream. Ideally
> target could be a directory on some storage that doesn´t even need to be a
> BTRFS. But I bet that would be a lot of work to implement.
>
This actually isn't all that hard to do.  The send stream can be stored 
just fine as a flat file on your target system, and thus can easily be 
compressed and/or encrypted.  This is actually what I used to do before 
I realized that incremental backups were saving me absolutely no time, 
and almost no space.  (I've actually switched to using SquashFS for 
backup storage, as it's space efficient, and has the added advantage 
that I can directly boot my backups to use as a recovery environment).

There's not anything I know of that actually does this, but it wouldn't 
be hard to write software to automate it.  Keep in mind that storing 
data that way is less efficient than receiving the stream directly onto 
another FS, but I doubt that that will have much practical impact, and 
you can mitigate this by being selective about what you back up.

