Return-Path: <SRS0=BPiq=SB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12AA5C10F00
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 12:57:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D34AD20700
	for <linux-btrfs@archiver.kernel.org>; Sat, 30 Mar 2019 12:57:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UsSqqHsG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730812AbfC3M5o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 30 Mar 2019 08:57:44 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:45166 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730689AbfC3M5n (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Mar 2019 08:57:43 -0400
Received: by mail-ed1-f42.google.com with SMTP id m16so4270787edd.12;
        Sat, 30 Mar 2019 05:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=avb5RJpSu+DsINl4dBuFJjel3XcyOmoJnq6y0na1rRk=;
        b=UsSqqHsG70EmP0o3EaFsNd62Argd0maE78C3km/TgYAoadgMnaFIGc4sR++xMcY8wQ
         1jGtIU3pUnoXSt86F7dD+it8CCDGg+MRRthM0TZTJkg4s9M/blhAQkg38sJsG9KiPr8e
         uVh7eLgebDrSPDhujbuPH/v+Hfeg0uUHk12Px2RO+GwhF/Gh4vmn0BLBn2woriJC3mNi
         AzlkoPqO2G6xnufDX75t+qwf7axxdiiyCQwGvkvR8xsa1okalnn6JsuqZGJXTHQOpKzs
         9+SBkjE8yY07gh5AGiF6phZQKuTDDDxN7/KPS5KbIITjzkSnPkEE43QrZD4lNIsyejGp
         dLig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=avb5RJpSu+DsINl4dBuFJjel3XcyOmoJnq6y0na1rRk=;
        b=bQCYGjszyCy83o5DzSkME+oF11VXjIYJqmdfTERYxVYZN9HwCPZ2Znnbo2+tIgAAXt
         RHGvwoitNhiIoLmNPSvpxrCYSHSgTawezlf5hPSmDQKr1mvo+SKL+JHDRVGCywlW8i7Z
         BIbZ6k3P2UYgqI6f9nedKKQazXYIqXmn4FIr9aIat5qUPZTk0uQzXL2XJXNh7xX4zHap
         2qlHV+vWzGR3EHOh83BiTeLH00eyvmw2ScGg6uD5Uvy4zwA6l8+ENRMe7rnxvJq2ux1/
         HXOQ4jq5peGNVfc/xHPlx//iAhLni/pd0tuySnZFn6GFUIrmEvT6POGgQJijWNYYn+l/
         OGmw==
X-Gm-Message-State: APjAAAUyXlezc9oNE5zNYRIMk54yYMpkZwhXoy7MrNrrOmUBxAqqbOAV
        xa8Z81Hq4khCgdr00k2Bqh+dOyztZjWfg/6kmas=
X-Google-Smtp-Source: APXvYqxr8isl6Pt5PnAWPs0U/G9wcMgN9vHLBBP8AFdBAoAlUkY+U0D9CqVN7sCdRQwqxpOQLrmUwku5ny65oDOv7Yo=
X-Received: by 2002:a50:8ba6:: with SMTP id m35mr36727643edm.33.1553950661568;
 Sat, 30 Mar 2019 05:57:41 -0700 (PDT)
MIME-Version: 1.0
References: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
In-Reply-To: <dc1735e6-e410-e593-7059-3728eb427886@gmx.com>
From:   Supercilious Dude <supercilious.dude@gmail.com>
Date:   Sat, 30 Mar 2019 12:57:29 +0000
Message-ID: <CAGmvKk7bYkaNXGe4agwLWmM_YM7Sjfn1NjBheQ=FzcJmUkZcGg@mail.gmail.com>
Subject: Re: Is it possible that certain physical disk doesn't implement flush correctly?
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

This would give a false positive on any controller with a cache as all
requests would take 0ms until the cache is full and the controller has
to actually flush to disk. I am using an HP P841 controller in my test
system and it has a 4GB cache making every IO instant unless there are
enough of them that they can't be flushed to the disks as quickly as
they come in - the latency variation is huge depending on load.

Regards

On Sat, 30 Mar 2019 at 12:34, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
> Hi,
>
> I'm wondering if it's possible that certain physical device doesn't
> handle flush correctly.
>
> E.g. some vendor does some complex logical in their hdd controller to
> skip certain flush request (but not all, obviously) to improve performance?
>
> Do anyone see such reports?
>
> And if proves to happened before, how do we users detect such problem?
>
> Can we just check the flush time against the write before flush call?
> E.g. write X random blocks into that device, call fsync() on it, check
> the execution time. Repeat Y times, and compare the avg/std.
> And change X to 2X/4X/..., repeat above check.
>
> Thanks,
> Qu
>
>
