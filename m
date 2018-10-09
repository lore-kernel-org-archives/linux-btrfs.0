Return-Path: <SRS0=yGwK=MV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14BEDC43441
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 22:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 86D7121479
	for <linux-btrfs@archiver.kernel.org>; Tue,  9 Oct 2018 22:31:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="Yn8z2duC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86D7121479
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbeJJFuj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 01:50:39 -0400
Received: from mail-lf1-f52.google.com ([209.85.167.52]:34874 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbeJJFuj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 01:50:39 -0400
Received: by mail-lf1-f52.google.com with SMTP id r191-v6so2508639lff.2
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2018 15:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=NTaN9OkJApaYg/4hZP1Jz08RSALznNGRDajA5N82bZY=;
        b=Yn8z2duC5/mVPFUo54qNbfA2MYKeFdSfLjGP7fClldglcKvyIEjSIi4Li51jIqpLWq
         4kgfn/CO+uuZGad+Oi3jIJ2m/Av5eob3r/mlsuDG6pcM27dRsTveWNVycSbhO+VGu4Uy
         4gVTuXm46Q3hxcktO8f7W6C89J3iZzLTyjP60DO4NBgN+hgL8vwJUZd1S82btpaQuGyb
         KdYYL0EU35jFXrhzOCaXaH96ZWv6QpVDSDETpy5tU1Lc1FfeEuTqMNQDWSj5116dbo1z
         pq859HsiVD8nC4wQ7e3mUKioNE+l5Lhe049ovbcqCEIGRQo27VbiFTC1GpsUDTJxR4jM
         p8wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc:content-transfer-encoding;
        bh=NTaN9OkJApaYg/4hZP1Jz08RSALznNGRDajA5N82bZY=;
        b=nzFJqI73OihQjyHOtyGWRa27UKXr3tfaE/gAfzOB3w/jwX0e79g4v0MeBpPcW6R95w
         M4VuePwyub3yBGdRz3r8qGiyDm6S/x8P5GMwA+3ZzGjjkhxMyH2ot9rjJtmvsXwL+ebl
         E3UOKdwzZnpI3TVNym9DdY0idsjYvGRYV1YOoxMEBJSfGe63MyZhUIXlRsxyWC7brCQP
         kWgP/ZhpnO+Ex5Q1KsMIRkkPNvWJ1w0ecJvPqzqafGTtwsTU8vBpJQzCLvNdE5YVfvoV
         VsYI9eAn4enMF3ipEk/oKL7foNaCltyDOjETVvgCmhy9xxjI/qD9tQZC+FTF7FYQx4A5
         5Uog==
X-Gm-Message-State: ABuFfogyxU3VWB6q518U8+72eUEPMXIjrp4YdNhMlbSFl2v62fyuyUkz
        Jb9C2oSmj3ISZPgCUPrrSU/h8NZDk90jOFNajfYw3Q==
X-Google-Smtp-Source: ACcGV618U5WUBJlxFAczZ7hsMzlR17jNhMEZWpxVfq558P/ZE8ETnHEuvOoSbZ3h0jSwMJ63v6vfKn46Qip3sV94UXE=
X-Received: by 2002:a19:98c1:: with SMTP id a184-v6mr16107614lfe.94.1539124290251;
 Tue, 09 Oct 2018 15:31:30 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Tue, 9 Oct 2018 15:31:29 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <7ea431d5-2966-f0e5-9dec-882e46743a69@gmail.com>
References: <BN6PR01MB2531060A61AD3B85A93DF82CF3E70@BN6PR01MB2531.prod.exchangelabs.com>
 <CAJCQCtTAu8qrcB7cd3dKGstgSd32UjkWB5jZc5jbRJ0KXmHgRQ@mail.gmail.com> <7ea431d5-2966-f0e5-9dec-882e46743a69@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 9 Oct 2018 16:31:29 -0600
X-Google-Sender-Auth: LLW64IiFS4DraNfttL9LHl263ZA
Message-ID: <CAJCQCtRxKyBR3ZkuMEhPWtoY_UQkq1G1J-YfU_P+zBzrtQW4zw@mail.gmail.com>
Subject: Re: CoW behavior when writing same content
To:     Andrei Borzenkov <arvidjaar@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        "Gervais, Francois" <FGervais@distech-controls.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 9, 2018 at 11:25 AM, Andrei Borzenkov <arvidjaar@gmail.com> wro=
te:
> 09.10.2018 18:52, Chris Murphy =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

>>> In this case is root/big_file and snapshot/big_file still share the sam=
e data?
>>
>> You'll be left with three files. /big_file and root/big_file will
>> share extents,
>
> How comes they share extents? This requires --reflink, is it default now?

Good catch. It's not the default. I meant to write that initially only

root/big_file and snapshot/big_file have shared extents

And the shared extents are lost when snapshot/big_file is
"overwritten" by the copy into snapshot/


>> and snapshot/big_file will have its own extents. You'd
>> need to copy with --reflink for snapshot/big_file to have shared
>> extents with /big_file - or deduplicate.
>>
> This still overwrites the whole file in the sense original file content
> of "snapshot/big_file" is lost. That new content happens to be identical
> and that new content will probably be reflinked does not change the fact
> that original file is gone.

Agreed.

--=20
Chris Murphy
