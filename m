Return-Path: <SRS0=BfcD=PJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B0B2C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Jan 2019 17:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2184820657
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Jan 2019 17:27:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NOwOA/fk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbfAAR1f (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Jan 2019 12:27:35 -0500
Received: from mail-ot1-f47.google.com ([209.85.210.47]:45313 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727430AbfAAR1e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jan 2019 12:27:34 -0500
Received: by mail-ot1-f47.google.com with SMTP id 32so25178704ota.12
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Jan 2019 09:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=33DcWpD2WB9cTRR8d6Cod0hNrUQsZ2TD1gVOLXimSYk=;
        b=NOwOA/fk3JaJbpDjXYVC94f2G8jU4f7vsR3UMujKvdw41RO+5KHkOSMSzJsvqnimf8
         2Bl2be5ekEVWM8JgGQBwbTMrvskosc69X0cPghBEFoArA7+37hABrzQHG6K2K3LQ7bKv
         VMTYpFyKELBNNfnuk1tHltUmohHhTuJ7iXdkA9qWzpw4Vz+SR/lzl/8MgZGWH0LrgRi/
         XfkmtdXPsxnFHQCzGxNjQOxNB69gC6EijPHU3F4Ys5XEFtcCS+lyxJwRoq/EGahJxPYl
         /IXQFo7kotslnS3Tm8mZGIWORrt2Ny1KSY5/KQprxLo2RXRtFHlg7MARV8PsxQB6vzO0
         L56g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=33DcWpD2WB9cTRR8d6Cod0hNrUQsZ2TD1gVOLXimSYk=;
        b=gBSjVJJywFZGq4aRJD+zG6stlZeMp0Lua4UStBx8pBjJUCBH1DqPOclMWLULWjDtYY
         zmtsP+0Z83WRC3haTV+urlFuD+qG6GJYdZegCagFwCRJRfnrZk4Ow5XMM/KXOpyQCBSC
         PKZ19y++BoSWAUHnOiDAleVCvkB+3IOfiK2Z54ssVr1mgDWrDcU8hqwHCRNIe1ikgksi
         hvZ1Hjs8oVbGUN7kWfuCbjOG6B/0C1ZRS4ST4BQ3OHUpGGpzq1HB9gsTASkHBvoQ8lJC
         mPdxSJpEiGBI5TYb9/OBmYkvlTDMhq2kqEHkAdQznSFIuUyYe3ARs2UJGbO+0YoWNpYK
         gWdQ==
X-Gm-Message-State: AJcUukdGI5xcNOKU8gvphd5yHrYPHxzVZU4zekgjVcZMndnNmfEJ2yzc
        5m1RlT/o+YtNKlh7M4KWhg0v8hUaLTf/KrBYiRM=
X-Google-Smtp-Source: ALg8bN4f5FbiAwtrD6owJ/Ui+Gh3poVQsU0NdtgPPmSEkoxn3GFeS0FZQ9ilLRithYOgE6oMES6EDAl3g+o0bXsP3N4=
X-Received: by 2002:a9d:7597:: with SMTP id s23mr26800102otk.370.1546363653850;
 Tue, 01 Jan 2019 09:27:33 -0800 (PST)
MIME-Version: 1.0
References: <acf42b0d-4c38-8010-f50b-92aed2444884@gmail.com>
In-Reply-To: <acf42b0d-4c38-8010-f50b-92aed2444884@gmail.com>
From:   Timofey Titovets <nefelim4ag@gmail.com>
Date:   Tue, 1 Jan 2019 20:26:57 +0300
Message-ID: <CAGqmi741ozn5vq+Fwk9bDiuFBMCf-EOaYKgKYKr5ZwTTsULWnw@mail.gmail.com>
Subject: Re: Better data balancing over multiple devices for raid1/10 (read)
To:     Zdenek Kaspar <zkaspar82@gmail.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

=D0=B2=D1=82, 18 =D0=B4=D0=B5=D0=BA. 2018 =D0=B3. =D0=B2 19:43, Zdenek Kasp=
ar <zkaspar82@gmail.com>:
>
> Hello, regarding Wiki/Idea pool:
> Better data balancing over multiple devices for raid1/10 (read)
>
> By looking at [1] (which I currently use) and [2, 3, 4]
> is there agreement to solve this?
>
> [1] https://patchwork.kernel.org/patch/10681671/
> [2] https://patchwork.kernel.org/patch/10403299/
> [3] https://patchwork.kernel.org/patch/10403303/
> [4] https://patchwork.kernel.org/patch/10403301/
>
> TIA, Z.

I think none of that,
because moreover that patches try solve different problems from my
point of view.

[1] Just try to squeeze more iops from same hardware by simple playing arou=
nd
with some rules of queueing theory.

[2..4] Try add some duct tape to control over raid1 mirror read for
automatization and testing purposes
(i'm really prefer use sysfs knobs for that type of things).

If you try to read some mailing list conversations about above
patches, you will see
what currently we have no consensus about that solutions.
With no consensus with some majority of devs no progress will be made.

In theory that will be cool to do something similar to mdraid1, where
guys implement internal scheduling policy,
to help balance request over more complex and smart underline disk io
schedulers. That solution
can get consensus from devs POV.
But currently no one work on that, so I guess what in the near future
no agreement will be made.

--=20
Have a nice day,
Timofey.
