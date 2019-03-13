Return-Path: <SRS0=X8lZ=RQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D9E2C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 00:56:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D56E2214AE
	for <linux-btrfs@archiver.kernel.org>; Wed, 13 Mar 2019 00:55:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="kPWP60Ju"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfCMAwW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 20:52:22 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:37184 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfCMAwW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 20:52:22 -0400
Received: by mail-lj1-f195.google.com with SMTP id a17so36128ljd.4
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2019 17:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uzDt+o42quclu1qNifUlh63j9tjt1yAzZpuNii0yoXM=;
        b=kPWP60JuJe6RKJ0cFrpi3v6v02qkAtNjBnWeBw5s7POuu7Zu9yq6IQCvNy7No7TSRh
         u08CuYlaaocXxwB01xIsXJ/7MK6yUIM0oyUmJkWdJxTAh/h13cB1t20FsAb1w9S/uA6Y
         +zhqQs9VgjjY66uGkox5rmNY0KY0t8gNaTHAwFQDJC0AxYxI8RxfcY9HpRpbwdWE353+
         jbQog0rchXzOCpKEcaDa/9KN++v5fSVWmbsVIQkx8oM31KBQ3NIniylPsisbiFj4eNig
         P4m3czH5RnbIyiEHA9iwwljSflC5EQF8zm/4s5mgTCAZgvYJ+LSaavY3Z6HB0MPPM1qN
         r8VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uzDt+o42quclu1qNifUlh63j9tjt1yAzZpuNii0yoXM=;
        b=WdwKd/emerlHGjFhGXd/P1dh6vHKAkJbp5pLtkDVZCaYp9fl0rgm+U0SUcq7wbF/Qp
         pRQ8ih1mozwQ0wv/A0nLu1BptjGqiAG9rfRhgIeE6IL6V5vbwojgoLManC76r/GfNz4/
         T8rA6IbeGp403Nqrg3x7LmViCRNpIryea6jhB3pPg1BcOLmi4cKlIGPbVkHrkAmFRVex
         BMuHgz2X0W3/BrtBvU8WuW5Iz5YciVnAFzlJ7ZewPp4Q1D2wWwUnXY2hhw37ODThRpYP
         pLinWGSInf3HD7ql7u0o1AosnVi11fYZYDoUYoOiTOjMAeAVCF5sN6/qDSar3fXfA0jn
         KbNw==
X-Gm-Message-State: APjAAAWXtVz5idVBlsMyhD8KAPxVbN+2XmhRlEGFuUbSMdKJIekgVhx7
        JjpjehzDDQugOqi1a/iSN6Ifcs2xt/xEyMhV23Oyet4/e2k=
X-Google-Smtp-Source: APXvYqwenn0+8Y4kWX/dk3JWiItA0EVakeAEHMoG8h4tvsX7SA/TkBiziUgN5WXXVGcBY7OpZJK/xzeYMPM/+A0YEJA=
X-Received: by 2002:a2e:8701:: with SMTP id m1mr21109634lji.132.1552438340204;
 Tue, 12 Mar 2019 17:52:20 -0700 (PDT)
MIME-Version: 1.0
References: <0102016972971d54-e7d79438-f177-48d2-ac42-55f162b6b63f-000000@eu-west-1.amazonses.com>
In-Reply-To: <0102016972971d54-e7d79438-f177-48d2-ac42-55f162b6b63f-000000@eu-west-1.amazonses.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 12 Mar 2019 18:52:08 -0600
Message-ID: <CAJCQCtQnXQBAN9ZwFxBytJ7GgLpA5_ziZ2+SGbiRX0ROa=e9mg@mail.gmail.com>
Subject: Re: Allow sending of rw-subvols if file system is mounted ro
To:     Martin Raiber <martin@urbackup.org>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 12, 2019 at 9:48 AM Martin Raiber <martin@urbackup.org> wrote:
>
> Hi,
>
> I know there are corner cases that probably make this difficult (such as
> remounting the file system rw while a send is in progress), but it would
> be nice if one could send all subvolumes as long as a file system is
> mounted read-only (pretend every subvol ist read-only if the file system
> is mounted read-only).
>
> Background/use case:
>
> Through no fault of btrfs, metadata got damaged, which makes a file
> system go read-only after a while and I'd like to btrfs send/receive the
> subvolumes and snapshots that are still readable to another btrfs file
> system (btrfs send/receive being the only option that does this somewhat
> efficiently). Only I cannot send the subvolumes that are not set to
> read-only prior to the file system going read-only.
> I patched the kernel and btrfs-tools (just commenting the checks out) to
> support this in my case, but it would be great if this would be possible
> without patching.

It might be sane for an offline tool, such as btrfs-tune or btrfs
rescue, to effectively allow `btrfs property set <pathtosubvolume> ro
true` which is just a single bit change to the containing node, and
also updating the checksum for that node.

But, kinda sorta what you want is built into btrfs rescue. You can
scrape data out of specific subvolumes. So, while you can't do an
incremental send/receive style recovery; you can at least get the data
out.

-- 
Chris Murphy
