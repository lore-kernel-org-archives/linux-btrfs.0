Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53218 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbaEGI3s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 04:29:48 -0400
Date: Wed, 7 May 2014 09:29:41 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Marc MERLIN <marc@merlins.org>
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: raid0 vs single, and should we allow -mdup by default on SSDs?
Message-ID: <20140507082941.GA19199@carfax.org.uk>
References: <pan$43f87$1b04f612$26876f7$5d505a6d@cox.net>
 <pan$31100$5edd829$14fe1b2f$4e1f4bd7@cox.net>
 <pan$a6ac4$b6e79aa$56ddd950$5b7b75c2@cox.net>
 <20140507081840.GM10159@merlins.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
In-Reply-To: <20140507081840.GM10159@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 07, 2014 at 01:18:40AM -0700, Marc MERLIN wrote:
> On Tue, May 06, 2014 at 07:39:12PM +0000, Duncan wrote:
> > That appears to be a very good use of either -d raid0 or -d single, yes.  
> > And since you're apparently not streaming such high resolution video that 
> > you NEED the raid0, single does indeed give you a somewhat better chance 
> > at recovery.
>  
> zoneminder saves 'video' as a stream of independent small jpegs, so I'm
> good. Actually come to think of it they're so small that they probably
> all ended up in the raid1 metadata. That also means that I'm not getting
> twice the storage space like I planned to. Oh well...

   There's a mount option to change the threshold at which files are
inlined in metadata: maxinline=<bytes>. You could play with that for
this particular use-case.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- I am but mad north-north-west:  when the wind is southerly, I ---  
                       know a hawk from a handsaw.                       

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU2nu9VheFHXiqx3kAQK08A/+JKnrYrWxHAQ748Ajh0BE51GGCzy4ibJe
2J4nnKznQodvCSq6fPdHbAbvK5J253rMQ7f5b4h/QGjC41kjAQFq9GZWlJvJWSc8
CFpHLySfR8IBu5rHb2vbyC/1AtTdnnXID3RVaJbQ1ZlGt+8ssTBVrA12ffVXxunX
O8leiMl8HGUZzgNSOMYapGnI+2gjnJzHZTibFX+e9QPfD0JgY7spDUmEYPIDv5TW
FEnOdwSyifPULsFktqjN0pGjjxjoqW78mIV/Ez8G5bgXf8PEM9fJq/he1/PFj8QG
U06wY5pOtz6jbdMBl9rgF05Q3P/PNyt4qw/uAa0jB4NqNJ6miJHXEcwYSBIxKeTg
wZJC+R44O4XXMzpX/dzUAmQ7acDtRePU52WfQJGllG0CqpWDQVBaSfiDslzV+w7j
NTbG08p0u7ahA/3Xb/9l8NCwZNC0z1H9iPIdWrSzijSLjfJAlZoRhF5NXmhNwyIA
BIU7nSmtzmdERRaeeVNK5d/fiOhDubWKmDSdRDDYapXZg5BENI0kxk8whGLxKGSC
wsJ+B5POJ5V/8CVlid/OHqvsYsRkPHu1Lb7lGWD2+1iwLDS4Q6uIZttQOoRnuiaM
p8SnJn+9gSF73UU3zbGEb6jjVBqy4iGmG0EL4XR6/SW+c+rkr1TdggBmjNIvOd/G
bz7pn/2+YfE=
=M4Hj
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
