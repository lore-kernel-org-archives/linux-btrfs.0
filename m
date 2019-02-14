Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B07B4C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 22:37:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7049C21B18
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 22:37:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="yh3X4qsJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503423AbfBNWhi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 17:37:38 -0500
Received: from mail-lj1-f177.google.com ([209.85.208.177]:40156 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503410AbfBNWhi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 17:37:38 -0500
Received: by mail-lj1-f177.google.com with SMTP id w6so1929743ljd.7
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2019 14:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hXG6rN+geD7WrxAcbUDt5ZXlYj+Fgo/DvrXJN8FmG7M=;
        b=yh3X4qsJcdGRx9B1gJMOA5Tm8XUqEf5Pt9cB3hh2m6aHODWCLlwVjTpRBiGgEr732R
         hUKGX1ZyrDTT/9kUqzmA58HwzoevKbDBtnLzNia1ENn9Na0G+QhRmcosh8gyds0El+aK
         cU+7LenWWhSL/xutMAOZv5k1i2EUXwol8kjQZhzJ1WAYTjLPwlY23IVkD/iVN0MRP2PJ
         /mFnwwxbQdvmz/zpgFygWMmdlAVE1q8VCiHKjw917EJuYua21dfubxyIJAeI6ekV3eVf
         h12FPwESn4PZxRgjp0Mx7AQCuULnUsnYxX+ptEj2qLQuFXnwcYDnyNSI9IFv4zgBz2Wl
         0Acg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hXG6rN+geD7WrxAcbUDt5ZXlYj+Fgo/DvrXJN8FmG7M=;
        b=DQwk2sOsk3VGEjAwG11B0KTmVff+3tMO2DqF+oWeGMRTDcW+3e5y0LlS49eFPcuAm9
         7OV+91PApkz1M3Q7xjPh6+fjJFHLtF3ju37jaxi9D0cUcDhCpwXZFtwsw39B1onSYaC7
         P7MHJXGD8aoylnIFNjZPg/cFquexyChnvvpJyrs7SyFCL9TKQU4EnGIa2LNNL0B0boMr
         Avr1DyUeHEA1pxb5gzTO0D0dLuy9Ogup8k+nhS8gNKw3A58ChSgumXe/rRWpIJ9inWUA
         caV6yGDLan+rdPjmHf5E94yk0/E+AmBrp5B4PheXR2bBbhAChPY9biOXmmUIscl2rkbS
         bxug==
X-Gm-Message-State: AHQUAuabnlOm1yXaM1yogEd4PAR8l/gX/456bKlkaurRdygLj+pMPx6J
        jYBpZtVaUSVPJhkMcJQHbWdPRrIYe8VnshEQzm6Y+3A8KVM=
X-Google-Smtp-Source: AHgI3IbrA9sNapZyPCO3cQp4RP8vRD8wSbyFvTcN0OMPItx/qdy+Mh/9Ox9DHdYc/PVORSiWVamzKq218O6zm+NkSCE=
X-Received: by 2002:a2e:a289:: with SMTP id k9-v6mr3667178lja.24.1550183855902;
 Thu, 14 Feb 2019 14:37:35 -0800 (PST)
MIME-Version: 1.0
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
In-Reply-To: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 14 Feb 2019 15:37:24 -0700
Message-ID: <CAJCQCtQnNQeGsi=K+pgq1sa9t8GQO1yMNx=UcchGs79zM46cTg@mail.gmail.com>
Subject: Re: Btrfs send with parent different size depending on source of files.
To:     =?UTF-8?Q?Andr=C3=A9_Malm?= <admin@sheepa.org>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 14, 2019 at 4:37 AM Andr=C3=A9 Malm <admin@sheepa.org> wrote:
>
> Hello,
>
> I'm not sure this is the right forum to ask on but I'll try and if its
> not I do apologize. I have also created a stack overflow question
> without success (
> https://stackoverflow.com/questions/54634703/btrfs-send-with-parent-diffe=
rent-size-depending-on-source-of-files
> ) but ill paste the question here too. Thank you.
>
> What i'm trying to achieve is sending only the diff of the parent with
> btrfs send -p
>
> Running this will produce a file 'out' with size 639 bytes, i.e only
> diff sent.
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>
> btrfs subvolume create A
> btrfs subvolume create B
> mkdir A/dir
>
> dd if=3D/dev/urandom of=3DA/dir/server.jar bs=3D1024 count=3D40K
> cp --reflink=3Dalways A/dir/server.jar B/server.jar
>
> btrfs subvolume snapshot -r A a
> btrfs subvolume snapshot -r B b
> btrfs send -p a b > out

It doesn't work this way. The snapshots a and b are not based on the
same underlying subvolume. The gist is that you would keep changing A,
and take additional snapshots of A, such as a.1 a.2 a.3, and you can
do incremental send with 'btrfs send -p a.1 a.2' which describes the
difference between those two snapshots of A at their respective
moments in time. You could also do 'btrfs send -p a.2 a.3' or even
'btrfs send -p a.1 a.3'

But as there's no relationship between snapshots a and b, I consider
it a bug/missing error handling feature, that btrfs send doesn't fail
in this case. By using -p you're claiming there is a parent-child
relationship between a and b, but there plainly isn't.

Read this:
https://btrfs.wiki.kernel.org/index.php/Incremental_Backup#Doing_it_by_hand=
.2C_step_by_step

Depending on your use case if you can describe it, might be tolerated
with some adjustments by using the -c clone option instead.

--=20
Chris Murphy
