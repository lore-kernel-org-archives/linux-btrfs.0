Return-Path: <SRS0=uD29=Q4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4733FC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 04:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FAC52147A
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 04:49:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfBUEtf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 23:49:35 -0500
Received: from mout.gmx.net ([212.227.17.21]:39033 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbfBUEtf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 23:49:35 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M6zvN-1hI4Wo2obd-00wlI8; Thu, 21
 Feb 2019 05:49:28 +0100
Subject: Re: [PATCH v5.1 00/12] btrfs: Enhancement to tree block validation
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20190218052753.24138-1-wqu@suse.com>
Cc:     David Sterba <dsterba@suse.cz>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <06012a9c-d812-4c54-085f-ce5dba03a274@gmx.com>
Date:   Thu, 21 Feb 2019 12:49:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190218052753.24138-1-wqu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4UlMb6GDsRHQsVpljDjyCBEBhbYTFuR1V"
X-Provags-ID: V03:K1:4LmI6TgpGa9BakHg3AmdsWNGAY0hrGP3z55oF8/UcilAN9HH9PC
 fezt9WWpBksLzGjx+6Kp0JRr496Bu9OSiTaUqpsUy4yXXl9dn3aXdQQPd6wiZh+17G4T4j/
 dUmujdRAeg2hWMEWSRq4O85cWWShL4VvsLp2o7MhmdXEoWMjfuB6/kE+RR67SYlXrIERWax
 Nv/P6ROacKcblTt7XlXPg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:QWDTkrCHne8=:GqobX+IYE4Cg7Y79mqRwdk
 4mzDTB0xJsh0mnmkBvdWwmeTJJIEq+LhDqXlNbknT96EIk+ZjjqiYgoDZE+SBIgdc74CU63Ru
 6gVs/CiHTGeJn7ey0O5UyXVLlqOv2cLxiKwvrrnPWK7bYYYWgBcIJvSmWjH0mTR2O7MkiGBOq
 ZxSiihd4SAWf5C89Ap6SQY6sa7PmRtUxsb8DJnf5eLUi7apuPLaG62cri7IIc2nZfyluXFfjv
 GDnj7m1G8xtuInOnsBtzyd3rZgMqo3YKcwMEtqTp2yvLaULREfo5aE1CK7Sq3SOcADCJR5vwE
 3zyqpCmixPxDzgsnB6Uk3ZOV0P6I0PFbH1CpgkifEuqFhImJovvEyw24AAE2e6DH1K00zSiS5
 NaiaP4kQALwlZdLaoDctWqFNAswyEjMqcz1i0BDyajDBK33NaX7duMZNg53V4TcEC8w5Byq5o
 itPTBqkwevtPki8kTtbJOCuhXNEQk7xq5ZSOi2TPMk0r8ijq/1hH/4aj11Ko1cSXMR3E0GvUj
 YxzdE4mDdsRtQ3xMEvX5ydRFq/SNymy5Lklod9B8jWAkJ+RwtQoXOC8lJnVUMjnSAVu5+G7VA
 j/Pz9DcsWFaFant287zZCoxaoR4yA1v2CFLSh/wbtdPQbpu8hB6FRj74cjBEmqDrgWZzZjN2b
 8UJfFZDyN55AP3ZoccxrdwthvQDIhNDu6s4u+nO8XVZ7pbF7UJT/9VAWQ3bSaWg+83O385TO1
 pGiPgHA5bhhuKnagNIuaGFnL05slMHw3G3xg8gCmPm4lmobSnrf3b2nfiQlzG8gGG2dFscT9Y
 ubSEoZdhnxK8h2XBaLwhaI1vki6shIwBV7rX6ID0+IO/x9Ro+U81Dcl8EwpgJ8NcT2tzf3D/8
 YUYD+hvgwcHEPu96VGrl9qScs0udvSQdoRq/FiSRbxtfUtoEyTpTNvzrWkLyUp
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4UlMb6GDsRHQsVpljDjyCBEBhbYTFuR1V
Content-Type: multipart/mixed; boundary="QD0Ogzo4LqUJf7aAqxUQlF4XlrCRCCeNx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>
Message-ID: <06012a9c-d812-4c54-085f-ce5dba03a274@gmx.com>
Subject: Re: [PATCH v5.1 00/12] btrfs: Enhancement to tree block validation
References: <20190218052753.24138-1-wqu@suse.com>
In-Reply-To: <20190218052753.24138-1-wqu@suse.com>

--QD0Ogzo4LqUJf7aAqxUQlF4XlrCRCCeNx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/18 =E4=B8=8B=E5=8D=881:27, Qu Wenruo wrote:
> Patchset can be fetched from github:
> https://github.com/adam900710/linux/tree/write_time_tree_checker
> Which is based on v5.0-rc1 tag.
> Also there is no conflict rebasing the patchset to misc-next.

Now the github branch rebased to v5.0-rc7 tag.

And ran tests of btrfs auto group, no new regressions found.

Git is clever enough in this rebase, so I bother mail bombing the mail
list for another minor update.

Thanks,
Qu

>=20
> This patchset has the following 3 features:
> - Tree block validation output enhancement
>   * Output validation failure timing (write time or read time)
>   * Always output tree block level/key mismatch error message
>     This part is already submitted and reviewed.
>=20
> - Write time tree block validation check
>   To catch memory corruption either from hardware or kernel.
>   Example output would be:
>=20
>     BTRFS critical (device dm-3): corrupt leaf: root=3D2 block=3D135063=
0375424 slot=3D68, bad key order, prev (10510212874240 169 0) current (17=
14119868416 169 0)
>     BTRFS error (device dm-3): block=3D1350630375424 write time tree bl=
ock corruption detected
>     BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=3D=
-5 IO failure (Error while writing out transaction)
>     BTRFS info (device dm-3): forced readonly
>     BTRFS warning (device dm-3): Skipping commit of aborted transaction=
=2E
>     BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=3D-5 =
IO failure
>     BTRFS info (device dm-3): delayed_refs has NO entry
>=20
> - Better error handling before calling flush_write_bio()
>   One hidden reason of calling flush_write_bio() under all cases is,
>   flush_write_bio() will trigger endio function and endio function of
>   epd->bio will free the bio under all cases.
>   So we're in fact abusing flush_write_bio() as cleanup.
>=20
>   Since now flush_write_bio() has its own return value, we shouldn't ca=
ll
>   flush_write_bio() no-brain, here we introduce proper cleanup helper,
>   end_write_bio(). Now we call flush_write_bio() like:
>               New                 |           Old
>   --------------------------------------------------------------
>   ret =3D do_some_evil(&epd);       | ret =3D do_some_evil(&epd);
>   if (ret < 0) {                  | flush_write_bio(&epd);
>   	end_write_bio(&epd, ret); | ^^^ submitting half-backed epd->bio?
>   	return ret;               | return ret;
>   }                               |
>   ret =3D flush_write_bio(&epd);    |
>   return ret;                     |
>=20
>   Above code should be more streamline for the error handling part.
>=20
> Changelog:
> v2:
> - Unlock locked pages in lock_extent_buffer_for_io() for error handling=
=2E
> - Added Reviewed-by tags.
>=20
> v3:
> - Remove duplicated error message.
> - Use IS_ENABLED() macro to replace #ifdef.
> - Added Reviewed-by tags.
>=20
> v4:
> - Re-organized patch split
>   Now each BUG_ON() cleanup has its own patch
> - Dig much further into the call sites to eliminate unexpected >0 retur=
n
>   May be a little paranoid and abuse some ASSERT(), but it should be
>   much safer against further code change.
> - Fix the false alert caused by balance and memory pressure
>   The fix it skip owner checker for non-essential tree at write time.
>   Since owner root can't always be reliable, either due to commit root
>   created in current transaction or balance + memory pressure.
>=20
> v5:
> - Do proper error-out handling other than relying on flush_write_bio()
>   to clean up.
>   This has a side effect that no Reviewed-by tags for modified patches.=

> - New comment for why we don't need to do anything about ebp->bio when
>   submit_one_bio() fails.
> - Add some Reviewed-by tag.
>=20
> v5.1:
> - Add "block=3D%llu " output for write/read time error line.
> - Also output read time error message for fsid/start/level check.
>=20
> Qu Wenruo (12):
>   btrfs: Always output error message when key/level verification fails
>   btrfs: extent_io: Kill the forward declaration of flush_write_bio()
>   btrfs: disk-io: Show the timing of corrupted tree block explicitly
>   btrfs: extent_io: Move the BUG_ON() in flush_write_bio() one level up=

>   btrfs: extent_io: Handle error better in extent_write_full_page()
>   btrfs: extent_io: Handle error better in btree_write_cache_pages()
>   btrfs: extent_io: Kill the dead branch in extent_write_cache_pages()
>   btrfs: extent_io: Handle error better in extent_write_locked_range()
>   btrfs: extent_io: Kill the BUG_ON() in lock_extent_buffer_for_io()
>   btrfs: extent_io: Kill the BUG_ON() in extent_write_cache_pages()
>   btrfs: extent_io: Handle error better in extent_writepages()
>   btrfs: Do mandatory tree block check before submitting bio
>=20
>  fs/btrfs/disk-io.c      |  23 ++++--
>  fs/btrfs/extent_io.c    | 168 ++++++++++++++++++++++++++++------------=

>  fs/btrfs/tree-checker.c |  24 +++++-
>  fs/btrfs/tree-checker.h |   8 ++
>  4 files changed, 164 insertions(+), 59 deletions(-)
>=20


--QD0Ogzo4LqUJf7aAqxUQlF4XlrCRCCeNx--

--4UlMb6GDsRHQsVpljDjyCBEBhbYTFuR1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxuLdMACgkQwj2R86El
/qh/DQf+K0zD+JUo3a/yKWdhIrrViIQa6aLJR92vsdYr0CjlZu3dB/cgnI0V1rLy
p7nb9GOWUu/3qg0vtLddnyIkCz1fbSJkGg65vqfwRsS590/cRNCJ77BVcoo4hehZ
MKIGwu4XHGuDABBV/BL4TRYXGUlNJlL/7J3PAlTR+tSZVRVhPJQKg8BWKeZgtHpw
rfphopIFxqxvG4HzRjg4+f62hC6aSMOPFG8AEfH2p914ipczcka2qBbhJwR3Rvd4
tPDAOSizkSB8iSwFw1g+CbM6Is4cq8WqtoFN8kqSmo+U+jS3ueFXdsU7ZtaSa8+h
KT5XQNEMANssmtXLsrhdyy6mVdrofg==
=sfG+
-----END PGP SIGNATURE-----

--4UlMb6GDsRHQsVpljDjyCBEBhbYTFuR1V--
