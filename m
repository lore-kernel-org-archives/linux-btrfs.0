Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:37869 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755693AbcIOBIB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 21:08:01 -0400
Received: by mail-it0-f50.google.com with SMTP id 186so51364962itf.0
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Sep 2016 18:08:00 -0700 (PDT)
Date: Wed, 14 Sep 2016 21:07:59 -0400
From: Nicholas D Steeves <nsteeves@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: dsterba@suse.cz, Waxhead <waxhead@online.no>, linux-btrfs@vger.kernel.org
Subject: Re: Is stability a joke?
Message-ID: <20160915010759.GD32452@DigitalMercury.dynalias.net>
References: <57D51BF9.2010907@online.no>
 <20160912142714.GE16983@twin.jikos.cz>
 <52304724-5bca-a1e6-527f-040085c7ab19@gmail.com>
 <20160912165107.GG16983@twin.jikos.cz>
 <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="MAH+hnPXVZWQ5cD/"
In-Reply-To: <58a954fc-bbd5-3fb5-9f23-008ed7f7121d@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--MAH+hnPXVZWQ5cD/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 12, 2016 at 01:31:42PM -0400, Austin S. Hemmelgarn wrote:
> In general yes in this case, but performance starts to degrade exponentially
> beyond a certain point.  The difference between (for example) 10 and 20
> snapshots is not as much as between 1000 and 1010. The problem here is that
> we don't really have a BCP document that anyone ever reads.  A lot of stuff
> that may seem obvious to us after years of working with BTRFS isn't going to
> be to a newcomer, and it's a lot more likely that some random person will
> get things write if we have a good, central BCP document than if it stays as
> scattered tribal knowledge.

"Scattered tribal knowledge"...exactly!  :-D

Cheers,
Nicholas

--MAH+hnPXVZWQ5cD/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCgAGBQJX2fRvAAoJEFqIMEdffRBhl1AP/1n9uoWoIFHoEwXiSDcAvHXO
ADlexDRUtRmnIQTN2pA+WjtIdpUUpt+F9UzeoqQIGiDE6qzqzCIQ1Of04y4K35uK
+crk3CPdd7UzDGBBH3SA4Ab/8Ageemhue3G3zaF71KJwIBbDgMXfVlh5YeR2vrrg
eGMs4N5qRv85Bb3hc2zn5s1QaCX84t5NR76GRnHG/A9a11ksUoMOCcSmT82KdUbQ
n2aQa9Bg4/W0Xk+dUbC0a12xlJGpkxFYSzIxzrrB9hyPB3Rp1joDFRHEFLerZyCS
OSoEFSb6jHic+Dotf9HIe5wbtjJQjawzGDXKehqukW0OFtFZDfHVmC/BfWzzZm98
4yVy/nNgo/EZ2RK2Qmr4AeuCDYILB7Iezl0hCymHJl+MOGx33QhBY9Jiip4qacnj
UnUcZD/Rq7RGjlZ/tpaR301EBIJg7vF5bNAD94Eul0e6MBipJW8wzSHSmW+JKVBq
sndlZKczD51xdpWUke9iL1lwq9ZgzknpXS+L+oHogFPixsd+tLMdshGC5WrhENhP
1i8D4vfnS+GBLHMePrEes2ZC8Dxa7lx38mpLKiJEFJVcoo6m0Oo+MuOjEz2IV8US
L6Xuz+6vGBE2+aPjG9B9eunM07o59AErotKieFWGgE/z78gWyNK7A3IPE5ym3jty
T6YCRk+ltotQdKwp4RF0
=AdeM
-----END PGP SIGNATURE-----

--MAH+hnPXVZWQ5cD/--
