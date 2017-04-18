Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:34680 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751191AbdDREiC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Apr 2017 00:38:02 -0400
Received: by mail-yw0-f169.google.com with SMTP id k13so64461860ywk.1
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Apr 2017 21:38:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$2f715$fa21b851$469190a7$153eb3a4@cox.net>
References: <CAJCQCtTnjNqhSNa9TypsJqvnKeh6H9dKJ9VU8_CHPuzu+zNxsA@mail.gmail.com>
 <20170417180707.GA3856@lim.localdomain> <pan$2f715$fa21b851$469190a7$153eb3a4@cox.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 17 Apr 2017 22:38:01 -0600
Message-ID: <CAJCQCtT0hOhsF=XaKO-irqhSYiJGMR07B4tF26t-bBgRwB9kOw@mail.gmail.com>
Subject: Re: compressing nocow files
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To inhibit chattr +C on systemd-journald journals:

- manually remove the attribute on /var/log/journal and
/var/log/journal/<machineid>

- write an empty file:
/etc/tmpfiles.d/journal-nocow.conf


Chris Murphy
