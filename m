Return-Path: <SRS0=Udpi=QT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A71AC282C4
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 18:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F86A2190B
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Feb 2019 18:43:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NlBsyAfV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731999AbfBLSnK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Feb 2019 13:43:10 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38002 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbfBLSnJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Feb 2019 13:43:09 -0500
Received: by mail-lf1-f67.google.com with SMTP id n15so2827126lfe.5
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2019 10:43:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=XpDHGYvt1L3FCqb7h/BqEskXVgQ3BkPB/+0A0fehUIA=;
        b=NlBsyAfVztFsZXpG3mxCrXrE/aYB2tmkpnKEpZ9y2oIZjL29392ZXY8B7oIie/tdif
         zoM0bK7GHeAc/ObioLuyF9BKQHbgRjsp/TztNS6XR5Sc2l+G3qY9mGQJW/I/w/D70M78
         WStXOZUMZItV/kVfRz5Go58K1cxA6qxsPp5UO3F1K3ZYr5gimWp6eccwl/BNUjORHPJ5
         RjMS+Qobn/IHbgoHwdeMSjOfZrNLaGdf6S05vah6y6HLWgqjLNzMdZXXNeKQsnyuOyxi
         TEY5mnn2EegxgP1KFRYnnpQMionkNKtkBMr+8d+JYZ2V0+j4uRiAMoBamscLaHVLjt9f
         DmZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=XpDHGYvt1L3FCqb7h/BqEskXVgQ3BkPB/+0A0fehUIA=;
        b=PTJ/8Kbk2EQzMNtjG5DHO/1uahdASea0c0wjrBjIoBmLCRBGZs/s+mDZ7RYomH8ooY
         JUjSJ6dTbxY1p/8lhznUQGiDV04VjiFXGLqe4RAbOJglCAjXSzU+OrMj7tPd3r/YtGQ6
         rQv4YK7Fn1Tr96trDPsg6g3F05mMp5fKI/BiN0trJ/r9TMn2Qwz+pT41Zq86/IiKGPk5
         xABj88PFxZ0WJV4VUF9RtCjcGeo70j8kZ6NNC7Fiv2JKGOyhMiHcASYgr9UH17oFmKnK
         jFgAwEhd7Io/qnruSWItffmK8FBgGbsxJJKzedaUZENs+RIBFrVO3texTHp6MT3xj53F
         Z9Hw==
X-Gm-Message-State: AHQUAuZzspMj7pEn9+GrgDKSOPSjC9bhK3UGEzYkS+o8RP0dMPCOIU+d
        f00Cznnck7vFHeP1wPp6z8gLF6i+Nmc=
X-Google-Smtp-Source: AHgI3IbdS9w5ws9RD3r8XsIDilh1OGMOoUPOrw8jXs3mylkqvVcIKxqN54tD24eSHCT/uCSgxy5GQw==
X-Received: by 2002:a19:c20f:: with SMTP id l15mr3225413lfc.76.1549996986589;
        Tue, 12 Feb 2019 10:43:06 -0800 (PST)
Received: from [192.168.1.4] (109-252-90-29.nat.spd-mgts.ru. [109.252.90.29])
        by smtp.gmail.com with ESMTPSA id i15sm770209ljb.48.2019.02.12.10.43.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 10:43:05 -0800 (PST)
Subject: Re: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded
 rw mount
To:     Qu Wenruo <wqu@suse.de>, Remi Gauvin <remi@georgianit.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20190212070319.30619-1-wqu@suse.com>
 <aabbd673-fdc0-77dd-7e1e-1b5d1ed12bff@georgianit.com>
 <964481b6-e761-8d0d-3ef1-cbe19dbfae9e@suse.de>
 <79f33db2-f39c-6bd6-4697-d9d9f6a704f1@georgianit.com>
 <d5ad9e15-a572-2819-c39f-43d4c0ff2832@suse.de>
From:   Andrei Borzenkov <arvidjaar@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=arvidjaar@gmail.com; prefer-encrypt=mutual; keydata=
 xsDiBDxiRwwRBAC3CN9wdwpVEqUGmSoqF8tWVIT4P/bLCSZLkinSZ2drsblKpdG7x+guxwts
 +LgI8qjf/q5Lah1TwOqzDvjHYJ1wbBauxZ03nDzSLUhD4Ms1IsqlIwyTLumQs4vcQdvLxjFs
 G70aDglgUSBogtaIEsiYZXl4X0j3L9fVstuz4/wXtwCg1cN/yv/eBC0tkcM1nsJXQrC5Ay8D
 /1aA5qPticLBpmEBxqkf0EMHuzyrFlqVw1tUjZ+Ep2LMlem8malPvfdZKEZ71W1a/XbRn8FE
 SOp0tUa5GwdoDXgEp1CJUn+WLurR0KPDf01E4j/PHHAoABgrqcOTcIVoNpv2gNiBySVsNGzF
 XTeY/Yd6vQclkqjBYONGN3r9R8bWA/0Y1j4XK61qjowRk3Iy8sBggM3PmmNRUJYgroerpcAr
 2byz6wTsb3U7OzUZ1Llgisk5Qum0RN77m3I37FXlIhCmSEY7KZVzGNW3blugLHcfw/HuCB7R
 1w5qiLWKK6eCQHL+BZwiU8hX3dtTq9d7WhRW5nsVPEaPqudQfMSi/Ux1kc0mQW5kcmVpIEJv
 cnplbmtvdiA8YXJ2aWRqYWFyQGdtYWlsLmNvbT7CZQQTEQIAJQIbAwYLCQgHAwIGFQgCCQoL
 BBYCAwECHgECF4AFAliWAiQCGQEACgkQR6LMutpd94wFGwCeNuQnMDxve/Fo3EvYIkAOn+zE
 21cAnRCQTXd1hTgcRHfpArEd/Rcb5+SczsBNBDxiRyQQBACQtME33UHfFOCApLki4kLFrIw1
 5A5asua10jm5It+hxzI9jDR9/bNEKDTKSciHnM7aRUggLwTt+6CXkMy8an+tVqGL/MvDc4/R
 KKlZxj39xP7wVXdt8y1ciY4ZqqZf3tmmSN9DlLcZJIOT82DaJZuvr7UJ7rLzBFbAUh4yRKaN
 nwADBwQAjNvMr/KBcGsV/UvxZSm/mdpvUPtcw9qmbxCrqFQoB6TmoZ7F6wp/rL3TkQ5UElPR
 gsG12+Dk9GgRhnnxTHCFgN1qTiZNX4YIFpNrd0au3W/Xko79L0c4/49ten5OrFI/psx53fhY
 vLYfkJnc62h8hiNeM6kqYa/x0BEddu92ZG7CRgQYEQIABgUCPGJHJAAKCRBHosy62l33jMhd
 AJ48P7WDvKLQQ5MKnn2D/TI337uA/gCgn5mnvm4SBctbhaSBgckRmgSxfwQ=
Message-ID: <d1093c59-f432-b2b6-ca53-e46414c945a6@gmail.com>
Date:   Tue, 12 Feb 2019 21:42:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <d5ad9e15-a572-2819-c39f-43d4c0ff2832@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="zEy18yFQblSt4UfQe5jQpNNiFdD59mZNM"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zEy18yFQblSt4UfQe5jQpNNiFdD59mZNM
Content-Type: multipart/mixed; boundary="W7DU2IssqjKCeKS0vGsIOJCswSgN4vsfD";
 protected-headers="v1"
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: Qu Wenruo <wqu@suse.de>, Remi Gauvin <remi@georgianit.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <d1093c59-f432-b2b6-ca53-e46414c945a6@gmail.com>
Subject: Re: [PATCH RFC] btrfs: Don't create SINGLE or DUP chunks for degraded
 rw mount
References: <20190212070319.30619-1-wqu@suse.com>
 <aabbd673-fdc0-77dd-7e1e-1b5d1ed12bff@georgianit.com>
 <964481b6-e761-8d0d-3ef1-cbe19dbfae9e@suse.de>
 <79f33db2-f39c-6bd6-4697-d9d9f6a704f1@georgianit.com>
 <d5ad9e15-a572-2819-c39f-43d4c0ff2832@suse.de>
In-Reply-To: <d5ad9e15-a572-2819-c39f-43d4c0ff2832@suse.de>

--W7DU2IssqjKCeKS0vGsIOJCswSgN4vsfD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

12.02.2019 10:47, Qu Wenruo =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>=20
>=20
> On 2019/2/12 =E4=B8=8B=E5=8D=883:43, Remi Gauvin wrote:
>> On 2019-02-12 2:22 a.m., Qu Wenruo wrote:
>>
>>>> Does this mean you would rely on scrub/CSUM to repair the missing da=
ta
>>>> if device is restored?
>>>
>>> Yes, just as btrfs usually does.
>>>
>>
>> I don't really understand the implications of the problems with mounti=
ng
>> fs when single/dup data chunk are allocated on raid1,
>=20
> Consider this use case:
>=20
> One btrfs with 2 devices, RAID1 for data and metadata.
>=20
> One day devid 2 got failure, and before replacement arrives, user can
> only use devid 1 alone. (Maybe that's the root fs).
>=20
> Then new disk arrived, user replaced the missing device, caused SINGLE
> or DUP chunks on devid 1, and more importantly, some metadata/data is
> already in DUP/SINGLE chunks.
>=20
> Then some days later, devid 1 get failure too, now user is unable to
> mount the fs degraded RW any more, since SINGLE/DUP chunks are all on
> devid 1, and no way to replace devid 1.
>=20

But if I understand what happens after your patch correctly, replacement
device still does not contain valid data until someone does scrub. So in
either case manual step is required to restore full redundancy.

Or does "btrfs replace" restore content on replacement device automatical=
ly?

> Thanks,
> Qu
>=20
>> but I would think
>> that would actually be a preferable situation than filling a drive wit=
h
>> 'data' we know is completely bogus... converting single/dup data to ra=
id
>> should be much faster than tripping on CSUM errors, and less prone to
>> missed errors?
>>
>>
>=20



--W7DU2IssqjKCeKS0vGsIOJCswSgN4vsfD--

--zEy18yFQblSt4UfQe5jQpNNiFdD59mZNM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTsPDUXSW5c6iqbJulHosy62l33jAUCXGMTuAAKCRBHosy62l33
jF9DAKCwu4eQm0YJOxS4/c3fN0HOnfMorACgkcJeY8JqJPQLt7Or7gbAhjdV1so=
=Rmfl
-----END PGP SIGNATURE-----

--zEy18yFQblSt4UfQe5jQpNNiFdD59mZNM--
