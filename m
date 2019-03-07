Return-Path: <SRS0=nVQC=RK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B6B9C43381
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 14:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C794D20835
	for <linux-btrfs@archiver.kernel.org>; Thu,  7 Mar 2019 14:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbfCGOTH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 7 Mar 2019 09:19:07 -0500
Received: from mout.gmx.net ([212.227.15.19]:42949 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbfCGOTH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Mar 2019 09:19:07 -0500
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MRoyH-1hUFYF3hWL-00Sx36; Thu, 07
 Mar 2019 15:18:56 +0100
Subject: Re: [PATCH RFC 0/3] btrfs: Performance profiler support
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <20190306061907.29685-1-wqu@suse.com>
 <20190307140223.GH31119@twin.jikos.cz>
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
Message-ID: <ccf67c41-752a-6812-0de7-34f39c37ecac@gmx.com>
Date:   Thu, 7 Mar 2019 22:18:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190307140223.GH31119@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="9admczCrZXQYsWFnlc7unTAkQqLQmNERO"
X-Provags-ID: V03:K1:SDHec7epqnCRrJDeqWT+rKfXCRVFkLV+lvYgLZpES4ulM7+67nv
 8+xcM2GseoClFxwGi6AtFPck0AmHdi/C7HUAk/Xyt//mWtHiLjkdO7UsaKtINoLrvv3Bmnk
 DZ1KjDZCuI/1fgEItuHVBg1NW9iJLtnjqZXQF4vaBVdz8zSpwqt+4/G0oy9LNN+MwDlK7Rn
 XHzlMWL+jOKvkXxzqvdNw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Dv356rsO3Cc=:0c8/jfkT9heDESu60Ls162
 MdVqf9QButN2slaUrXIXiTgMTEDja0XGIWcDd2ygqoZAjA8TAr3Rk4uMEDHNwlzaZ/9AsfibE
 rvlJz/aLlNTasEGHpz8mqv341R7hSSfWWRciOceKczHifCKFG7pBYsA97NKrOXW//KsYw4Uy6
 4rYOmp22duwyKA5cpzubCaNn06futW/lvyuYLe9ced/9KhitSOIft9fkVw0qbEBh8NdxwY1TB
 jIFoOhv/EICYN9gFn/Ve8jsyN65r+GqI3f9wGdlItuqsOPVHzZBCdCCaqgqS6qa5bqruIHXVn
 Tjh/l0BSvDYv4a9+P752jgEfB8bJYneiVeS/+erXWOVFtqkYh8eapz+g4rrRsGpmrvWS3ireI
 OzZjGZLKJh4IlUP6Kxee/MS588WkBuYdEp55LRaAw17knocLMpulyLLTRfRIALFO5AMEYqbyN
 byNnGyYkLjkPdMOJ30x/23mT0uQyJ9rouN78oq7JJwYrtLyuLH2WvCPfm9rF6mKbbruntgfSo
 loYDvOxbtaPLVkxZ6WMTR5dPQh5mBkWeXOOAUvSOIeXd0clQz8phRfa3v4TKs9jLOETm8rh9/
 00qO8ZjLKRGPSkZtW3aKSoUIZAmUyV9pLtrpsCTKtKi3Mk83vZMv7bjqzGkVsJiUWJYl48vj0
 LAfJ0agGOIzqSSO0NXKwaO0nOvshjsPnUtU7JbrvQU1HOUscGpxbhr29+RmUj4xCfTZAtOvPj
 Ka4KxFjO7X9ym8W0yOwYR3Gn04EYFByiOvcyCGd93qgQr8qObZBzB734B62fOy9P3RPFUueKQ
 rJJLJVpLbLn4G7o5vFJLNUM09RFcfYABKm1IBl8aS5p2CV4cPowQ0OlSMcZtNKQkaON6SCZk/
 9UacgmcfD4qFJ97OvlWARQnCLxHKtVyYJf5uH9j7/5YjKZ4GnHLI7gcxGXeYPp
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9admczCrZXQYsWFnlc7unTAkQqLQmNERO
Content-Type: multipart/mixed; boundary="KEZOQGrqHSNxk9QW8Tb0HfEHsTTcbmmZG";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
 linux-perf-users@vger.kernel.org
Message-ID: <ccf67c41-752a-6812-0de7-34f39c37ecac@gmx.com>
Subject: Re: [PATCH RFC 0/3] btrfs: Performance profiler support
References: <20190306061907.29685-1-wqu@suse.com>
 <20190307140223.GH31119@twin.jikos.cz>
In-Reply-To: <20190307140223.GH31119@twin.jikos.cz>

--KEZOQGrqHSNxk9QW8Tb0HfEHsTTcbmmZG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/3/7 =E4=B8=8B=E5=8D=8810:02, David Sterba wrote:
> On Wed, Mar 06, 2019 at 02:19:04PM +0800, Qu Wenruo wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/linux/tree/perf_tree_lock
>> Which is based on v5.0-rc7 tag.
>>
>> Although we have ftrace/perf to do various performance analyse, under =
most
>> case the granularity is too small, resulting data flood for users.
>>
>> This RFC patchset provides a btrfs specific performance profiler.
>> It calculates certain function duration and account the duration.
>>
>> The result is provided through RO sysfs interface,
>> /sys/fs/btrfs/<FSID>/profiler.
>>
>> The content of that file is genreated when read.
>> Users can have full control on the sample resolution.
>>
>> The example content can be found in the last patch.
>>
>> One example using the interface to profile fsstress can be found here:=

>> https://docs.google.com/spreadsheets/d/1BVng8hqyyxFWPQF_1N0cpwiCA6R3SX=
tDTHmRqo8qyvo/edit?usp=3Dsharing
>>
>> The test script can be found here:
>> https://gist.github.com/adam900710/ca47b9a8d4b8db7168b261b6fba71ff1
>>
>> The interesting result from the graph is:
>> - Concurrency on fs tree is only high for the initial 25 seconds
>>   My initial expectation is, the hotness on fs tree should be more or
>>   less stable. Which looks pretty interesting
>>
>> - Then extent tree get more concurrency after 25 seconds
>>   This again breaks my expectation. As write to extent tree should onl=
y
>>   be triggered by delayed ref. So there is something interesting here
>>   too.
>>
>> - Root tree is pretty cold
>>   Since the test is only happening on fs tree, it's expected to be les=
s
>>   racy.
>>  =20
>> - There is some minor load on other trees.
>>   My guess is, that's from csum tree.
>>
>> Although the patchset is relatively small, there are some design point=
s
>> need extra commends before the patchset get larger and larger.
>>
>> - How should this profiler get enabled?
>>   Should this feature get enabled by mount option or kernel config?
>>   Or just let it run for all kernel build?
>>   Currently the overhead should be pretty small, but the overhead shou=
ld
>>   be larger and larger with new telemetry.
>>
>> - Design of the interface
>>   Is this a valid usage of sysfs or an abuse?
>>   And if the content can be improved for both human or program?
>=20
> Well, most of that is answered by 'figure out how to use tracepoints an=
d
> perf for that'.
>=20
> If there were not a whole substystem, actively maintained and
> documented, implementing something like that might help, but that's not=

> the case.
>=20
> I see what you were able to understand from the results, but it's more
> like a custom analysis tool that should not merged as-is. It brings a
> whole new interface and that's always hard to get right with all the
> mistakes ahead that somebody has probably solved already.
>=20
> It would be good to have list of the limitations of perf you see, and w=
e
> can find a solution ourselves or ask elsewhere.

Add linux-perf-users mail list.

I should mention the problem of ftrace (or my perf skill) in cover letter=
=2E

The biggest problem is the conflicts between detailed function execution
duration and classification.

For tree lock case, indeed we can use function graph to get execution
duration of btrfs_tree_read_lock() and btrfs_tree_lock().
But that's all. We can't really do much classification.

If just use trace event, with trace event added, then we can't get the
execution duration.

Even we can get both (my poor perf/ftrace skill must be blamed), it may
take some more time to get an easy graph.
We need to classify the result by eb owner, then account the execution
duration compared to the timestamp.

If perf users could provide better solution, I'm pretty willing to learn
some new tricks.
(Considering my poor perf skill is mostly from that LWN article, it
won't be a surprise for some perf black magic beating my hack).


And for the interface, that's why I send the patchset early to get some
feedback.
I'm really a bad interface designer.

Thanks,
Qu


--KEZOQGrqHSNxk9QW8Tb0HfEHsTTcbmmZG--

--9admczCrZXQYsWFnlc7unTAkQqLQmNERO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyBKEkACgkQwj2R86El
/qj5dAf+Jgr80Q/N8d6xHoze5LDdkrtOSBatd4ZJOGBS+zRs2UC91Fh2dCF39Qez
SWLrdB7BF+66jq37La6peh/cloNgdbORSmRbFMG0v84C5pLlnH6NJax5pfis2qj2
YXvbfRO9sLMqd/LjqjIHy3AsI4CukusS18sq57Dz2u5SfWqz7V//PMVMrM0nW1lZ
3jmJ7wmADF4htyqhBr4VZUZpp9BcMczy2c8Zxp+RcRy4CdfADCWaZkouCVCNRvS4
hrfOIV6QYxXbf+KyHLZOrqepZjCyc99UXv5Jv3bfN0tIC1kUEtivo+RAs/pnwAUT
D4EXSvRzycCwpKEA9cJsUJS9cvyi3Q==
=PTei
-----END PGP SIGNATURE-----

--9admczCrZXQYsWFnlc7unTAkQqLQmNERO--
