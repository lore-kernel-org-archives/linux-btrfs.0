Return-Path: <SRS0=OHkO=4B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F369EC2BA83
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 06:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C002C206D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 06:28:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="idR80a/R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729702AbgBMG2t (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 01:28:49 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52314 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgBMG2s (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Feb 2020 01:28:48 -0500
Received: by mail-wm1-f67.google.com with SMTP id p9so4866478wmc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Feb 2020 22:28:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vaBKo9Vi+2L668ibDIlgaqO6qFGJn4zyt8ZBR28Tvms=;
        b=idR80a/RHbYW7bBCs8quB9vZfBALWYQwgTrCDeMLYwkSeT5p7kn7o3WOibpMbixZsc
         RhRPZbKtBRnz64q1likfLpxh21D0kuikrxYWGirrSsYGawnO5RjVmKjZ6skMoe7cGDDC
         I79bci4XFJaeWCjzFOdSzo3dXzVTFAdoNnl5q+hZtq6zyw/jSvWK5qRjTQK+ooBNy1UB
         IiX0x0VWhsd9kXILRSxDcoJVV3WosfzJ+dq7RvdBACV42VbwSbqaqczrL2r/yv9sSz5N
         LlpCMedDE9gCNioQFuWbTlqJfFX7v/M4HOLIueUdw55MWfI4WM3IEaMjHQgppBatDlKb
         g7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vaBKo9Vi+2L668ibDIlgaqO6qFGJn4zyt8ZBR28Tvms=;
        b=ZSIZ3P21MrSyUvl8RQZV/HyZnl/qbAIkcngS/npayfIJvxIM3YmaVgi4JlLJHaILL6
         B29UT/bKvBQ9npR4ODFZG7D+SWHSz8om8PvS653ElRr/Hq923nxtTs/and/pue5EFPvo
         R/z+FgujGRt0hwfe+k0830WWCU3kpFSiWa7srHyH4CL0OarMD2PphL4NXP3JxNUvL9y7
         mGiAkBkr94eXBw4JBFeUUYRwjNCLyGbUj1ebtiTxtpcnhpiYB1Xi8RIpx4N/k1WybuXA
         qQuFGObqswk3gnCl7lWhYaD5QCJkbkcbroAE93gydsWQll7FPE3d3dNsAcm1vFbj8hKm
         N08A==
X-Gm-Message-State: APjAAAU1f9iFvPj82pDVMmndGiTTcd7A+hJTaHYUbSTuvrK1PQgKGVuu
        euDclZ0E4HSTcjkI/wx+YpyfNby0/JrFtAMkedoEkQ==
X-Google-Smtp-Source: APXvYqzWn2d9SGMLtgS2cQ9BHKz874eGvq+X3M4MCexYJbkNSn3IISIR1QCpI9eGBtJd5Z1KGfhKkENAXTebLL4IfOI=
X-Received: by 2002:a7b:c147:: with SMTP id z7mr3715772wmi.168.1581575325873;
 Wed, 12 Feb 2020 22:28:45 -0800 (PST)
MIME-Version: 1.0
References: <CAJCQCtS9Te9gRAGwin_Wjqv_3cJXVXthNa1g53zF4PbZW+k0Qg@mail.gmail.com>
 <20200213112110.7100baf2@natsu>
In-Reply-To: <20200213112110.7100baf2@natsu>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 12 Feb 2020 23:28:29 -0700
Message-ID: <CAJCQCtQewPT1oyDm3RASWpjtz+vr=2DdThdLeM_Thz-SeqEtLA@mail.gmail.com>
Subject: Re: 5.5-5.6-rc1, fstrim reports different value 1 minute later
To:     Roman Mamedov <rm@romanrm.net>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 12, 2020 at 11:21 PM Roman Mamedov <rm@romanrm.net> wrote:
>
> On Wed, 12 Feb 2020 23:08:03 -0700
> Chris Murphy <lists@colorremedies.com> wrote:
>
> > Host: kernel 5.5.3, qemu-kvm, Btrfs, backing file is raw with +C  5.6.
> > Guest: kernel 5.6.0-rc1, / is Btrfs
> >
> > Boot and login, and immediately run these commands:
> >
> > [root@localhost ~]# df -h
> > /dev/vda4        96G  4.4G   91G   5% /
> > # fstrim -v /
> > /: 91 GiB (97633062912 bytes) trimmed
> >
> > 1 minute later
> >
> > [root@localhost ~]# fstrim -v /
> > /: 3.5 GiB (3747549184 bytes) trimmed
> > [root@localhost ~]#

Reboot the VM with 5.5.3 and I get very slightly different values but
same behavior.
~]$ sudo -i
[sudo] password for hack:
[root@localhost ~]# fstrim -v /
/: 92.2 GiB (98953457664 bytes) trimmed
[root@localhost ~]# fstrim -v /
/: 3.7 GiB (3950542848 bytes) trimmed
[root@localhost ~]# exit

5 minutes later

$ sudo fstrim -v /
/: 3.4 GiB (3658797056 bytes) trimmed


> For completeness, what would be returned the 3rd time you trim?

I'm not seeing a pattern. Sometimes it's the same. Sometimes it's a
little different like above.

-- 
Chris Murphy
