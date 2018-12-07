Return-Path: <SRS0=lg0L=OQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 029BAC07E85
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 16:31:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5ED920837
	for <linux-btrfs@archiver.kernel.org>; Fri,  7 Dec 2018 16:31:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xx+6ql8+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5ED920837
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbeLGQbO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 7 Dec 2018 11:31:14 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40913 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbeLGQbO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Dec 2018 11:31:14 -0500
Received: by mail-wm1-f67.google.com with SMTP id q26so5090607wmf.5
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Dec 2018 08:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hloi+Zsgv5/16fq+B7uRJl9OsRaWyFHnTDOhdQSS54g=;
        b=Xx+6ql8+7nklfDCHG7q5DE3smb36/06A3aVkDG2GObjjjDQb4LnpVk9PpL0+WtbKVd
         L/KF6/MP+HS4OAZzK7ncIAaaeCU6m/t1RHodo4afuuDEx5zQphinViPHneS/vuL+e4iM
         Qa3vEm+kcKf/w+eXivWQFb2xswf6lL8vejD2WvNMzZGosiqKidX8vGNUkv1VpvfTvhYn
         UV/lLlNBhrLq/FWfOb/p33bONO4bCeWCRcUJPYCIkIw51AfWAxg0cl1L7pKeUhZr95Xv
         Es5dpy9DBawYPtAKt5IDk4r3W6vWx/ierFJP5fYD8MDFRg0x8hPsNLYLSdvlP6lv8nkL
         U3lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hloi+Zsgv5/16fq+B7uRJl9OsRaWyFHnTDOhdQSS54g=;
        b=nsqpMOk9gctHMKnoBRkAAIjNrMQ+3AP0579kmfzKhBsOA0qh6OTdQTLTl0LG4HVPHe
         CDQ5zDDHBIeDzP+q7Ny0YyzvU7Uj7IFhZ2iHMC7KVFHR6qYEwmAF59z1Uu5Ltc453Sts
         u2Bjte386IS1ws7LPVZGaDvM3UJ8hMF+qRUKxeqY/vvJg7MYOwUcVaU5eGjxxALdpcgR
         VGrrHnRQ3XPlsaxK1v3yj0QFNfq1TQgX7JBYcxrfJSh7ZoTpOed6NSproLUCOVqzzyEf
         nSByPxnmyfXhmN3sdHeZ5U/Ut9mLQtrnBjAKbeWN/dkW7w3cKDbVgD8O5ju5wKRZmCcI
         5YvA==
X-Gm-Message-State: AA+aEWYJ3YsEQ2/f01TSRuq46Z5dIAFed68Cz1aJzDzbQokbs45OHvTn
        TbxO275yybNQgbmOoF7MGv9x+Mw66D3M3fcj1X4=
X-Google-Smtp-Source: AFSGD/WBCvUGhND06H8lm8ndMzsk6rTYefbqf5Fk+INBly4SrAmPGo5sEwpfZEiSVDyl5VTJc26iH77cEjWLC7gJIdg=
X-Received: by 2002:a1c:e088:: with SMTP id x130mr2631180wmg.23.1544200272512;
 Fri, 07 Dec 2018 08:31:12 -0800 (PST)
MIME-Version: 1.0
References: <CAJkMDBxer61uXZW0aWjJP4Ks1Ax76Jt10ogPF+KiSmSnACDjYA@mail.gmail.com>
 <CAJCQCtSiYk4RMRWRoaAFchzvinQ4tq1wC_Ru9d8gJWRsebvbTw@mail.gmail.com>
 <CAJkMDByx_H3xjJmN4gO+L0pxpkd7sWLTmTxRfNjUp06r8o3E7w@mail.gmail.com> <2426b6a2-5c6e-481e-650a-e4559c7c57a1@gmail.com>
In-Reply-To: <2426b6a2-5c6e-481e-650a-e4559c7c57a1@gmail.com>
From:   Doni Crosby <doni.crosby1995@gmail.com>
Date:   Fri, 7 Dec 2018 11:31:01 -0500
Message-ID: <CAJkMDBz59mZJL5vnwd6WFUokQAXLNr_ddcHnxvRTm_cx-v-gEA@mail.gmail.com>
Subject: Re: System unable to mount partition after a power loss
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc:     lists@colorremedies.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I just looked at the VM it does not have a cache. That's the default
in proxmox to improve performance.
On Fri, Dec 7, 2018 at 7:25 AM Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
>
> On 2018-12-07 01:43, Doni Crosby wrote:
> >> This is qemu-kvm? What's the cache mode being used? It's possible the
> >> usual write guarantees are thwarted by VM caching.
> > Yes it is a proxmox host running the system so it is a qemu vm, I'm
> > unsure on the caching situation.
> On the note of QEMU and the cache mode, the only cache mode I've seen to
> actually cause issues for BTRFS volumes _inside_ a VM is 'cache=unsafe',
> but that causes problems for most filesystems, so it's probably not the
> issue here.
>
> OTOH, I've seen issues with most of the cache modes other than
> 'cache=writeback' and 'cache=writethrough' when dealing with BTRFS as
> the back-end storage on the host system, and most of the time such
> issues will manifest as both problems with the volume inside the VM
> _and_ the volume the disk images are being stored on.
