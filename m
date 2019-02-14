Return-Path: <SRS0=zIgm=QV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F7BC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 08:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1439222D2
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Feb 2019 08:10:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="IZ7DBJEG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbfBNIKy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Feb 2019 03:10:54 -0500
Received: from mail-lj1-f181.google.com ([209.85.208.181]:36921 "EHLO
        mail-lj1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfBNIKy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Feb 2019 03:10:54 -0500
Received: by mail-lj1-f181.google.com with SMTP id r10-v6so4414563ljj.4
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Feb 2019 00:10:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=MUdHlQcwTDbDh9NaT0hn4cydc19ynBI6K1nyAvSf5gI=;
        b=IZ7DBJEGZAemUUJUpx8NT0KuJ4EFfG35xdysDztIRHIaARE9MNBPHIwQiGAf9a8CpA
         rFHNt3fyvngwWKE7qgzzf5GoSRywNUMsA2CnHqea8vnsKGBqwnyG35NVJeFa0Vofpiju
         GjkSrpx1CX2hZ2hbxvx5MCSEWPdome8h9t7VOHV0CEw4x4acCJAyHGz3Pw34upD4itLv
         4JEKh+bJ5THopmFWTJaCVHwBonSJzb3II5tLJlgp6XKDV5VSBFit/bwpqKrnuQNdVYLJ
         AMHNzX5mOcdbA57qul0xqnvI1djQBVBKyqKKso1k1NYTcvxFed1KBDNtyb03FGo6byHw
         q6eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=MUdHlQcwTDbDh9NaT0hn4cydc19ynBI6K1nyAvSf5gI=;
        b=FKgJoC5/SvwwwZ3bevR18ulq1iBfXtwMuuifHGa1x3DxNjMjJeuNnyV85o7dYPvHPt
         eymeqny8GjP+gGgR43RP1bBKqZKFOkD9dyOD0JFh+j+kgNKOFyw5d6th04EjVRAlkw+l
         5np+DXxoxVxfiZviEJ8IoZ091uw0NoaHtwaqK6TQmUooXKlXhySWiNruoWQOgMz+b2jo
         ttOoIsJSV8MucRWQ8b7UEIcaraMxkffbuwSt8TW656lVfl/9RyxtXfrSau3r+QOwROZ4
         a4ieSXxs0I87gpf34ijwNRR5SGfjZ2DF6nyk2lmBrUZrefWG4zjHHF120wrG8ggl3PeM
         UlAQ==
X-Gm-Message-State: AHQUAubJvPBnFLGonNgScL6MBpHBYGgcW+yBYeUPmR8fyGYRuOGyE1LM
        luPKWvtW51/xCbtDWQdnd6xdsESrsqG5b0YXD5QtEzyjAag=
X-Google-Smtp-Source: AHgI3IYwOIOHfrx6ENMBY5uV+uuhyA1NPQe7FM8EVPVPm5HH6/GQfdPqvDNlkoL7sKik9ABB7ub4Sz+UdUKq3RSBbtU=
X-Received: by 2002:a2e:a289:: with SMTP id k9-v6mr1463219lja.24.1550131852179;
 Thu, 14 Feb 2019 00:10:52 -0800 (PST)
MIME-Version: 1.0
References: <CAJCQCtRDuss2vTYCA=W6ifXOyLkD-WzSS5ytfruAbWrDOoFx2w@mail.gmail.com>
 <CAJCQCtTAiLK8rcs+MtzkSAGRwmSDvZN52XaMyemCH4O_4VQ1zQ@mail.gmail.com>
In-Reply-To: <CAJCQCtTAiLK8rcs+MtzkSAGRwmSDvZN52XaMyemCH4O_4VQ1zQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 14 Feb 2019 01:10:40 -0700
Message-ID: <CAJCQCtQE1aJuVz-5=wRJovLHzAwuvtoEYEbAyDPVQFGpPO1ndw@mail.gmail.com>
Subject: Re: circular lock warning at: btrfs_record_root_in_trans, kernel 5.0.0-0.rc4+
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 14, 2019 at 1:06 AM Chris Murphy <lists@colorremedies.com> wrote:
>
> I'm still running into this with 5.0.0-rc6 and sssd. I'm not sure what
> the issue is but it often does prevent sssd from starting up, so
> that's not good.
>
> https://bugzilla.redhat.com/show_bug.cgi?id=1677163

Actually, sssd fails without Btrfs. So in fact it might be the cause
of the lock warning for all I know.

https://pagure.io/SSSD/sssd/issue/3924

-- 
Chris Murphy
