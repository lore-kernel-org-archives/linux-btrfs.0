Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from csamuel.org ([74.50.50.137]:56902 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933638Ab3HJNia (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Aug 2013 09:38:30 -0400
Received: from localhost (localhost [127.0.0.1])
	by csamuel.org (Postfix) with ESMTP id 4812040C14
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Aug 2013 23:38:30 +1000 (EST)
Received: from csamuel.org ([127.0.0.1])
 by localhost (csamuel.org [127.0.0.1]) (amavisd-maia, port 10024) with LMTP
 id 29890-01 for <linux-btrfs@vger.kernel.org>;
 Sat, 10 Aug 2013 23:38:30 +1000 (EST)
Received: from quad.localnet (ppp59-167-127-196.static.internode.on.net [59.167.127.196])
	by csamuel.org (Postfix) with ESMTPSA id DA62140C13
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Aug 2013 23:38:29 +1000 (EST)
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: error count
Date: Sat, 10 Aug 2013 23:38:24 +1000
Message-ID: <3489125.eqS4SDnS3P@quad>
In-Reply-To: <201308101919.27987.russell@coker.com.au>
References: <201308042142.12310.russell@coker.com.au> <10123682.SXiMQfqCrF@quad> <201308101919.27987.russell@coker.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart10050053.7nsZvrh29A"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--nextPart10050053.7nsZvrh29A
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Sat, 10 Aug 2013 07:19:27 PM Russell Coker wrote:

> But what does generation_errs mean?  I'm seeing some on one system.  
> Should I be concerned?  If I write a Nagios check which ones should be 
> warnings and which ones errors?

All I know is that ioctl.h says:

BTRFS_DEV_STAT_GENERATION_ERRS, /* an indication that blocks have not
                                                           * been written */

Looking at the kernel code that only seems to get incremented during a scrub.  
The code that does that says:

                } else if (generation != le64_to_cpu(h->generation)) {
                        sblock->header_error = 1;
                        sblock->generation_error = 1;
                }

The generation there is from the btrfs inode structure, the header says:

        /* full 64 bit generation number, struct vfs_inode doesn't have a big
         * enough field for this.
         */
        u64 generation;


The wiki says:

https://btrfs.wiki.kernel.org/index.php/Glossary

# generation 
#   An internal counter which updates for each transaction. When a
# metadata block is written (using copy on write), current generation
# is stored in the block, so that blocks which are too new (and hence
# possibly inconsistent) can be identified.

and:

https://btrfs.wiki.kernel.org/index.php/Btrfs_design

# Everything that points to a btree block also stores the generation
# field it expects that block to have. This allows Btrfs to detect
# phantom or misplaced writes on the media.

HTH!

> Also why does it give the following errors about trying to open /dev/sr0
> when  using a BTRFS RAID-1 filesystem?  Below is for a RAID-1 over /dev/sdb
> and /dev/sdc.

I don't get that here, I'm building btrfs-progs from git at commit 
194aa4a1bd6447bb545286d0bcb0b0be8204d79f (July 5th), aka:

btrfs-progs$ git describe --tags
v0.20-rc1-358-g194aa4a

cheers!
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
For more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart10050053.7nsZvrh29A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEVAwUAUgZCUI1yjaOTJg85AQIs3ggAre2w2mNnd7hBlGZmx65KG6LrrLVpBYuE
PXuuxW9tJw4OjBrB/xwRGQRDF3GWJE47NycUkfam/YXPGQdsg6x//tQtn+f+FBEh
T26uTX73MZmyl1jayYAxG7AZ3sYzYLJKgkkR4S65TFv/DqQOxYUIHWOJd2X7/IJx
NSpN9MITJ0KbgPj+nWUaNZAIIqCw4bQ/o0FUIbgxzXXpvEvZlRh16YpE36TUZIQ7
OgG5rlbbamc4jw4VFJBxiLd999SGb8rse8tifCRJ2R29EynnY8X0zI6wLywkRo8b
ekAMJ3BS4DOi4QnJmQyIXyacpN0IGGl+8Xpc/GJsxPUxtJzxRF8xpg==
=0S71
-----END PGP SIGNATURE-----

--nextPart10050053.7nsZvrh29A--

