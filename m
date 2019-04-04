Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8470CC4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 00:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48A092133D
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 00:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbfDDA4W (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 Apr 2019 20:56:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:34684 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726099AbfDDA4V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 Apr 2019 20:56:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EA1E8AE08
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2019 00:56:19 +0000 (UTC)
Subject: Re: [PATCH v2] btrfs: trace: Introduce trace events for sleepable
 tree lock
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190402094554.8353-1-wqu@suse.com>
 <20190403154354.GR29086@twin.jikos.cz>
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
Message-ID: <e0039845-e4c5-6fbb-ca6c-60d036c67086@suse.de>
Date:   Thu, 4 Apr 2019 08:56:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190403154354.GR29086@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="6gLEKluDYLivJFesprEIKUPYjC0Yl8wu2"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6gLEKluDYLivJFesprEIKUPYjC0Yl8wu2
Content-Type: multipart/mixed; boundary="tC1VBYJLbiQ623T1nO5I2kNbCtkPCyWwM";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <e0039845-e4c5-6fbb-ca6c-60d036c67086@suse.de>
Subject: Re: [PATCH v2] btrfs: trace: Introduce trace events for sleepable
 tree lock
References: <20190402094554.8353-1-wqu@suse.com>
 <20190403154354.GR29086@twin.jikos.cz>
In-Reply-To: <20190403154354.GR29086@twin.jikos.cz>

--tC1VBYJLbiQ623T1nO5I2kNbCtkPCyWwM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/3 =E4=B8=8B=E5=8D=8811:43, David Sterba wrote:
> On Tue, Apr 02, 2019 at 05:45:54PM +0800, Qu Wenruo wrote:
>> There are two tree lock events which can sleep:
>> - btrfs_tree_read_lock()
>> - btrfs_tree_lock()
>>
>> Sometimes we may need to look into the concurrency picture of the fs.
>> For that case, we need the execution time of above two functions and t=
he
>> owner of @eb.
>>
>> Here we introduce a trace events for user space tools like bcc, to get=

>> the execution time of above two functions, and get detailed owner info=

>> where eBPF code can't.
>>
>> All the overhead is hidden behind the trace events, so if events are n=
ot
>> enabled, there is no overhead.
>>
>> Also, since this patch and later user space tool only cares about the
>> execution time and owner, other info like bytenr is ignored in this
>> events.
>=20
> The time is definetelly the interesting part here, I'm thinking if the
> block number could also provide some useful hints. The gathered trace
> data can be used to group by blocks to compare the times, or see the
> histogram of times.
>=20
> The block at minimum would be useful and I don't want to add more
> information there, like level or nritems. In case we do want that
> information, a heavier tracepoint version should be added with all the
> other data.

The block number is not that useful in current form.
As a block number can be the same while contains data for different
trees between different transactions.

That's the reason why owner makes more sense in this situation.

To make block number makes sense, we need to pair
trace_btrfs_tree_lock() with trace_btrfs_tree_unlock().


>=20
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
[snip]
>> +	),
>> +
>> +	TP_printk_btrfs("start_ns=3D%llu end_ns=3D%llu owner=3D%llu is_log_t=
ree=3D%d",
>> +		__entry->start_ns, __entry->end_ns, __entry->owner,
>> +		__entry->is_log_tree)
>=20
> I think the delta between start_ns and end_ns should be printed too, so=

> it's obvious without further processing:

My idea is to put that processing part into user space.
So we can reduce the space usage of the event buffer.

But it will do no harm anyway, so I'll add the output.

Thanks,
Qu

>=20
> 	TP_printk_btrfs("start_ns=3D%llu end_ns=3D%llu diff=3D%llu owner=3D%ll=
u is_log_tree=3D%d",
>=20


--tC1VBYJLbiQ623T1nO5I2kNbCtkPCyWwM--

--6gLEKluDYLivJFesprEIKUPYjC0Yl8wu2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlylVi8ACgkQwj2R86El
/qi47ggAo3RK5K8BqDhPlZBNb/QUYxZ3svQdCdRjjivX2bjxn7a9FTgCuPpH6F57
uchbBK5oj0R3O/CHHrcQ5iAfNuWYJDnSRdZoFCSad6Zxx55h0021EXjv5707HuH7
8OqrHke8qo6HiwjpeenM3JE2V2LWBuphpzGlM7KIVRiY8zaf+90R8ym3ttyl1oTt
f/CDdHlGCsar05gNbZP9YZl4XSNfLKuPHQODxWDpAygGDZwiFLp+4OLNDhPL0WcX
HZcjiuPsO3WgOSy6Ia9AEBWaZ6mnhHaardXQQzbd1OJZwYARArlfcng+xUAfKkFU
lpfe73CDoDg1QHkvcHVQAXuO7V1qtA==
=r4lf
-----END PGP SIGNATURE-----

--6gLEKluDYLivJFesprEIKUPYjC0Yl8wu2--
