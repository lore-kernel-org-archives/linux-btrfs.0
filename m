Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50192 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbaJAXcR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Oct 2014 19:32:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XZTNT-0002gU-4K
	for linux-btrfs@vger.kernel.org; Thu, 02 Oct 2014 01:32:11 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Oct 2014 01:32:11 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Oct 2014 01:32:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs check segfaults after flipping 2 Bytes
Date: Wed, 1 Oct 2014 23:31:59 +0000 (UTC)
Message-ID: <pan$36400$3ee14aa9$ee1e5a94$415ce7b2@cox.net>
References: <542C6443.1010809@niklasfi.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Niklas Fischer posted on Wed, 01 Oct 2014 22:29:55 +0200 as excerpted:

> I was trying to determine how btrfs reacts to disk errors, when I
> discovered, that flipping two Bytes, supposedly inside of a file can
> render the filesystem unusable. Here is what I did:
> 
> 1. dd if=/dev/zero of=/dev/sdg2 bs=1M
> 2. mkfs.btrfs /dev/sdg2
> 3. mount /dev/sdg2 /tmp/btrfs
> 4. echo "hello world this is some text" > /tmp/btrfs/hello
> 5. umount /dev/sdg2

Keep in mind that on btrfs, small enough files will not be written to 
file extents but instead will be written directly into the metadata.

That's a small enough file I guess that's what you were seeing, which 
would explain the two instances of the string, since on a single device 
btrfs, metadata is dup mode by default.

That metadata block would then fail checksum, and an attempt would be 
made to use the second copy, which of course would fail it the same way.

And that being the only file in the filesystem, I'd /guess/ (not being a 
developer myself, just a btrfs testing admin and list regular) that 
metadata block is still the original one, which very likely contains 
critical filesystem information as well, thus explaining the mount 
failure when the block failed checksum verify.

In theory at least, with a less synthetic test case there'd be enough 
more metadata on the filesystem that the affected metadata block would be 
further down the chain, and corrupting it wouldn't corrupt critical 
filesystem information as it wouldn't be in the same block.

That might explain the problem, but I don't know enough about btrfs to 
know how reasonable a solution would be.  I guess a btrfs dev should know.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

