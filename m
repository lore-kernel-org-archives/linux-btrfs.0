Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70409C43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 16:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FFCA204FD
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 16:32:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PysDEPmk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FFCA204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbeKJCOQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 9 Nov 2018 21:14:16 -0500
Received: from mail-ed1-f42.google.com ([209.85.208.42]:33418 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbeKJCOQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Nov 2018 21:14:16 -0500
Received: by mail-ed1-f42.google.com with SMTP id z13-v6so2042264edz.0
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Nov 2018 08:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=31u8eSymupB5fhLj8Q80p8qT9LSM/I+yiF6NvPRyiIo=;
        b=PysDEPmkKpBq1yDvxme/aausupONsI9kQ5tJC3R+JoDjqeyks7AbvmbM0LoP7jaiHm
         Y8T/5jxdMdu8G2O3Gc2lv5Sd+irInF4F4JOqPzdf/kRQITilSPLRQYGkh6z0e9itxbmD
         zpYGVGYg+A+Rq4Tm1JSvPo5BBuyiJsdCSNKgNBxXTrJBkyv+sEQlEznh9vQUNp9vk1oW
         4Wr0NHGO95EN8AmSLXwQFw6FCM1zBJ3G1wqslyN757jM7HOIDhVuCAqwQmMAHiFW2ycK
         7KAOQvCE/s5037tVWiRipOHvlfb07fW5u8qji5/5K9DpaeZFD6APA1P+PAUqvcH7LzzE
         MvOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=31u8eSymupB5fhLj8Q80p8qT9LSM/I+yiF6NvPRyiIo=;
        b=L3P54Woyahvi3Ye+LCwuvmgIzvXVOrvpxVrFD72QSr894mbty4eR+AnilFE09zAsUi
         UeWJXAqXsViG7Z0K3Vm6xjmRVmpcPKu+HX4aSYNC7i7UWu/Ofvu1rAVp0AfoD/IRQmuW
         GUM+Y42Y7qVKF5K9MoyVnCCwlqYR9kjOW9pxhDwpm55Zs6aA+E2tJy2oP3SYQNwLxFOS
         Cfl7YSZOGd8O1rc7yxuoOJBCrWZLiKPifcfuDTaB/tgV6mBvwzdvA6zBq4Xue0FgZNZ0
         HLTGAsNSxHehm8Oc/goVa96fDdGmtHU7vfyWYgOc767u6XXp6Bz3YLadZYHNYK+yEPfm
         hLdQ==
X-Gm-Message-State: AGRZ1gJCNZ4OysKFS9BkbQ3ofd5r/H8tyqh+AwX1uA8waDxWxLRPmJ+i
        uDJcxMcNNWaUTPwtMI0fE2Q+S/+qh5I=
X-Google-Smtp-Source: AJdET5e8cUpCBrgqMq+0z7+PczoFTYB0DQ1YdjYKkIgwZmmc/swz0+XoPQEV1aBBR7jdoOiKYi5GGQ==
X-Received: by 2002:a17:906:a984:: with SMTP id jr4-v6mr2306372ejb.90.1541781174836;
        Fri, 09 Nov 2018 08:32:54 -0800 (PST)
Received: from ?IPv6:2a02:578:4009:0:724d:7bff:fe2e:5963? ([2a02:578:4009:0:724d:7bff:fe2e:5963])
        by smtp.gmail.com with ESMTPSA id x55-v6sm1971710edd.25.2018.11.09.08.32.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Nov 2018 08:32:54 -0800 (PST)
Subject: Re: Full filesystem btrfs rebalance kernel panic to read-only lock
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <f7331e12-5b8c-3ed7-ef45-e897520562cc@gmail.com>
 <53f2d525-867a-2074-0d6e-55e1b5cc4851@gmx.com>
From:   Pieter Maes <maescool@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=maescool@gmail.com; prefer-encrypt=mutual; keydata=
 xsBNBE+ljjwBCADunl07R5VLmI0jI9Zk0uXB9GvRQWQmLjSW2o1SMiU+sLC906cKeYltI2hX
 TSLLsN9TyeDMc3+1Ea0IC86+zSMXnjk/S5iVmYyFNYZXcvelW57KAQgnxTOCyvVYoT3aK45g
 PSF+YoM778raJLviwWTz6PLEjKRPJSHEQPLtikq1uDh8nybymQnhLjhzKOghscr9T9LE5pZ0
 Er0Md82jd4OzTyW5LMAcgLKBl7pyXNgszF0c5wJnHle/XDN2+cykaJ61LazE0gpoiz6fGTwS
 KdOjzZA2Ot/vs0ZUDor8L2joHybC9EnCQggBScwbM1Ypin0Xv1/m4wL5jdDoGVfhqIa9ABEB
 AAHNK1BpZXRlciBNYWVzIChNYWVzY29vbCkgPG1hZXNjb29sQGdtYWlsLmNvbT7CwHgEEwEC
 ACIFAk+ljjwCGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEIeJsZtyvy9KaxUH/1kj
 nJfBwnlIpy3nvxy0lFPuaSEKx5Tb+eFTtfGFMdJ4nGtkOUk2xd6MXLOLc6ycPJBTTTsoLG2Y
 GnLdmSWUHI54vh6HFQKfR8gF73bO+itkLTnyyemlJxrdjqnq2eA5ClmFKAJ6wPC5r2ykZD1E
 lbFamgwTBkbR2/2lkIsjz5UCKb5EhGm5L4KAiAc5JuRRTiSDfCdWOYX98Wy4wq/aH6+bGOwb
 yy/ZVfe6C8fav1/LvEYkQLeAYtvQAdH3sv1erXnIyJ5V9qkagzFQyZb/nG4PDJM1tb9Y75d6
 dOWdImwXaIGEcazN3CYOpfTuZoOgo0FaGsDOXf5s0vU8Vha//QTOwE0ET6WOPAEIAJgnB0Nf
 Q6hErlTqiwYRjvf81XLN/6EvHrmuaLdtpMxqYo/+zSjn+8MpqWQnJhpJGuIWC/CWWdLBF3xQ
 gd08hszhyFoYgWGw4DHvL8f/JsnqlrhQdScGNxPQkttsxfcNEMvmMfoOqoIG6HhYsPeBC2aq
 3/ybUyZbQb5MOWU+U4IpyswnfnD0aVx6sWOGVd6IOqgsb/LcWjVkK9O6PL7mtmnXSpVIs3wX
 /tZ6QN7+iNhGNzPrCkrHx5UqxIRegg52apJ84u8ZlSUPK52rY9dClGDCmiCEOI8mb8RgRkqk
 oP1w9rvwz7hDwao8JfrqVJZUCsX9bcJnK1ppZzyTZfA2KEsAEQEAAcLAXwQYAQIACQUCT6WO
 PAIbDAAKCRCHibGbcr8vSj7aB/44Mg71wdh+DMeQvebP+qW6Eb3bnFCxrCRL1kcPI1cGaISE
 8i7yZhP609+Qoghgl7NuQKQz3VLa4aQSqxQG+wOlAvJrH8HT/z8thmrT8u66aVpbGEVz6FGt
 ob5G63Gd9poCaTZDLBMAAUqHuYddGcnSOOy/Qnh8g88UcGWqQwULBno6VMW4kP+UIbVcnyo2
 GoV6FYH3JH6yIPKz6DBZDp+vYGJzvg2h96eS+Gx12pI8o5rbHTdZ5lsxB29lJWnOxhMDqGy4
 +hidY/pzZUUY7YLsvpW/f7k9Sh6JUfrO9xXSidpnZsmQVvsafPvozPxL5kRmn1lilnLXSGBn
 +331HKrM
Message-ID: <4273249b-ffcd-e965-ac3e-c0d5364e3993@gmail.com>
Date:   Fri, 9 Nov 2018 17:32:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <53f2d525-867a-2074-0d6e-55e1b5cc4851@gmx.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="9nbdf6q3mSDvqo2RPaMIk1TAfg97MF56X"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9nbdf6q3mSDvqo2RPaMIk1TAfg97MF56X
Content-Type: multipart/mixed; boundary="lAyTeArOjLfpwUpSW2C5J31yBCyPp1DKO";
 protected-headers="v1"
From: Pieter Maes <maescool@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <4273249b-ffcd-e965-ac3e-c0d5364e3993@gmail.com>
Subject: Re: Full filesystem btrfs rebalance kernel panic to read-only lock
References: <f7331e12-5b8c-3ed7-ef45-e897520562cc@gmail.com>
 <53f2d525-867a-2074-0d6e-55e1b5cc4851@gmx.com>
In-Reply-To: <53f2d525-867a-2074-0d6e-55e1b5cc4851@gmx.com>

--lAyTeArOjLfpwUpSW2C5J31yBCyPp1DKO
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

Op 09-11-18 om 02:21 schreef Qu Wenruo:
>
> On 2018/11/9 =E4=B8=8A=E5=8D=886:40, Pieter Maes wrote:
>> Hello,
>>
[Snip]
> Btrfs-progs could do it with some extra dirty work.
> (I purposed offline device resize idea, but didn't implement it yet)
>
> You could use this branch:
> https://github.com/adam900710/btrfs-progs/tree/dirty_fix
>
> It's a quick and dirty fix to allow "btrfs-corrupt-block -X <device>" t=
o
> extent device size to max.
>
> Please try above command to see if it solves your problem.
>
> Thanks,
> Qu
>
>
This worked! thank!s :D note had to disable and re-enable the logical
(lvm) volume, before bttrfs fi sh recognized it

Did an extra check before booting, and works like a charm now, rebalance
is running now

Kind Regards
Pieter Maes



--lAyTeArOjLfpwUpSW2C5J31yBCyPp1DKO--

--9nbdf6q3mSDvqo2RPaMIk1TAfg97MF56X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEOmnYXsOqZfbHlR3/h4mxm3K/L0oFAlvltqwACgkQh4mxm3K/
L0p2IAgAhmwLSVJNutxky8zDQhMPyPQR7HkKhZwgp4polFCg4XaurvAxoNvq5rhT
IPJRixnA1vZlBMSKGH+BhC9yCD6zvpkKP4tD41CSrq7qYFm+7dgFWjjcdQg/xdWF
2XuDdTh+1LEehXsDr1PrbqabT7hbyT6353c/gwJdYkxniUvCe2H9O6BFmSUlLmZ3
/HtWkrWV2NxAV6lYlYui7EUy9+7bxfEIoBhda0MIvp+U73vDMamIC/9ekVFaEbu5
n0UzvaKlGM0tCUSHj0fFpu2TP9WJXsg66D47SGFMxw9rr6jfMF+KMToLlmyGV0vQ
sc8q4RHsUijk66DU57jM/EJrs0/9Gw==
=QQoI
-----END PGP SIGNATURE-----

--9nbdf6q3mSDvqo2RPaMIk1TAfg97MF56X--
