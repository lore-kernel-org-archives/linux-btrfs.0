From: Hugo Mills <hugo-lkml@carfax.org.uk>
Subject: Re: Kernel error during btrfs balance
Date: Wed, 26 Jan 2011 09:27:46 +0000
Message-ID: <20110126092746.GJ29985@carfax.org.uk>
References: <4D344EBB.6030903@logtenberg.eu>
 <4D3452C9.901@logtenberg.eu>
 <4D3948CB.8090801@logtenberg.eu>
 <AANLkTinN7QYqwydzgidERhu46QTEE8bLwiRy4qjM2fyL@mail.gmail.com>
 <4D3FE382.6070000@logtenberg.eu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W13SgbpmD6bhZUTM"
Cc: "Yan, Zheng " <yanzheng@21cn.com>, linux-btrfs@vger.kernel.org
To: Erik Logtenberg <erik@logtenberg.eu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D3FE382.6070000@logtenberg.eu>
List-ID: <linux-btrfs.vger.kernel.org>


--W13SgbpmD6bhZUTM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 26, 2011 at 10:04:02AM +0100, Erik Logtenberg wrote:
> Hi,
> 
> It took me a couple of days, because I needed to patch my kernel first
> and then issue a rebalance, which ran for more than two days.
> Nevertheless, the rebalance succeeded without any "kernel BUG"-messages,
> so apparently your patch works!
> 
> I noticed that at first, the messages were like this:
> 
> [79329.526490] btrfs: found 1939 extents
> [79375.950834] btrfs: found 1939 extents
> [79376.083599] btrfs: relocating block group 352220872704 flags 1
> [80052.940435] btrfs: found 3786 extents
> [80108.439657] btrfs: found 3786 extents
> [80112.325548] btrfs: relocating block group 351147130880 flags 1
> 
> Just like I saw during previous balance-runs. Then all of a sudden the
> messages changed to:
> 
> [104178.827594] btrfs allocation failed flags 1, wanted 2013265920
> [104178.827599] space_info has 4271198208 free, is not full
> [104178.827602] space_info total=214748364800, used=210440957952,
> pinned=0, reserved=36208640, may_use=3168993280, readonly=0
> [104178.827606] block group 1107296256 has 5368709120 bytes, 5368582144
> used 0 pinned 0 reserved
> [104178.827610] entry offset 1778384896, bytes 86016, bitmap yes
> [104178.827612] entry offset 1855827968, bytes 20480, bitmap no
> [104178.827614] entry offset 1855852544, bytes 20480, bitmap no
> [104178.827617] block group has cluster?: no
> [104178.827618] 0 blocks of free space at or bigger than bytes is
> [104178.827621] block group 8623489024 has 5368709120 bytes, 5368705024
> used 0 pinned 0 reserved
> [104178.827624] entry offset 8891924480, bytes 4096, bitmap yes
> [104178.827626] block group has cluster?: no
> [104178.827628] 0 blocks of free space at or bigger than bytes is
> [104178.827631] block group 17213423616 has 5368709120 bytes, 5368709120
> used 0 pinned 0 reserved
> [104178.827634] block group has cluster?: no
> 
> And so on.
> 
> Does this indicate an error of any sort, or is this expected behaviour?

   As far as I know, it means that you've run out of space, and not
every block group has been rewritten by the balance process.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- In one respect at least, the Martians are a happy people: ---    
                          they have no lawyers.                          

--W13SgbpmD6bhZUTM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFNP+kSIKyzvlFcI40RAvV1AJ9hixyMqsOt95PSm6iYjsJBdjiruQCgzX+Z
2Kuv5upSkM+A1mvMbV++r/E=
=afXz
-----END PGP SIGNATURE-----

--W13SgbpmD6bhZUTM--
