Return-Path: <SRS0=+3PB=ST=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D1CC282DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 11:17:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B58F20821
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Apr 2019 11:17:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=brunner-ninja.20150623.gappssmtp.com header.i=@brunner-ninja.20150623.gappssmtp.com header.b="Id2aLklU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731847AbfDQLRG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Apr 2019 07:17:06 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:39581 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729578AbfDQLRG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Apr 2019 07:17:06 -0400
Received: by mail-wm1-f54.google.com with SMTP id n25so3100886wmk.4
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Apr 2019 04:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brunner-ninja.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=mTN+6jyPac1dhkioFPFz6kfKjpIx3e8a8WjwBkRXRTc=;
        b=Id2aLklUCn7Rp8Nf03rS8GW9o9lW0dgu54r+jPqiWTaeRTUaziYJCRsJIk5RcNtszy
         jF/hlHXGHZUOwxCoZKlvTrTyzOlhJ/+qld2jSx/CoV/hFiDhZz7pFVwIuHY3zy7IKpDr
         acW7QnzpAHOvj5s9JJLQuJqbGmfDr1EW1i0N/k+ANh+YhvAceL7fNah/GEWgsKEagca3
         mItIttk+DQAiNOCjgLxe8dULy1FnH/Ctzbe9rQJkXZFOc5Xx2RvBe3GupP5K/cBIUdHW
         QsmnF/YoJ//M2F7irl2zPdEuKvGPSL8yvddEPgfGX3Fd/+ludsBOtezCtxh5F8fckVcB
         zWiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=mTN+6jyPac1dhkioFPFz6kfKjpIx3e8a8WjwBkRXRTc=;
        b=NfvoB9UjTC6FjUosgP5Remel6XqUIxoytZzMszGFTo9GHScfIbNz4DfAvE9NNWkLqf
         dFYw0yYybvTR2Ck/qBvBTc7zHcpvMIaTUkLdmLc51uLJE/ehldCmEclhCoV+DCddgWkY
         MKo4f37SXwafdrzl8VueYQJgTD/UD2DXBlVzqstCJl+Q/El+Ux216V1Bi7GUexRrUfaT
         q4cpY3lEYXsUEq08AM9jQ7SiXo3hByHbTCCM02dsZWdq8C2o24Amaexd3AN2CrOR8Nv+
         Pf6uAEzmlAwvvvQl3QYOacgg+TBS38O/QiKiOZZjzaQ82qGPAN/xHVA+mDsZlUfAQ0sq
         j5jQ==
X-Gm-Message-State: APjAAAWSTDgzvDnaSCWhLGVocEX8hnrL37PUjT7GPeCGEbRiiKDFSuyT
        4Swc4gyd3PhuyqMDiB6KQLZPnJVQZ5PbMT2e7iF/1Bd1r2A=
X-Google-Smtp-Source: APXvYqwDG++xzTF44UBhGYI51CKLjXKHdYJGkxc9Uxs6J7Cz3pwIqznufnqCi4pzworcHLVYxTAeNlNUkbovUU7Isds=
X-Received: by 2002:a1c:9c97:: with SMTP id f145mr28501301wme.139.1555499824294;
 Wed, 17 Apr 2019 04:17:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAD7Y51iQMJQiTBBW9AqQ_-aJ6A4fMVEswyNwPMYnj5iAaLOXjw@mail.gmail.com>
 <CAD7Y51jD5HDjDHWNZwycYYb2UHjuao_X4bTT2ATeMiX1gOUi_w@mail.gmail.com>
 <d762e0b9-034e-9386-3ecc-ee182493a82e@gmx.com> <CAD7Y51jX2x39tLaDOL9LcBxSmGecG92-Xytku0TWsU4B5d=EcA@mail.gmail.com>
 <20190416130029.6cd174d2@natsu>
In-Reply-To: <20190416130029.6cd174d2@natsu>
From:   Daniel Brunner <daniel@brunner.ninja>
Date:   Wed, 17 Apr 2019 13:16:53 +0200
Message-ID: <CAD7Y51g4KFvA1LSFOorarxOce9vhLvX+832Djij-Eq7vA4S+Dg@mail.gmail.com>
Subject: Re: Corrupted files support needed
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi again,

the check went through,
and no errors were reported...

I tried mounting the fs again,
and suddenly all read errors disappeared!

A full copy is already running,
and after that i will nuke it from orbit.

Thank you all for the quick answers,
I do not completely understand what exactly was going wrong,
but I am confident that the files are not corrupted anymore (I checked
a few random ones).

-- Daniel

(output of the check)
# btrfs check --readonly /dev/mapper/sde-open
Opening filesystem to check...
Checking filesystem on /dev/mapper/sde-open
UUID: 26a3ef79-15ba-4041-951b-284fbbe08074
[1/7] checking root items
[2/7] checking extents
[3/7] checking free space cache
[4/7] checking fs roots
[5/7] checking only csums items (without verifying data)
[6/7] checking root refs
[7/7] checking quota groups skipped (not enabled on this FS)
found 50094867738635 bytes used, no error found
total csum bytes: 48133927932
total tree bytes: 60644540416
total fs tree bytes: 4307402752
total extent tree bytes: 1874182144
btree space waste bytes: 6642842911
file data blocks allocated: 50464303362048
 referenced 49273323020288

Am Di., 16. Apr. 2019 um 10:00 Uhr schrieb Roman Mamedov <rm@romanrm.net>:
>
> On Tue, 16 Apr 2019 09:46:39 +0200
> Daniel Brunner <daniel@brunner.ninja> wrote:
>
> > Hi,
> >
> > thanks for the quick response.
> >
> > The filesystem went read-only on its own right at the first read error.
> > I unmounted all mounts and rebooted (just to be sure).
> >
> > I ran the command you suggested with --progress
> > All output is flushed away with thousands of lines like those at the
> > end of the log paste.
> >
> > Does it make sense to let it run until the end or can I assume that 2
> > drives are bad?
> > Also I checked SMART values but they seem to be ok.
> >
> > https://0x0.st/zNg6.log
>
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
> 190 Airflow_Temperature_Cel 0x0022   047   031   040    Old_age   Always   In_the_past 53 (Min/Max 47/53 #5115)
>
> This seems to be normalized as VALUE=100-RAW_VALUE by the SMART firmware, and
> looking at the reading in WORST, indicates that some of your drives earlier
> have seen temperatures of as high as 69 C.
>
> This is insanely hot to run your drives at, I'd say to the point of "shut off
> everything ASAP via the mains breaker to avoid immediate permanent damage";
>
> Not sure if it's related to the csum errors at hand, but it very well might be.
>
> Even the current temps of 55-60 are about 15-20 degrees higher than ideal.
>
> --
> With respect,
> Roman
