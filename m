Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:34544 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3EAIAU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 May 2013 04:00:20 -0400
Date: Wed, 1 May 2013 09:00:19 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Best Practice - Partition, or not?
Message-ID: <20130501080018.GH8274@carfax.org.uk>
References: <loom.20130501T094600-451@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SUk9VBj82R8Xhb8H"
In-Reply-To: <loom.20130501T094600-451@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--SUk9VBj82R8Xhb8H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 01, 2013 at 07:51:12AM +0000, Alexander Skwar wrote:
> Hello
> 
> If I want to manage a complete disk with btrfs, what's the "Best Practice"? 
> Would it be best to create the btrfs filesystem on "/dev/sdb", or would it be 
> better to create just one partition from start to end and then do "mkfs.btrfs 
> /dev/sdb1"?

   I use full unpartitioned disks for my big array (8 devices, 9TB).

> Would the same recomendation hold true, if we're talking about huge disks, 
> like 4TB or so?

   Probably more so. DOS/MBR partitions have a size limit (although I
must confess I don't know what it is these days). You could partition
with GPT in that instance, but probably better to just use the full
device.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
                 --- emacs: Eats Memory and Crashes. ---                 

--SUk9VBj82R8Xhb8H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUYDLklheFHXiqx3kAQJ5FQ//UwoVHz3HbVX8v8Qiv3QHnuFlTzUtJ5kt
AWj3p5oAeuldZZZFJ84t7qYMOCH0f2xl5tLG9dkBhf1jJrlgWPjkMuxVUrJtE9MT
Cpi70uMJC4X1N1U3RmqYN5Hj3uhDt6yS6FyPIw/+IiX8a50M5vhAaj+ri47mHoko
MOpuuDTJmDoDVfbKRtZ0kylQ4JBCSlND+FyMm1Z+Kay6be0OiqeHoo/Os7OQ/znP
/zjdKaYweG4ELd57kliFE/XEgzBZyZ+LysPv2Dxlhr6KIX0mFAOw8RmLIo4jU08b
PQ4/HqpCQgHKVcg6oMuLy0CFltz290iTYYXO4nLk05+11YjVdF8Ch3a7w7n83xvH
KBQxDh1uggjDt8WQUfw9nWgic7NhgiCSlqT1LOcFr3zLBzivYqS+4haOUlWyPsh5
3gw4I2U8gyrlog6RvjqRMKYqkGJdklC+OtMRXtHtNX6X1VRnRmBpNqaSbEJlmvn0
u63CBYCA0NmjD7ikWulHWiLJ1Tu14Ow3TLDUS3xN+usLfz3mRieMGOW3KHb1dWe4
BKWCOolduCe2cizkh12+TFuooeHz0q3phcOrnWeKoUiZlh2zlAf84XYGfR8MLPBi
KZ3doMpuZjULthKWI5aDOl9yPpzEHAZ+Rf6SB61uRjWXaluU2jSaVUgBL1N1WcmC
VINn6GXQm5A=
=GEoS
-----END PGP SIGNATURE-----

--SUk9VBj82R8Xhb8H--
