Return-Path: <SRS0=b0aI=NP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E53EEC32789
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 22:32:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB0062082D
	for <linux-btrfs@archiver.kernel.org>; Sun,  4 Nov 2018 22:32:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ewl/jpIG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB0062082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbeKEHsh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 02:48:37 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44764 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730133AbeKEHsg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2018 02:48:36 -0500
Received: by mail-qk1-f193.google.com with SMTP id n12so11715878qkh.11;
        Sun, 04 Nov 2018 14:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=8fHoRa7DbQIUBoXFN4VcZNNIcjYUUjjcPBLN4vC4STw=;
        b=Ewl/jpIG1n4ff8oHX+jyhddUWN5/60PooA7GpfCcwhLpTWhHWQHGilzypNazSbuHkF
         Sukp6d9z8tWrZfbDCoENuAYcscPZVFcwbnrsWx0Z4k7s9gIhtka8boyRQAlW/er7rDJR
         7RN5uPc/gdm5bLlPNPshTGNsLuCCSYOobP0lahf+vfHIS7Nlz5aSPwsmLrZk1ejUwKFb
         njgz/YIOxlJT5FzUIktwedeYHCCN6OBckbPfUZ++D/djTJj3xT4mRHoPQZTjN/VIx6RQ
         L2iDsBva7dX/ce8RqY742ykMUfvTBX5Fo4qwENYFVtaOWzCPYFaVeLEJXwSkxioTgHpY
         abxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc:content-transfer-encoding;
        bh=8fHoRa7DbQIUBoXFN4VcZNNIcjYUUjjcPBLN4vC4STw=;
        b=PDP7yPskP7JrEc1B0nZ7TsDi2q/jAO0D2UER6YYA85MiWKAtT3/Cs+Z97n92z0hocn
         a3aCsImSLTfG163E690VWggC2A+jH88/OLG7k4ONoQR0Uno4i+NYJhP9iKSyCfaNVVy8
         jJtRZnzwqMWiZRkQil4OXYgYRxF0GQAPdN3SzCEe/CS3zmKI3TvjxkSTQRDZXCtwi3xy
         FJPkVjNwnmARpMmQ9RKW785Ey/Sr3ilJQCz8Hio5q4/GQyUDUR8dlkyB9jpJyDuJj0cH
         6FZMkOPldVJ/StnzVBggJIypVfNtQ4yNwP3DaaeLGepnGKcvszfK0WuXh+CPRTXwxw3I
         xgvg==
X-Gm-Message-State: AGRZ1gKyFx6b2M002vYuzDavs4ucJQcDd8eAuah5WABhlDeSaXtUWJ21
        hHAE8lxU7RpifjoR0ubt55NYrEw0vEjw9u4S2+8=
X-Google-Smtp-Source: AJdET5fXcosFhzQJVReSINRkL3zwm6TKYysOggK2EFuRYowpqQu/KF3zTpVc+i6XWP6GAtbqmNak3xOa42HCF0T9ors=
X-Received: by 2002:a0c:e202:: with SMTP id q2mr18534162qvl.180.1541370724305;
 Sun, 04 Nov 2018 14:32:04 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a0c:9881:0:0:0:0:0 with HTTP; Sun, 4 Nov 2018 14:32:03 -0800 (PST)
In-Reply-To: <87d4e8ce-2142-9d6e-498a-c7e5b83964eb@suse.de>
References: <20181103153941.1881966-1-arnd@arndb.de> <87d4e8ce-2142-9d6e-498a-c7e5b83964eb@suse.de>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sun, 4 Nov 2018 23:32:03 +0100
X-Google-Sender-Auth: 62GQOsehs3uwRP5vS6zQMvWltis
Message-ID: <CAK8P3a27sNTiKV--smXd1wUzkGY70uUhS1rif6tgUobE+YYcbw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: avoid link error with CONFIG_NO_AUTO_INLINE
To:     Qu Wenruo <wqu@suse.de>
Cc:     Chris Mason <clm@fb.com>, David Sterba <DSterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Gu Jinxiang <gujx@cn.fujitsu.com>,
        Changbin Du <changbin.du@gmail.com>,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>,
        Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 11/4/18, Qu Wenruo <wqu@suse.de> wrote:
>
>
> On 2018/11/3 =E4=B8=8B=E5=8D=8811:39, Arnd Bergmann wrote:
>> On 32-bit ARM with gcc-8, I see a link error with the addition of the
>> CONFIG_NO_AUTO_INLINE option:
>>
>> fs/btrfs/super.o: In function `btrfs_statfs':
>> super.c:(.text+0x67b8): undefined reference to `__aeabi_uldivmod'
>> super.c:(.text+0x67fc): undefined reference to `__aeabi_uldivmod'
>> super.c:(.text+0x6858): undefined reference to `__aeabi_uldivmod'
>> super.c:(.text+0x6920): undefined reference to `__aeabi_uldivmod'
>> super.c:(.text+0x693c): undefined reference to `__aeabi_uldivmod'
>> fs/btrfs/super.o:super.c:(.text+0x6958): more undefined references to
>> `__aeabi_uldivmod' follow
>>
>> So far this is the only file that shows the behavior, so I'd propose
>> to just work around it by marking the functions as 'static inline'
>> that normally get inlined here.
>
> As a workaround it looks OK, but it's definitely not the root cause.
>
>>
>> The reference to __aeabi_uldivmod comes from a div_u64() which has an
>> optimization for a constant division that uses a straight '/' operator
>> when the result should be known to the compiler. My interpretation is
>> that as we turn off inlining, gcc still expects the result to be constan=
t
>> but fails to use that constant value.
>
> It looks more like a bug in div_u64() optimization.
>
> Despite this file in btrfs, did you hit the same problem for any other
> file?

Not this time. I've done a creduce on the file and got to this code

struct kstatfs {
  u64 f_bfree;
};
btrfs_calc_avail_data_space(p1) {}
btrfs_statfs(struct kstatfs *p1) {
  u64 d =3D 0;
  unsigned e =3D 1;
  for (; a;)
    e =3D btrfs_bg_type_to_factor();
  p1->f_bfree =3D div_u64(0, e) >> c;
  __asm__("");
  div_u64(d, e);
  b =3D btrfs_calc_avail_data_space(&d);
}

Looking at the assembler code produced by this, it seems to be
the same thing that we dealt with in
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D72785

>> Cc: Changbin Du <changbin.du@gmail.com>
>> Fixes: 943b8435c3bd ("kernel hacking: add a config option to disable
>> compiler auto-inlining")
>
> I can't find it in the mainline kernel, is the commit hash correct?
> If not merged, we should still has a chance to further polish that patch.

It's in linux-next.

       Arnd
