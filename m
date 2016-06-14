Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:44299 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbcFNTzu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 15:55:50 -0400
Date: Tue, 14 Jun 2016 19:55:46 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Andrew Armenia <andrew@asquaredlabs.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: chunk_width_limit mount option
Message-ID: <20160614195546.GN5437@carfax.org.uk>
References: <1464918615-6458-1-git-send-email-andrew@asquaredlabs.com>
 <9d614f8f-f4c6-ac68-bfaa-abc29dd6b1d5@oracle.com>
 <CA+jCKRWL-AmcP9ksZU502BYUGsHpeGbiCFK6L2c2T2HTD80ebA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FUaywKC54iCcLzqT"
In-Reply-To: <CA+jCKRWL-AmcP9ksZU502BYUGsHpeGbiCFK6L2c2T2HTD80ebA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FUaywKC54iCcLzqT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 14, 2016 at 03:44:47PM -0400, Andrew Armenia wrote:
> On Sun, Jun 12, 2016 at 10:06 PM, Anand Jain <anand.jain@oracle.com> wrote:
> >
> >
> > On 06/03/2016 09:50 AM, Andrew Armenia wrote:
> >>
> >> This patch adds mount option 'chunk_width_limit=X', which when set forces
> >> the chunk allocator to use only up to X devices when allocating a chunk.
> >> This may help reduce the seek penalties seen in filesystems with large
> >> numbers of devices.
> >
> >
> > Have you reviewed implementations like device allocation grouping?
> > Some info is in the btrfs project ideas..
> >
> > https://btrfs.wiki.kernel.org/index.php/Project_ideas
> >  Chunk allocation groups
> >  Limits on number of stripes (stripe width)
> >  Linear chunk allocation mode
> >
> > (Device allocation grouping is important for enterprise storage solutions).
> >
> > Thanks, Anand
> 
> I have looked at those ideas; allocation groups are what I'm ideally
> after but I decided to start out small. I just spotted the dev_group
> field in the device tree that appears to be currently unused, so
> perhaps I will look at developing a group-aware allocator instead of
> just limiting the chunk width.

   I made some design notes on a generalised approach for this a while
ago:

http://www.spinics.net/lists/linux-btrfs/msg33782.html
http://www.spinics.net/lists/linux-btrfs/msg33916.html

   Hugo.

-- 
Hugo Mills             | What do we want?
hugo@... carfax.org.uk | Time Travel!
http://carfax.org.uk/  | When do we want it?
PGP: E2AB1DE4          | Irrelevant!                       Terminator: Genisys

--FUaywKC54iCcLzqT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJXYGFCAAoJEFheFHXiqx3kFpoP/3nJdSZY4DnOPiua/syoIKJI
VSJZUHs5u/SVo0vAcLxpnNOVBKVPaGfpBHFg5IAPt6t/oyDsH9YzaAGdq/Q6wjEF
a7JlFJHkxNcD4IlnHatdO40FxQn0HU++aKFj9ETNRbOMLvpClodYOx4ezsEXMHzs
kRE5oMVHc1UAjtlthVt0byVtC1VzYZqaWNA8UWNpPO8fAGOPq6AatoFQVxCviN08
CdZi7trQuANNNv1oGaZb4bXO+9mtGsNksA+Oc9P8R60jmtvGEHYw21jix3y4Fx2q
cHCQeO6HMuE7L7SD9UBUGTl+V8WIjGvInRBjNrgUk8y6eu7/Ctiaqj/jtZjuiclE
r4GEKhbcxCMRz/JXbTU3Z6A7RWJq9gfcMZ4s9yDTxfWYPJM0Rcl7S550SCs3sMtw
jvpRy/tiEMkHYj1TdW7EVBvKVoUivS//llH2V0MUEmUdzUJdmJI/xCfCEmvPKdNe
0ZVfo9euFc1pL2k65b9M8+i4BXAs7xdjuMBt+mtafAE3OTOw2ng+0cMzG+jxGFnh
Ir1/UaDbxe+RFIkRIHqVPx7LwU9i/FBXHS+9oANjpm68CnUAHuFp1/hHFcUacaBv
X9HJjH2jHIxyxb3RsCxt2gPp4/MKw52221DwfCHFYl4dqBcQ6unwQTU8Dy3/wh0w
QF99OJO1G22ocx4C2617
=xNsI
-----END PGP SIGNATURE-----

--FUaywKC54iCcLzqT--
