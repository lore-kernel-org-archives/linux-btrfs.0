Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D40C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 14:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7BD720989
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 14:11:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CQ8XhY/8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7BD720989
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gelma.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbeK1BJ5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 20:09:57 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45603 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbeK1BJ5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 20:09:57 -0500
Received: by mail-pf1-f194.google.com with SMTP id g62so8414755pfd.12
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 06:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xAG+R02Q28UTnikCW6sB/0Mv9Ef/dHFGh+hBZ20GSjc=;
        b=CQ8XhY/8HnfbGOydlfOATotVo0DC3reW+nVkw8IiJ63tYK91HcGvrIAhbjIm6cBzEd
         d+46viY61sSpO4dx32U4v1tfd9Qq96785m1Xo0Hi1OeUBLxG2xueGOYxw4DJAzTEGzHv
         93fcvGyljUcCpZh6YK21mxfhFA45vg/x1eZlnu8rCRf+k9VFrMtrLc3aUCBm20/hEUk+
         cTXsWo24lUTFTLhExowvwrBVOoQ33NtISuSVXbGWcf/qhZOBrCnKaGCouX2PFL5xq6Gu
         RggtbcdsRCfaHbHv6HaH8RZgtQbW0r3jBMDb6TxpFIVRtyRNqUpoDV611VjYizLEjdnn
         Vv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=xAG+R02Q28UTnikCW6sB/0Mv9Ef/dHFGh+hBZ20GSjc=;
        b=M5g1tcOls1eVqDN9H00TvM2vMVwdewWVuHFYocJvoAQIAi3g8khpqMO9FQXLg5S0wA
         +ZmvY9dGQg+izSogUxJdz2n+yK4rLTaIrn5vsFsQPFq/o0bTeBDK243RbeD7WD1yCW5b
         NFJaQFSzps75SQHMgpKLf1kotfgLj5NkyGPS9fMostBP0PUtKrFrwhOHS1b7wAFFnkq+
         wuaVtR9aY8kMrq1UAu+TgIBbL8LjGUYRmnWKeTXshjwQzGXGwYkcrS9/gAMsEDQnuwp5
         Vl2qweSgRLYPMEU3LuluSEKFqFRFtGPSKASSjwdrTd8BgqqfFHEoEHo+bNQ9OZHrQenF
         G2cQ==
X-Gm-Message-State: AA+aEWYfRbpZLqiBVGGJtTlZoR9VjHDlF20Ar3hEuRgqnmQhHv4I8MUi
        uRbPUKzqmvK90lPXcwrdh/9nn6HZWpI=
X-Google-Smtp-Source: AFSGD/Uhvi7PQaz0/DwhuwTuT16H+wFAPMwXaUis1yiHZu+CK3zcQNW/cFyA70+YwtsUM5e2PETj0A==
X-Received: by 2002:aa7:8045:: with SMTP id y5mr1073973pfm.62.1543327913901;
        Tue, 27 Nov 2018 06:11:53 -0800 (PST)
Received: from glet ([185.197.228.4])
        by smtp.gmail.com with ESMTPSA id d69sm4728225pfg.168.2018.11.27.06.11.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 06:11:52 -0800 (PST)
Date:   Tue, 27 Nov 2018 15:11:44 +0100
From:   Andrea Gelmini <andrea.gelmini@gelma.net>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Linux-next regression?
Message-ID: <20181127141144.GA23269@glet>
References: <20181126150137.GA16029@glet>
 <845890af-0659-fbfa-c445-d6f109bd5015@gmx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <845890af-0659-fbfa-c445-d6f109bd5015@gmx.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 27, 2018 at 09:13:02AM +0800, Qu Wenruo wrote:
>=20
>=20
> On 2018/11/26 =E4=B8=8B=E5=8D=8811:01, Andrea Gelmini wrote:
> >   One question: I can completely trust the ok return status of scrub? I=
 know is made for this, but shit happens...
>=20
> No, scrub only checks csum of data and tree blocks, it doesn't ensure
> the content of tree blocks are OK.

Hi Qu,
  and thanks a lot, really. Your answers are always the best: short,
  detailed and very kind. You rock.

  I'm going to send a patch to propose to add your explanation above
  on the relative man page, if you agree.

> For comprehensive check, go "btrfs check --readonly".

  I'll do it.

  At the moment I just compared the file existance between my laptop and
  latest backup. Everything is fine.

>=20
> However I don't think it's something "btrfs check --readonly" would
> report, but some strange behavior, maybe from LVM or cryptsetup.

  Well, I'm using this setup with ext4 and xfs, on same machine, without
  troubles.
  I've got files checksummed on the backup machine, so I can be sure about
  comparing integrity.

Anyway, thanks a lot again,
Andrea

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQKTBAABCgB9FiEE6kLpNgt13W6DJUf3pDCQdfBZYPYFAlv9UJxfFIAAAAAALgAo
aXNzdWVyLWZwckBub3RhdGlvbnMub3BlbnBncC5maWZ0aGhvcnNlbWFuLm5ldEVB
NDJFOTM2MEI3NURENkU4MzI1NDdGN0E0MzA5MDc1RjA1OTYwRjYACgkQpDCQdfBZ
YPbVWhAAsVRii4d9L0cp6TFcqD9HG6IA7dB2Zn442LnzidL4d6tVUZhkE8SjOU7e
jKmSP+ebkparohhioR4ZKphqUVXvGH6va6VKHBLt6ZFvUA8z3r+tuwMSx6mdf/Nq
2BOOuDozwAR50J3M+FyxTocd7POw0Oi1AWkSqsUS41PuE3DZcmvNE0rbBhSejNe5
pfXlV77aoaN3OROUBiRvBCvzFoFv++sRqknKgMCQuxtV8V0uxL1LoMG1LXcyD/c0
OygD108Z8q+8K1s6nXfB/w4Sh5kPrM7ILDz7Q8CgQU6PBZVRFnYyzPs5D04H73Bm
85caaIdOKYBvBRocwznNbTbmYOZyAC+wlFsjFpZOl+w6xCglOerxS6CRCWu0Mvsw
Al1wYB0rZWNzYkiOrfyqivaYOJgCI4N8p3iQO7NASO6lLbrlVzZxKiX0ihBMPECo
KUyDqpz8Nsk0d800MTXaYz6COTfOAktiMVpZuAModbD46ExHAHB5DlTOj2rvn8RL
tfyMNAyn6/nIEqQTH+7g99lT42Q1ARvJ9EeQDmYXO6MeqeoGAF1lZz3kaABhhsT5
6aM/LyezeKfE7nAaS+b3PzSd1o4/iZOsAWX8ZZMe7k0uBPimmXeJvxH7DwRm1XEE
StbKFaMQSyE2PEmAnwinfpHBfWaJLCzMjCIY9PoKamMKM3v4/50=
=AiA0
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
