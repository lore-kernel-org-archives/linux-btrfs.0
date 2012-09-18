Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:46264 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2IRITx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 04:19:53 -0400
Date: Tue, 18 Sep 2012 09:19:40 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Roman Mamedov <rm@romanrm.ru>
Cc: miaox@cn.fujitsu.com, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs-progs: add mount-option command
Message-ID: <20120918081940.GH1129@carfax.org.uk>
References: <5057CDA7.3090201@jp.fujitsu.com>
 <5057CEA9.3070707@jp.fujitsu.com>
 <5057DD0D.1070201@cn.fujitsu.com>
 <20120918101930.6f3edb3c@natsu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dx9iWuMxHO1cCoFc"
In-Reply-To: <20120918101930.6f3edb3c@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--Dx9iWuMxHO1cCoFc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 18, 2012 at 10:19:30AM +0600, Roman Mamedov wrote:
> On Tue, 18 Sep 2012 10:31:41 +0800
> Miao Xie <miaox@cn.fujitsu.com> wrote:
> 
> > On tue, 18 Sep 2012 10:30:17 +0900, Hidetoshi Seto wrote:
> > > This patch adds mount-option command.
> > > The command can set/get default mount options.
> > > Now, the command can set/get 24 options.
> > > These options are equal to mount options which store
> > > in fs_info/mount-opt.
> > 
> > I don't think we need implement a separate command to do this,
> > we can add it into btrfstune just like ext3/4. If so, the users
> > who used ext3/4 before can be familiar with btrfs command as soon
> > as possible.
> 
> btrfstune currently only does one thing:
> 
> $ sudo btrfstune
> usage: btrfstune [options] device
> 	-S value	enable/disable seeding
> 
> To me it'd seem more logical the other way, why not move this operation to the
> base "btrfs" utility under some command, and remove "btrfstune" completely.

   I would suggest picking up and extending Alex Block's "btrfs
property set/get" idea for this.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Welcome to Rivendell,  Mr Anderson... ---              

--Dx9iWuMxHO1cCoFc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUFgunL9z9OVl50rAAQK61Q/+I+u+kJnsigJu0gVZSI3xJmx7hylwY6IN
ceaE7hmUxivy9juAc3rh5UrYPueCyulgGCZy31ZPhkKMxsGO2ljpX7w1KaXcC34S
C9X6W3eWNbtboolXXElhteoFObNdUv5ptS9noU49fMDYGTcnY91Kc/AInLpJY13T
Ph+uCFoIwpoFd4vauArFZPE9QklYtmV1VJi6q7mrqqRcFkuCQtKiV5Q4Yhx6l3IB
9t1eGwAsQNMmx8l4pEjPWT//4evx+DCTCeU0UQcxqgl10H3UaxO/Qktcp2sqoc5n
nnGp+9k8jzSTjnMh6JnJlYAhmfwyEzjZ1mgTpI7XQ+4LTBh86KJv4JWmeAseR5G2
FVYNQYTbxVZM536tlyg1B+wUcRj3I0Lt/vvwKb4nfynR0zf0iOKsyNP9U8tgAeyB
y1tNF6Z4KOYd2ByvzK09ACAivU1l+mqKXIpTkBe0JhvmHix0ZAOL9bbbg9ChaLZ7
m5P7rhzikm2LSC/+1zU63qSlA8gBYeV3sEeXPG5Lm0yy5H/BdrsOQFUC7OgHbspn
ev6Ft/jZuxPDByZC2iprFly2WpkSfcJcBhNw5dn3bCkUQQaKo6svbZVasZRhIC1F
qnNST0Lbhan6pnfYnofLXCHsa6v3KYwXiK9KNrFSYiRuiBy7cvwcbzvTqiVFEx2R
LHn7Y/tAx0s=
=Xy4H
-----END PGP SIGNATURE-----

--Dx9iWuMxHO1cCoFc--
