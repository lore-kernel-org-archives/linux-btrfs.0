Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6383C43218
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:22:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2A4C206C1
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 14:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfDYOWk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 10:22:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:57436 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726176AbfDYOWk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 10:22:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 29B2FAE14
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2019 14:22:38 +0000 (UTC)
Subject: Re: [PATCH] btrfs: tree-checker: Allow error injection for
 tree-checker
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190424072253.4979-1-wqu@suse.com>
 <20190424174507.GF20156@twin.jikos.cz>
 <143ea4d1-5014-5198-8a34-8d579bef5966@suse.de>
 <20190425141334.GI20156@twin.jikos.cz>
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
Message-ID: <f4175d0f-bf0f-3a17-6ddf-603f9620f368@suse.de>
Date:   Thu, 25 Apr 2019 22:22:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190425141334.GI20156@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="X1UNCEI6FIylgZ5vU8DJl09MdXWCjMCl0"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--X1UNCEI6FIylgZ5vU8DJl09MdXWCjMCl0
Content-Type: multipart/mixed; boundary="6w1MOu20vJQdg40QCPYZSiCGhBipGf6hY";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <f4175d0f-bf0f-3a17-6ddf-603f9620f368@suse.de>
Subject: Re: [PATCH] btrfs: tree-checker: Allow error injection for
 tree-checker
References: <20190424072253.4979-1-wqu@suse.com>
 <20190424174507.GF20156@twin.jikos.cz>
 <143ea4d1-5014-5198-8a34-8d579bef5966@suse.de>
 <20190425141334.GI20156@twin.jikos.cz>
In-Reply-To: <20190425141334.GI20156@twin.jikos.cz>

--6w1MOu20vJQdg40QCPYZSiCGhBipGf6hY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/25 =E4=B8=8B=E5=8D=8810:13, David Sterba wrote:
> On Thu, Apr 25, 2019 at 08:30:38AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/4/25 =E4=B8=8A=E5=8D=881:45, David Sterba wrote:
>>> On Wed, Apr 24, 2019 at 03:22:53PM +0800, Qu Wenruo wrote:
>>>> Allowing error injection for btrfs_check_leaf_full() and
>>>> btrfs_check_node() is useful to test the failure path of btrfs write=

>>>> time tree check.
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>
>>> Does not compile:
>>>
>>>   CC [M]  fs/btrfs/tests/extent-map-tests.o
>>> In file included from fs/btrfs/tree-checker.c:18:
>>> ./include/linux/error-injection.h:15:15: error: unknown type name =E2=
=80=98bool=E2=80=99
>>>  static inline bool within_error_injection_list(unsigned long addr)
>>>                ^~~~
>>> ./include/linux/error-injection.h: In function =E2=80=98within_error_=
injection_list=E2=80=99:
>>> ./include/linux/error-injection.h:17:9: error: =E2=80=98false=E2=80=99=
 undeclared (first use in this function)
>>>   return false;
>>>          ^~~~~
>>> ./include/linux/error-injection.h:17:9: note: each undeclared identif=
ier is reported only once for each function it appears in
>>> make[1]: *** [scripts/Makefile.build:275: fs/btrfs/tree-checker.o] Er=
ror 1
>>> make[1]: *** Waiting for unfinished jobs....
>>> make: *** [Makefile:1737: fs/btrfs/] Error 2
>>
>> Compiles without problem here using 8.2.1 gcc.
>>
>> ...
>>   CC [M]  fs/btrfs/check-integrity.o
>>   CC [M]  fs/btrfs/ref-verify.o
>>   CC [M]  fs/btrfs/tests/free-space-tests.o
>>   CC [M]  fs/btrfs/tests/extent-buffer-tests.o
>>   CC [M]  fs/btrfs/tests/btrfs-tests.o
>>   CC [M]  fs/btrfs/tests/extent-io-tests.o
>>   CC [M]  fs/btrfs/tests/inode-tests.o
>>   CC [M]  fs/btrfs/tests/qgroup-tests.o
>>   CC [M]  fs/btrfs/tests/free-space-tree-tests.o
>>   CC [M]  fs/btrfs/tests/extent-map-tests.o
>>   LD [M]  fs/btrfs/btrfs.o
>>   Building modules, stage 2.
>>   MODPOST 1 modules
>>   CC      fs/btrfs/btrfs.mod.o
>>   LD [M]  fs/btrfs/btrfs.ko
>>
>>>
>>>
>>> gcc is 8.3.1
>>>
>>
>> Upgrading to gcc 8.3.0, still passes.
>>
>> Is that a regression in gcc 8.3.1?
>=20
> I don't think it's caused by compiler but config options. And the build=

> bot sees the compilation failure too, so it's not specific to my setup:=

>=20
> https://lists.01.org/pipermail/kbuild-all/2019-April/060303.html
>=20

Got it reproduced, not sure why the config could affect this problem.

But the fix is always straightforward, include types for bool and stddef
for true/false.

Thanks,
Qu



--6w1MOu20vJQdg40QCPYZSiCGhBipGf6hY--

--X1UNCEI6FIylgZ5vU8DJl09MdXWCjMCl0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlzBwqYACgkQwj2R86El
/qilqQf/Q2YoNI7cg3JMftfQBBaUxqPdEQVu/DfqcJpep2LkXkQCKkiqYwpkh5ce
8XfiLCW5a5HH04W8WiSiMXFSFKmLfoMD2KPBl2LItVGskxfVssDMj1IQy+mWWS47
MVuhyFUFHInzKMYwzNwyu++hWA+0YaoqIpTE+vLt2m5MgO71fXvBz0ztTL+gI2iz
iTKFzEkCnsWLMmPbTvv4J6m/Sw7Kx3j2T2kCarsDrrFihRCqiv4YlxAnAoAGF2L4
ETifqAarfn8Rd8Nz7MVAJu2Cn8gsy6Ys4fE3HTZFl+ftJl3IPHm7XfBSPZv5ayXV
wbDZ0akgEcHMnQK6iIpx54UhlEojhw==
=vATC
-----END PGP SIGNATURE-----

--X1UNCEI6FIylgZ5vU8DJl09MdXWCjMCl0--
