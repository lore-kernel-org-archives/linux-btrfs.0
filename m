Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:54047 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2FDRJj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 13:09:39 -0400
Date: Mon, 4 Jun 2012 18:09:36 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Maxim Mikheev <mikhmv@gmail.com>, Liu Bo <liubo2009@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Help with data recovering
Message-ID: <20120604170936.GE15986@carfax.org.uk>
References: <4FCC9C63.7000605@gmail.com>
 <4FCC9CD5.2050309@gmx.net>
 <4FCC9F6C.5090305@gmail.com>
 <20120604114901.GA15986@carfax.org.uk>
 <4FCCA39C.8060409@gmail.com>
 <20120604121134.GB15986@carfax.org.uk>
 <4FCCA9E6.3030209@gmail.com>
 <20120604123431.GC15986@carfax.org.uk>
 <4FCCE125.7000004@gmail.com>
 <20120604170422.GD15986@carfax.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gDGSpKKIBgtShtf+"
In-Reply-To: <20120604170422.GD15986@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--gDGSpKKIBgtShtf+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 04, 2012 at 06:04:22PM +0100, Hugo Mills wrote:
>    I'm out of ideas.

   ... but that's not to say that someone else may have some ideas. I
wouldn't get your hopes up too much, though.

>    At this point, though, you're probably looking at somebody writing
> custom code to scan the FS and attempt to find and retrieve anything
> that's recoverable.
> 
>    You might try writing a tool to scan all the disks for useful
> fragments of old trees, and see if you can find some of the tree roots
> independently of the tree of tree roots (which clearly isn't
> particularly functional right now). You might try simply scanning the
> disks looking for your lost data, and try to reconstruct as much of it
> as you can from that. You could try to find a company specialising in
> data recovery and pay them to try to get your data back. Or you might
> just have to accept that the data's gone and work on reconstructing
> it.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- A linked list is still a binary tree.  Just a very unbalanced ---  
                             one.  -- dragon                             

--gDGSpKKIBgtShtf+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFPzOvQIKyzvlFcI40RAtO5AJ0bB2Ik3XLoQSDrCNVcHz4ZkEjJCgCgqP7D
kMt3u91LVjaddrNo+7Y8VbM=
=0hwh
-----END PGP SIGNATURE-----

--gDGSpKKIBgtShtf+--
