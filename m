Return-Path: <SRS0=uD29=Q4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29DE9C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 00:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2B902146E
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Feb 2019 00:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfBUAiC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 20 Feb 2019 19:38:02 -0500
Received: from mout.gmx.net ([212.227.15.19]:48769 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbfBUAiB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Feb 2019 19:38:01 -0500
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.com (mrgmx002
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MYfre-1gb2x538MM-00VTFT; Thu, 21
 Feb 2019 01:37:50 +0100
Subject: Re: [PATCH v5.1 00/12] btrfs: Enhancement to tree block validation
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190218052753.24138-1-wqu@suse.com>
 <20190220182544.GZ9874@twin.jikos.cz>
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
Message-ID: <0f20234c-5fa7-8059-094d-b12e4e9963d0@gmx.com>
Date:   Thu, 21 Feb 2019 08:37:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190220182544.GZ9874@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="m2NjAFZ4wnZeMqYsg841hc63dk9jb0VB9"
X-Provags-ID: V03:K1:1rR6E+CJUlyPSLgJkOhL8PBgxSoppKz1LM1V3zQwt7FpeJQ7crN
 G/bd16i4w5DeDJV7AxRksEjjN4YM+8YScGTclFKjIMm5Ly3tI11ESZPYWPvurCjlc0PqYid
 aFNyIzdF8B5o4eRmhBcyKQqTsIMa693S7jRM1hmEzgvRkjSXdkPuh2cMDg3zSGeBQSm5IAN
 JBNfWSG7dH6SqYcGHRlVQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:65FvOluEXdA=:KElGCbIyDhrwwOaEG4SFCk
 z0R687uGKL8uRtdycHnMEKdtu/DP5nkmZzUvg8hqB5Na+FGFxUaw+gflmOEYD4E2N0FRxnEZ/
 M98fjrchNho5E4wgO85cWKN/H+p8n14rjBWMTsuoh2RYhr5xLVsDmI1tOZlKdi/8rG5c6BUH6
 En7Az95L975HDzJtSTGPoP85g15nnomU8OlIE1xYVEQhkoSBCuF1I+5cOPIvtyyXB6UWyb2iG
 +iyJmXD1gYGUGBs2mWhSoLHIcwkwt6Hosu34gMGl8v6IP9VeqhSAqBmhJl8PKwlbxmgyTYXFQ
 yqEhplONWJ27aDLXdWfsUqSMC4TDh9aZBnJZUiZlyp9ImEZ7eal7/j1F3njPiUDNtDUygU+8T
 qR8API9NSKSgisYDdi/GKxRKlWyDbH8caiQQsAyyMISvzvEQ6PRPG3FxS9OqFPgJhBOrr3jnC
 E6ATEUcszTwOumyc8EGod6YtwpSY1nMTjKCciqQ12jWaNnuHXl2d9ziwTQVXikrdFaMIeMYvG
 48vX5SjejHFqQtkTeASItguvjmk41u2k+5uUAC+sVjnbwgYfSP/t2OVS7YYaIjCDYsUxB09zE
 l3lVBszZ3BbDACb5ZN8S7a/kw5WhGX82kiB9vUaL0pO1Dyo199oi1r7NzJu6TH+k5VluDW5FM
 A06cdUwVy/8LRrXlb5shR0qqKWn+hytHVCajmkBIeIETjdQrmRWk/XZq2YjJnyR4X+BFXb7PG
 D6cSOumoWBP9dA3QnzdNFFdwExFIUoVBbRBlkhjSj9ZIWnx6aCkVLdQrkaIliRtTFAhqWB10j
 gaFO0NfLf5YKK2e4ko7TsIzQH1lGhXV95BPTwvG4EpcilfEGoGHd/mSU/d7hZPzNVs/Ic5wMB
 eTqVoYW5cjex633eLDNLnjHLU70Uhp0ekHw4cLoUqK6rYULz3MOmA3aQQp+BNF
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--m2NjAFZ4wnZeMqYsg841hc63dk9jb0VB9
Content-Type: multipart/mixed; boundary="RqTPk8dy0nikWvuHEposXNAP85Swp1Nws";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <0f20234c-5fa7-8059-094d-b12e4e9963d0@gmx.com>
Subject: Re: [PATCH v5.1 00/12] btrfs: Enhancement to tree block validation
References: <20190218052753.24138-1-wqu@suse.com>
 <20190220182544.GZ9874@twin.jikos.cz>
In-Reply-To: <20190220182544.GZ9874@twin.jikos.cz>

--RqTPk8dy0nikWvuHEposXNAP85Swp1Nws
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/2/21 =E4=B8=8A=E5=8D=882:25, David Sterba wrote:
> On Mon, Feb 18, 2019 at 01:27:41PM +0800, Qu Wenruo wrote:
>> Patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/write_time_tree_checker
>> Which is based on v5.0-rc1 tag.
>=20
> Please base the patches on something new, a recent rc is fine (rc6 or
> rc7 depends what you've tested).

Any recommended workflow for different timing point?
E.g. always rebase to latest rc?

My current (and now is proven not proper) workflow is to stick with
-rc1, and cherry pick known fixes related to test.
This provides a stable base run to spot regression caused by my patches.

>=20
>> Also there is no conflict rebasing the patchset to misc-next.
>=20
> The patches can apply on top of misc-next, but I've seen some hunks
> applied with offset. While git is good, mismerges can still happen, so
> if you do the rebase on your side it lowers the risk.

No problem, I'll change the my workflow to more proper one.

>=20
>> This patchset has the following 3 features:
>> - Tree block validation output enhancement
>>   * Output validation failure timing (write time or read time)
>>   * Always output tree block level/key mismatch error message
>>     This part is already submitted and reviewed.
>>
>> - Write time tree block validation check
>>   To catch memory corruption either from hardware or kernel.
>>   Example output would be:
>>
>>     BTRFS critical (device dm-3): corrupt leaf: root=3D2 block=3D13506=
30375424 slot=3D68, bad key order, prev (10510212874240 169 0) current (1=
714119868416 169 0)
>>     BTRFS error (device dm-3): block=3D1350630375424 write time tree b=
lock corruption detected
>>     BTRFS: error (device dm-3) in btrfs_commit_transaction:2220: errno=
=3D-5 IO failure (Error while writing out transaction)
>>     BTRFS info (device dm-3): forced readonly
>>     BTRFS warning (device dm-3): Skipping commit of aborted transactio=
n.
>>     BTRFS: error (device dm-3) in cleanup_transaction:1839: errno=3D-5=
 IO failure
>>     BTRFS info (device dm-3): delayed_refs has NO entry
>>
>> - Better error handling before calling flush_write_bio()
>>   One hidden reason of calling flush_write_bio() under all cases is,
>>   flush_write_bio() will trigger endio function and endio function of
>>   epd->bio will free the bio under all cases.
>>   So we're in fact abusing flush_write_bio() as cleanup.
>>
>>   Since now flush_write_bio() has its own return value, we shouldn't c=
all
>>   flush_write_bio() no-brain, here we introduce proper cleanup helper,=

>>   end_write_bio(). Now we call flush_write_bio() like:
>>               New                 |           Old
>>   --------------------------------------------------------------
>>   ret =3D do_some_evil(&epd);       | ret =3D do_some_evil(&epd);
>>   if (ret < 0) {                  | flush_write_bio(&epd);
>>   	end_write_bio(&epd, ret); | ^^^ submitting half-backed epd->bio?
>>   	return ret;               | return ret;
>>   }                               |
>>   ret =3D flush_write_bio(&epd);    |
>>   return ret;                     |
>>
>>   Above code should be more streamline for the error handling part.
>>
>> Changelog:
>> v2:
>> - Unlock locked pages in lock_extent_buffer_for_io() for error handlin=
g.
>> - Added Reviewed-by tags.
>>
>> v3:
>> - Remove duplicated error message.
>> - Use IS_ENABLED() macro to replace #ifdef.
>> - Added Reviewed-by tags.
>>
>> v4:
>> - Re-organized patch split
>>   Now each BUG_ON() cleanup has its own patch
>> - Dig much further into the call sites to eliminate unexpected >0 retu=
rn
>>   May be a little paranoid and abuse some ASSERT(), but it should be
>>   much safer against further code change.
>> - Fix the false alert caused by balance and memory pressure
>>   The fix it skip owner checker for non-essential tree at write time.
>>   Since owner root can't always be reliable, either due to commit root=

>>   created in current transaction or balance + memory pressure.
>>
>> v5:
>> - Do proper error-out handling other than relying on flush_write_bio()=

>>   to clean up.
>>   This has a side effect that no Reviewed-by tags for modified patches=
=2E
>> - New comment for why we don't need to do anything about ebp->bio when=

>>   submit_one_bio() fails.
>> - Add some Reviewed-by tag.
>>
>> v5.1:
>> - Add "block=3D%llu " output for write/read time error line.
>> - Also output read time error message for fsid/start/level check.
>=20
> The patchset is in a good shape, I like the detailed changelogs and
> example messages. I'll give it some more testing though merging to 5.1
> does not seem to be feasible now but we'll see.

I'm fine with v5.2.

Just wonder if I need to rebase to v5.1-rc1 later on?

Thanks,
Qu

> The improved error
> handling is not really a feature so a late pull request could be ok for=

> that.
>=20
> Thanks.
>=20


--RqTPk8dy0nikWvuHEposXNAP85Swp1Nws--

--m2NjAFZ4wnZeMqYsg841hc63dk9jb0VB9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlxt8tQACgkQwj2R86El
/qiUNwgAo4BWbejfM2qIVT6Btqaq9vdDAGQVhY54zsXnHEmGU1CqnqEpkFUhgTgy
ExUcaF2Z6q+uhkzGghxs/2DaxK+VvzjigKoAUbdL+NxxosT1SrUautcPVb0y1dZX
VInremZKIOSg1NhgNjLXB7qBBK0fb37+cP+LLIm4QYO+VwzxFn4x6O/MoKqCn/0I
yzLowrgM7MF/ry3DetIcTvrNUnn82T9vaLMg/noKv6Jd4pbPi64pH/zUk8+ZQtX4
AFmS7AEw39pJlXBcHVahyvIx2LL68QVECBnWJtrNhE7UtcZHyQdt2p0uZcLnQ9hR
9twG8lwXL07QDksSD7zWOC6nQyS59g==
=Wcv8
-----END PGP SIGNATURE-----

--m2NjAFZ4wnZeMqYsg841hc63dk9jb0VB9--
