Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 109D2C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 00:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7CBE20657
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 00:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfAPAbk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 19:31:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:55402 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727012AbfAPAbk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 19:31:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2E482AFA4;
        Wed, 16 Jan 2019 00:31:39 +0000 (UTC)
Subject: Re: [PATCH v4 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org
References: <20190115081604.785-1-wqu@suse.com>
 <20190115172625.pgblt26vzmdnsv5w@macbook-pro-91.dhcp.thefacebook.com>
From:   Qu Wenruo <wqu@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=wqu@suse.de; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0F1F1IFdlbnJ1byA8d3F1QHN1c2UuZGU+iQFUBBMBCAA+AhsDBQsJCAcCBhUICQoLAgQW
 AgMBAh4BAheAFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVgp0FCQlmAm4ACgkQwj2R86El
 /qilmgf/cUq9kFQo577ku5gc6rFpVg68ublBwjYpwjw0b//xo+Wo1wm+RRbUGs+djSZAqw12
 D4F3r0mBTI7abUCNWAbFkYZSAIFVi0DMkjypIVS7PSaEt04rM9VBTToE+YqU6WENeJ57R2p2
 +hI0wZrBwxObdsdaOtxWtsp3bmhIbdqxSKrtXuRawy4KnQYcLuGzOce9okdlbAE0W3KHm1gQ
 oNAe6FX8nC9qo14m8LqEbThYH+qj4iCMlN8HIfbSx4F3e7nHZ+UAMW+E/lnMRkIB9Df+JyVd
 /NlXzIjZAggcWsqpx6D4wyAuexKWkiGQeUeArUNihAwXjmyqWPGmjVyIh+oC6LkBDQRZ1YGv
 AQgAqlPrYeBLMv3PAZ75YhQIwH6c4SNcB++hQ9TCT5gIQNw51+SQzkXIGgmzxMIS49cZcE4K
 Xk/kHw5hieQeQZa60BWVRNXwoRI4ib8okgDuMkD5Kz1WEyO149+BZ7HD4/yK0VFJGuvDJR8T
 7RZwB69uVSLjkuNZZmCmDcDzS0c/SJOg5nkxt1iTtgUETb1wNKV6yR9XzRkrEW/qShChyrS9
 fNN8e9c0MQsC4fsyz9Ylx1TOY/IF/c6rqYoEEfwnpdlz0uOM1nA1vK+wdKtXluCa79MdfaeD
 /dt76Kp/o6CAKLLcjU1Iwnkq1HSrYfY3HZWpvV9g84gPwxwxX0uXquHxLwARAQABiQE8BBgB
 CAAmFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlnVga8CGwwFCQPCZwAACgkQwj2R86El/qgN
 8Qf+M0vM2Idwm5txZZSs+/kSgcPxEwYmxUinnUJGyc0ZWYQXPl0cBetZon9El0naijGzNWvf
 HxIPB+ZFehk6Otgc78p1a3/xck/s1myFRLrmbbTJNoFiyL25ljcq0J8z5Zp4yuABL2RiLdaZ
 Pt/jfwjBHwGR+QKp6dD2qMrUWf9b7TFzYDMZXzZ2/eoIgtyjEelNBPrIgOFe24iKMjaGjd97
 fJuRcBMHdhUAxvXQF1oRtd83JvYJ5OtwTd8MgkEfl+fo7HwWkuHbzc70L4fFKv2BowqFdaHy
 mId1ijGPGr46tuZ5a4cw/zbaPYx6fJ4sK9tSv/6V1QPNUdqml6hm6pfs6A==
Message-ID: <40fa6d23-00e0-666e-60f5-1505e157aacc@suse.de>
Date:   Wed, 16 Jan 2019 08:31:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190115172625.pgblt26vzmdnsv5w@macbook-pro-91.dhcp.thefacebook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="yHvgsWPL4lqO2SoAovVUuHRwcwTpvtVL7"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--yHvgsWPL4lqO2SoAovVUuHRwcwTpvtVL7
Content-Type: multipart/mixed; boundary="lYYYZbDdmIXlLj31O7ZFAXqwLGJQQDxk4";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <40fa6d23-00e0-666e-60f5-1505e157aacc@suse.de>
Subject: Re: [PATCH v4 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
References: <20190115081604.785-1-wqu@suse.com>
 <20190115172625.pgblt26vzmdnsv5w@macbook-pro-91.dhcp.thefacebook.com>
In-Reply-To: <20190115172625.pgblt26vzmdnsv5w@macbook-pro-91.dhcp.thefacebook.com>

--lYYYZbDdmIXlLj31O7ZFAXqwLGJQQDxk4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/16 =E4=B8=8A=E5=8D=881:26, Josef Bacik wrote:
> On Tue, Jan 15, 2019 at 04:15:57PM +0800, Qu Wenruo wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree
>>
>> Which is based on v5.0-rc1.
>>
>=20
> I've been testing these patches hoping to get rid of the qgroup deadloc=
k that
> these patches are supposed to fix, but instead they make the box comple=
tely
> unusable with 100% cpu usage for minutes at a time at every transaction=
 commit.

I'm afraid it's related to the v5.0-rc1 base, not the patchset itself.

Just try to balance metadata with 16 snapshots, you'll see btrfs bumping
its generation like crazy, no matter if quota is enabled or not.

And since btrfs is committing transaction like crazy, no wonder it will
do tons of qgroup accounting.

My bisect leads to commit 64403612b73a94bc7b02cf8ca126e3b8ced6e921
btrfs: rework btrfs_check_space_for_delayed_refs.

Thanks,
Qu

> Thanks,
>=20
> Josef
>=20


--lYYYZbDdmIXlLj31O7ZFAXqwLGJQQDxk4--

--yHvgsWPL4lqO2SoAovVUuHRwcwTpvtVL7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw+e2YACgkQwj2R86El
/qhe2AgAioPCnEo0hT0gznrvx7YXLuwaSD7YZyg09V+PFc65qVaSIsq9D7tCc5YH
2RYkHbYPEk+kBOU2W8P9eu6Bo6KXAozll3ue5mEyO478yChh83G8NFKeQxAlIk5Q
M5574G43qfMFTwJVHq/MkUP7YThJDXcfVF431GczNTbo7Uc1yXVaNdV22f3C3glJ
yUUuTbYlHO+mfFaN/e8kDHbkaWLkr/43d/P+9CrIa6i+K5QgXiQUrD7HrB1fS4Lj
YgJq3o9wU6DId9/xe0bfxv8wyg+L6ioGSGLjFR4YjDgzgWjbhAaosa/dyvsupehG
CMcrcDjJNQND2ykNkwTD1f4mdZfGGw==
=i3RR
-----END PGP SIGNATURE-----

--yHvgsWPL4lqO2SoAovVUuHRwcwTpvtVL7--
