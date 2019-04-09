Return-Path: <SRS0=c/cW=SL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEA0C10F0E
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 13:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B9FA2084C
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Apr 2019 13:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfDINQC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:16:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:55636 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726035AbfDINQC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Apr 2019 09:16:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AC1D2B008
        for <linux-btrfs@vger.kernel.org>; Tue,  9 Apr 2019 13:16:00 +0000 (UTC)
Subject: Re: [PATCH v2] btrfs: trace: Introduce trace events for sleepable
 tree lock
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190402094554.8353-1-wqu@suse.com>
 <20190403154354.GR29086@twin.jikos.cz>
 <e0039845-e4c5-6fbb-ca6c-60d036c67086@suse.de>
 <20190408233814.GF29086@twin.jikos.cz>
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
Message-ID: <7801cbd3-1100-d28a-afe6-b6510933fde8@suse.de>
Date:   Tue, 9 Apr 2019 21:15:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190408233814.GF29086@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pgUAB3u7NXF1jUnTQVGfyxHyy0AFKCCGN"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pgUAB3u7NXF1jUnTQVGfyxHyy0AFKCCGN
Content-Type: multipart/mixed; boundary="2ndkANNRIoPfDgS1VIIvk4gJvqilfynWz";
 protected-headers="v1"
From: Qu Wenruo <wqu@suse.de>
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Message-ID: <7801cbd3-1100-d28a-afe6-b6510933fde8@suse.de>
Subject: Re: [PATCH v2] btrfs: trace: Introduce trace events for sleepable
 tree lock
References: <20190402094554.8353-1-wqu@suse.com>
 <20190403154354.GR29086@twin.jikos.cz>
 <e0039845-e4c5-6fbb-ca6c-60d036c67086@suse.de>
 <20190408233814.GF29086@twin.jikos.cz>
In-Reply-To: <20190408233814.GF29086@twin.jikos.cz>

--2ndkANNRIoPfDgS1VIIvk4gJvqilfynWz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/9 =E4=B8=8A=E5=8D=887:38, David Sterba wrote:
> On Thu, Apr 04, 2019 at 08:56:15AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2019/4/3 =E4=B8=8B=E5=8D=8811:43, David Sterba wrote:
>>> On Tue, Apr 02, 2019 at 05:45:54PM +0800, Qu Wenruo wrote:
>>>> There are two tree lock events which can sleep:
>>>> - btrfs_tree_read_lock()
>>>> - btrfs_tree_lock()
>>>>
>>>> Sometimes we may need to look into the concurrency picture of the fs=
=2E
>>>> For that case, we need the execution time of above two functions and=
 the
>>>> owner of @eb.
>>>>
>>>> Here we introduce a trace events for user space tools like bcc, to g=
et
>>>> the execution time of above two functions, and get detailed owner in=
fo
>>>> where eBPF code can't.
>>>>
>>>> All the overhead is hidden behind the trace events, so if events are=
 not
>>>> enabled, there is no overhead.
>>>>
>>>> Also, since this patch and later user space tool only cares about th=
e
>>>> execution time and owner, other info like bytenr is ignored in this
>>>> events.
>>>
>>> The time is definetelly the interesting part here, I'm thinking if th=
e
>>> block number could also provide some useful hints. The gathered trace=

>>> data can be used to group by blocks to compare the times, or see the
>>> histogram of times.
>>>
>>> The block at minimum would be useful and I don't want to add more
>>> information there, like level or nritems. In case we do want that
>>> information, a heavier tracepoint version should be added with all th=
e
>>> other data.
>>
>> The block number is not that useful in current form.
>> As a block number can be the same while contains data for different
>> trees between different transactions.
>=20
> Right, so the generation would have to be printed too, that's more than=

> I'd thought.

Generation itself already makes sense.
With tree locking it could be used as a minor indicator of transaction
locking (although still unreliable).

>=20
>> That's the reason why owner makes more sense in this situation.
>>
>> To make block number makes sense, we need to pair
>> trace_btrfs_tree_lock() with trace_btrfs_tree_unlock().
>>
>>
>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>> [snip]
>>>> +	),
>>>> +
>>>> +	TP_printk_btrfs("start_ns=3D%llu end_ns=3D%llu owner=3D%llu is_log=
_tree=3D%d",
>>>> +		__entry->start_ns, __entry->end_ns, __entry->owner,
>>>> +		__entry->is_log_tree)
>>>
>>> I think the delta between start_ns and end_ns should be printed too, =
so
>>> it's obvious without further processing:
>>
>> My idea is to put that processing part into user space.
>> So we can reduce the space usage of the event buffer.
>>
>> But it will do no harm anyway, so I'll add the output.
>=20
> Postprocessing is always an option, but the calculated value is more fo=
r
> a quick glance or simply is suitable for copy&paste of the trace log.
It won't do harm, but quick glance may not make sense for such heavy
calling trace.

Anyway, I'll add generation, block and diff_ns into the output.
Since bcc can do extra filter on the trace events, it shouldn't cause
much buffer space problem.

Thanks,
Qu


--2ndkANNRIoPfDgS1VIIvk4gJvqilfynWz--

--pgUAB3u7NXF1jUnTQVGfyxHyy0AFKCCGN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlysmwsACgkQwj2R86El
/qiYIQgAqAqEgaJi8orfN8S1mfR4jov3pk/cZ7pRHpbYfNWwh7CLZngHmnJxlmIS
yo7/fLG86uiV50jGxpuZzaK1jbP4Qhx7/SiAHZWcQ8WhJjQUaA3U9oPK/QYUoTDh
iM96FF2guH+tbcPyTCn6FYg2sTCoKHDe6dZEKeEOJ44B9gDqnAShijHfvzrxdqPa
1R7ntsJFKlY2/pjwqM3EgNCg3l7SFXJZGIGv7Z1Ian2kD5g9SYPjz1cCI/6rbxiw
3Us1DZrxjSuoPyQUCiibgfKAQY8F2bf81O5UuybbBUWR1UWiThQ0DX8Jd90YFSE2
SLhX1EBwj8s0BmtxSBI6WqBsBcHsrA==
=34CY
-----END PGP SIGNATURE-----

--pgUAB3u7NXF1jUnTQVGfyxHyy0AFKCCGN--
