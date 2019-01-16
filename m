Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6CCC43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 472732086D
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbfAPBgc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 20:36:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:34982 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726123AbfAPBgc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 20:36:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E3783ACD0;
        Wed, 16 Jan 2019 01:36:30 +0000 (UTC)
Subject: Re: [PATCH v4 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
To:     Josef Bacik <josef@toxicpanda.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
References: <20190115081604.785-1-wqu@suse.com>
 <20190115172625.pgblt26vzmdnsv5w@macbook-pro-91.dhcp.thefacebook.com>
 <40fa6d23-00e0-666e-60f5-1505e157aacc@suse.de>
 <adf8aa97-2638-26f7-1cb2-813ef5a342c9@gmx.com>
 <20190116011556.5qzmvu5m7ub6fm7m@macbook-pro-91.dhcp.thefacebook.com>
 <3f0a8149-2e07-73a8-0cdd-46528f03915a@gmx.com>
 <20190116013408.adq7rny5n3p2sa2q@macbook-pro-91.dhcp.thefacebook.com>
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
Message-ID: <8ff38dbb-7edb-b83a-9027-53beb52df29e@suse.de>
Date:   Wed, 16 Jan 2019 09:36:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190116013408.adq7rny5n3p2sa2q@macbook-pro-91.dhcp.thefacebook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QlZnPjQKW2A7ewdg9nT6RJ1NVjmKsCze5"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QlZnPjQKW2A7ewdg9nT6RJ1NVjmKsCze5
Content-Type: multipart/mixed; boundary="4h1s5W6ZcdZ7psAs4gLqwt1wqWDufs6nb";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <8ff38dbb-7edb-b83a-9027-53beb52df29e@suse.de>
Subject: Re: [PATCH v4 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
References: <20190115081604.785-1-wqu@suse.com>
 <20190115172625.pgblt26vzmdnsv5w@macbook-pro-91.dhcp.thefacebook.com>
 <40fa6d23-00e0-666e-60f5-1505e157aacc@suse.de>
 <adf8aa97-2638-26f7-1cb2-813ef5a342c9@gmx.com>
 <20190116011556.5qzmvu5m7ub6fm7m@macbook-pro-91.dhcp.thefacebook.com>
 <3f0a8149-2e07-73a8-0cdd-46528f03915a@gmx.com>
 <20190116013408.adq7rny5n3p2sa2q@macbook-pro-91.dhcp.thefacebook.com>
In-Reply-To: <20190116013408.adq7rny5n3p2sa2q@macbook-pro-91.dhcp.thefacebook.com>

--4h1s5W6ZcdZ7psAs4gLqwt1wqWDufs6nb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/16 =E4=B8=8A=E5=8D=889:34, Josef Bacik wrote:
> On Wed, Jan 16, 2019 at 09:29:29AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/1/16 =E4=B8=8A=E5=8D=889:15, Josef Bacik wrote:
>>> On Wed, Jan 16, 2019 at 09:07:26AM +0800, Qu Wenruo wrote:
>>>>
>>>>
>>>> On 2019/1/16 =E4=B8=8A=E5=8D=888:31, Qu Wenruo wrote:
>>>>>
>>>>>
>>>>> On 2019/1/16 =E4=B8=8A=E5=8D=881:26, Josef Bacik wrote:
>>>>>> On Tue, Jan 15, 2019 at 04:15:57PM +0800, Qu Wenruo wrote:
>>>>>>> This patchset can be fetched from github:
>>>>>>> https://github.com/adam900710/linux/tree/qgroup_delayed_subtree
>>>>>>>
>>>>>>> Which is based on v5.0-rc1.
>>>>>>>
>>>>>>
>>>>>> I've been testing these patches hoping to get rid of the qgroup de=
adlock that
>>>>>> these patches are supposed to fix, but instead they make the box c=
ompletely
>>>>>> unusable with 100% cpu usage for minutes at a time at every transa=
ction commit.
>>>>>
>>>>> I'm afraid it's related to the v5.0-rc1 base, not the patchset itse=
lf.
>>>>>
>>>>> Just try to balance metadata with 16 snapshots, you'll see btrfs bu=
mping
>>>>> its generation like crazy, no matter if quota is enabled or not.
>>>>>
>>>>> And since btrfs is committing transaction like crazy, no wonder it =
will
>>>>> do tons of qgroup accounting.
>>>>>
>>>>> My bisect leads to commit 64403612b73a94bc7b02cf8ca126e3b8ced6e921
>>>>> btrfs: rework btrfs_check_space_for_delayed_refs.
>>>>
>>>> Furthermore, you could try this RFC test case to see the problem.
>>>> https://patchwork.kernel.org/patch/10761715/
>>>>
>>>> It would only take around 100s for v4.20 but over 500 for v5.0-rc1 w=
ith
>>>> tons of unnecessary transaction committed for nothing, no quota enab=
led.
>>>>
>>>> So I'm afraid that commit is blocking my qgroup patchset.
>>>>
>>>
>>> I've fixed the balance problem, it took 2 seconds to figure out, I'm =
just
>>> waiting on xfstests to finish running.
>>>
>>> And your patch making things worse has nothing to do with that proble=
m.  Our
>>> test doesn't run balance, so the issue you reported has nothing to do=
 with the
>>> fact that your patch makes our boxes unusable with qgroups on.
>>>
>>> The problem is with your deadlock avoidence patch we're now making a =
lot more
>>> dirty extents to run in the critical section of the transaction commi=
t.  Also
>>> because we're no longer pre-fetching the old roots, we're doing the o=
ld roots
>>> and new roots lookup inside the critical section, so now each dirty e=
xtent takes
>>> 2x as long.  With my basic test it was taking 5 minutes to do the qgr=
oup
>>> accounting, which keeps the box from booting essentially.
>>>
>>> Without your patch it's still awful because btrfs-cleaner just sits t=
here at
>>> 100% while deleting snapshots, but at least it's not making the whole=
 system
>>> stop running while it does all that work in the transaction commit.
>>>
>>> And if you had done the proper root cause analysis you would have not=
iced that
>>> we're taking tree locks in the find_parent_nodes() case when we're se=
arching the
>>> commit root, something we shouldn't be doing.  So all that really nee=
ds to be
>>> done is to check if (!path->skip_locking) btrfs_tree_read_lock(eb); i=
n those
>>> cases and the deadlock goes away.  Because no matter what we shouldn'=
t be taking
>>> locks when we're not given a trans in the backref lookup code.
>>
>> That indeed looks much better than my current solution.
>>
>> Although I'm not 100% sure for cases like tree blocks shared between
>> commit and current root (tree block not modified yet).
>=20
> Doesn't matter, the block can't be modified so we don't need the lockin=
g,  If
> the current root needs to change it then it cow's it and messes with th=
e new eb,
> not the one attached to the commit root.
>=20
>>
>> I'll definitely invest more time to try to fix this bug.
>>
>=20
> Don't worry about it, I'm already running the patch through my tests, I=
'll send
> them in the morning when the tests are finished.  Thanks,

I can't be more happier dropping that deadlock fix patch.

Thanks,
Qu

>=20
> Josef
>=20


--4h1s5W6ZcdZ7psAs4gLqwt1wqWDufs6nb--

--QlZnPjQKW2A7ewdg9nT6RJ1NVjmKsCze5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw+ipkACgkQwj2R86El
/qh77wgAmYqkjlyJAwXtci3aRK7y3zQzxYH3XxJNLrxOHtDD9O3zHHSJ00Bw0Nja
zNFKfn2U+yNOev9EamlOAMhTFJ4eiTdFMn/a3e7DXwEXpwQCN5WzTkrDJJOJgjyJ
hWcH6925a0PPHhRDvf87EiFStDVMAZrRNwScl2on5nSxHmRnu/Uc96owHs9k6cut
zlUGO/P3SwKA3qnjTvRydRd2YAQQ3HDE7mYVjHfItGdN/g1e9IFU+R58V9//yD9r
Eq6V+duI/Gm5yfEw59VjhU/Dj8WNQhCdueUGazDLWPO0CTuGUs47RiSWQF0L8o3d
fdNvsFdmLRuYImZtmtqgaEabB7KjAQ==
=MoBW
-----END PGP SIGNATURE-----

--QlZnPjQKW2A7ewdg9nT6RJ1NVjmKsCze5--
