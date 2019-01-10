Return-Path: <SRS0=+rOy=PS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24DC3C43444
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 13:59:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB843214DA
	for <linux-btrfs@archiver.kernel.org>; Thu, 10 Jan 2019 13:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfAJN7e (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 10 Jan 2019 08:59:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:42366 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727391AbfAJN7e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Jan 2019 08:59:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 67235ACBC;
        Thu, 10 Jan 2019 13:59:32 +0000 (UTC)
Subject: Re: [PATCH 2/2] fstests: btrfs: Introduce stress test for deadlock
 between snapshot delete and other read-write operations
To:     fdmanana@gmail.com, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190110061415.32045-1-wqu@suse.com>
 <20190110061415.32045-2-wqu@suse.com>
 <CAL3q7H7gG4gLWaSHhLmxR-ngT-WBPXtx1=iziwcK4iquaQ6-xw@mail.gmail.com>
 <c2306946-c239-2cfa-b397-699ee42b4190@gmx.com>
 <CAL3q7H7st9hhNhgQf-pt--LOMMvzoJU6Mz7jSrq8oUtKGzXPDg@mail.gmail.com>
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
Message-ID: <cddf660e-779a-e278-83b7-e54f010374b7@suse.de>
Date:   Thu, 10 Jan 2019 21:59:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7st9hhNhgQf-pt--LOMMvzoJU6Mz7jSrq8oUtKGzXPDg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RHvCR8uFKt4Dk9xIkAwmq85bX6JIvp3Bl"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RHvCR8uFKt4Dk9xIkAwmq85bX6JIvp3Bl
Content-Type: multipart/mixed; boundary="PzJgRRx6BgghyBkeXhGq6uI5Y8Dx81rTl";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: fdmanana@gmail.com, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: fstests <fstests@vger.kernel.org>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <cddf660e-779a-e278-83b7-e54f010374b7@suse.de>
Subject: Re: [PATCH 2/2] fstests: btrfs: Introduce stress test for deadlock
 between snapshot delete and other read-write operations
References: <20190110061415.32045-1-wqu@suse.com>
 <20190110061415.32045-2-wqu@suse.com>
 <CAL3q7H7gG4gLWaSHhLmxR-ngT-WBPXtx1=iziwcK4iquaQ6-xw@mail.gmail.com>
 <c2306946-c239-2cfa-b397-699ee42b4190@gmx.com>
 <CAL3q7H7st9hhNhgQf-pt--LOMMvzoJU6Mz7jSrq8oUtKGzXPDg@mail.gmail.com>
In-Reply-To: <CAL3q7H7st9hhNhgQf-pt--LOMMvzoJU6Mz7jSrq8oUtKGzXPDg@mail.gmail.com>

--PzJgRRx6BgghyBkeXhGq6uI5Y8Dx81rTl
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/1/10 =E4=B8=8B=E5=8D=889:53, Filipe Manana wrote:
[snip]
>>>> +# Workaround to handle killed workload with unreturned syscall
>>>> +sync
>>>
>>> I can't understand that comment, nor why the call to sync (probably
>>> most readers won't either).
>>> What do you mean by "unreturned syscall"? It hangs, blocked? Because
>>> of the deadlock? How does the sync makes it "return"?
>>
>> I mean normal "btrfs subvolume create/delete" ioctl syscalls.
>>
>>>
>>> When you say killed workload, you mean though the kill commands above=
?
>>> For all pids or just some in particular?
>>
>> For the workload, it will be a forked bash process, and then executing=

>> "btrfs" program.
>> While "btrfs subvolume create/delete" could call ioctl and fall into
>> kernel space, kill/wait for the bash process could return before the
>> ioctl returned.
>>
>> So here we try to call sync which will commit current transaction, mor=
e
>> or less wait for unfinished "btrfs" ioctls to return.
>>
>> Or should I change to the more common loop of check "btrfs" process an=
d
>> wait?
>=20
> Doing something like the following seems to be what you need:
>=20
> https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/?id=3Dd0e=
c5f5af9479137526b73b8b4f48ef028444ffc

Thanks a lot!

It's much better than my ugly workaround.

I'll update the patch to address all your comment.

Thanks,
Qu

>=20
>=20
>>
>> Thanks,
>> Qu
>>
>>>
>>>> +
>>>> +# success, all done
>>>> +echo "Silence is golden"
>>>> +
>>>> +status=3D0
>>>> +exit
>>>> diff --git a/tests/btrfs/179.out b/tests/btrfs/179.out
>>>> new file mode 100644
>>>> index 000000000000..cb9eba3d34b1
>>>> --- /dev/null
>>>> +++ b/tests/btrfs/179.out
>>>> @@ -0,0 +1,2 @@
>>>> +QA output created by 179
>>>> +Silence is golden
>>>> diff --git a/tests/btrfs/group b/tests/btrfs/group
>>>> index 04c0254aa4bf..46dd3c9523c2 100644
>>>> --- a/tests/btrfs/group
>>>> +++ b/tests/btrfs/group
>>>> @@ -181,3 +181,4 @@
>>>>  176 auto quick swap volume
>>>>  177 auto quick swap balance
>>>>  178 auto quick send
>>>> +179 auto qgroup dangerous
>>>> --
>>>> 2.20.1
>>>>
>>>
>>>
>>
>=20
>=20


--PzJgRRx6BgghyBkeXhGq6uI5Y8Dx81rTl--

--RHvCR8uFKt4Dk9xIkAwmq85bX6JIvp3Bl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlw3T8AACgkQwj2R86El
/qi3Cgf+LE9C5Kb0jM1FS8nD7eM6X4xcMXxIqVniKx/fjxnKcvBJdcR01NIBMJ/3
KMksvRd1VC5tN7VWJOwhxYEeD/hRXXL31eHD2Ae5GcrLuAFPDmN0so8dy6qTPxpV
O5qqWdItYNueYPWWAzyvIlGm2oE83LRCgPLHnB9eB3/fKaR/6RKQIzRl8lOQn/gO
6/ORKgINWaByJ8hbB1WoInYuYEdbbHHgwXSlZxGX1vQQ9uS33L+HYTUwL/uMa81u
6fnWQSyd2aRBWHd7jPoOZZX+vWbU2VieUHl7gJziKPYVtcWbwsZaCwBAnTPTUvPm
kEY+ZU4KTsn2MfBEYsV5wJMVKrhIfw==
=Acmq
-----END PGP SIGNATURE-----

--RHvCR8uFKt4Dk9xIkAwmq85bX6JIvp3Bl--
