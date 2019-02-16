Return-Path: <SRS0=6oD6=QX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F125C4151A
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 20:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CA3A21B69
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Feb 2019 20:13:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aQ2if1J2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732895AbfBPUKZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Feb 2019 15:10:25 -0500
Received: from mail-lf1-f49.google.com ([209.85.167.49]:41185 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbfBPUKZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Feb 2019 15:10:25 -0500
Received: by mail-lf1-f49.google.com with SMTP id e27so9586206lfj.8
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Feb 2019 12:10:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to;
        bh=DMM3r8QRMaPgV0XWeKSFKk2V59MVEQGOeexNJqUbHfI=;
        b=aQ2if1J2iUoVj6FM2Kv5YbJwKY9cWBbAurNbjrSpYt1r8B+F1Uh8M9uvtmwDXm0MeZ
         GnoJX2dq6FVthBKqBUqXuvOZWbce8DYFp83laSqs7rgMbwcG0TygquhO6ovE9XND306a
         TYeF/K9eOyQqM6Ioxr4A0e5ZXketMdHK9CWDUcyqRyujpFuCrKmKBspVSgLp452edpeP
         tinorJciEWOubIXrGp2cXB5s3UmesXc/WF1TAZ4hb1P+TsadruAq4x+fMXxv0rF76URS
         uCqeqoBoBuPcY6ef4lJonkKTf22X3CfO902drbSmk1idwnxChzd2ZpTBYITjCQVgcbfy
         ijXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=DMM3r8QRMaPgV0XWeKSFKk2V59MVEQGOeexNJqUbHfI=;
        b=Osc91FP4oEsX91tevTRgK1dd2qvgqsyHYqtDskTPnx+yJPzPn10tc5WKEw2h24ZzEM
         RnCpMPs/TDRPxS5EVO9Ge3C78bbrs7JgEGoko7DgmXM273hzcS1vgBKL0AsXOAR7URu+
         AzoZ0DH17JxHorrPEObqS4wYTaIsv3eQOfABG49ROkMGSqZ+xGRN5RMyBPzT98wP5Z7q
         kLqApWSZ1PPivBNCCwvwtPCmXWiwaLo6xk3x6x6OOAV2fNZeJZUSgXxljXL6kKpaBi6Z
         D9KbDYvh41YDw+sog1xp2V1G0R9dtgYCh7ug2jfVxoMhRSQ1OcmV3s46EdMYBQIAQvLp
         /2xg==
X-Gm-Message-State: AHQUAubaWEV1UBmN4KCFT+6wtx1GWTsAqCsAknrQ2L9yKKrMiz8w/IsF
        xR+18hEo/yi402g0xQA0vumuAjU7
X-Google-Smtp-Source: AHgI3Ibv268UD/txkl7/feOuiOs6qosB16laDdCGIGpschZviG9tMiGrzrF1+IuWOo5DD76zLTDppQ==
X-Received: by 2002:a19:915d:: with SMTP id y29mr9179531lfj.92.1550347822274;
        Sat, 16 Feb 2019 12:10:22 -0800 (PST)
Received: from [192.168.1.4] (109-252-90-29.nat.spd-mgts.ru. [109.252.90.29])
        by smtp.gmail.com with ESMTPSA id o191sm938099lff.30.2019.02.16.12.10.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Feb 2019 12:10:21 -0800 (PST)
Subject: Re: Btrfs send with parent different size depending on source of
 files.
To:     Remi Gauvin <remi@georgianit.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com>
 <d8a2685c-1844-fd01-de2b-00425458df2a@georgianit.com>
 <CAJCQCtRTOcCttXm_pP5nnxnfn86ApgPxSPu81ffvQGBTNPKZ+g@mail.gmail.com>
 <ee16ad81-2e27-ff71-91dc-ea25cb7da924@georgianit.com>
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
Message-ID: <90bc7ef7-e187-6612-8f31-aa311ca04aee@gmail.com>
Date:   Sat, 16 Feb 2019 23:10:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <ee16ad81-2e27-ff71-91dc-ea25cb7da924@georgianit.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="eI4IntnAPw1tVf4Ikfj98b7ulVfwTISep"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eI4IntnAPw1tVf4Ikfj98b7ulVfwTISep
Content-Type: multipart/mixed; boundary="xlPfJPo95kzRBG2j8VaPLNiMHD5mcalD0";
 protected-headers="v1"
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: Remi Gauvin <remi@georgianit.com>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <90bc7ef7-e187-6612-8f31-aa311ca04aee@gmail.com>
Subject: Re: Btrfs send with parent different size depending on source of
 files.
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com>
 <d8a2685c-1844-fd01-de2b-00425458df2a@georgianit.com>
 <CAJCQCtRTOcCttXm_pP5nnxnfn86ApgPxSPu81ffvQGBTNPKZ+g@mail.gmail.com>
 <ee16ad81-2e27-ff71-91dc-ea25cb7da924@georgianit.com>
In-Reply-To: <ee16ad81-2e27-ff71-91dc-ea25cb7da924@georgianit.com>

--xlPfJPo95kzRBG2j8VaPLNiMHD5mcalD0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

15.02.2019 21:56, Remi Gauvin =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On 2019-02-15 1:38 p.m., Chris Murphy wrote:
>>
>> Well I'd say maybe use -vvv and --no-data instead of -f and see what
>> it's doing. It sounds like the former has no payload, just difference
>> information, and the latter has a payload. I don't know why.
>>
>>
>=20
>=20
> Both have all the payload they need to re-create the subvolumes.  The
> first one correctly CoW's the file from subvolume a.. the second one
> stuffs it in the output... Why is indeed the question.
>=20

The last extent is incomplete which causes btrfs to not attempt cloning.


--xlPfJPo95kzRBG2j8VaPLNiMHD5mcalD0--

--eI4IntnAPw1tVf4Ikfj98b7ulVfwTISep
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQTsPDUXSW5c6iqbJulHosy62l33jAUCXGhuJwAKCRBHosy62l33
jL9gAJ9ebqqefi6UR/dCXXAoKbFMLb4G1wCgvboJvMhKxAPDgTjADeOJAxClJd4=
=Ix2O
-----END PGP SIGNATURE-----

--eI4IntnAPw1tVf4Ikfj98b7ulVfwTISep--
