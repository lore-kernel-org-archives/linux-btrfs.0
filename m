Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:45268 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750715AbdJTEJK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 00:09:10 -0400
Received: by mail-lf0-f48.google.com with SMTP id n69so11792946lfn.2
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 21:09:10 -0700 (PDT)
Subject: Re: SLES 11 SP4: can't mount btrfs
To: Chris Murphy <lists@colorremedies.com>,
        "Lentes, Bernd" <bernd.lentes@helmholtz-muenchen.de>
Cc: Btrfs ML <linux-btrfs@vger.kernel.org>
References: <1844960059.7648040.1508435017395.JavaMail.zimbra@helmholtz-muenchen.de>
 <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <77b2d2c6-730e-62a5-93d1-4e40b51bc131@gmail.com>
Date: Fri, 20 Oct 2017 07:09:07 +0300
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQkp2cLi=8NSHLe6WXwgqBdydAgeCO5NF=g33g8jv7qZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

19.10.2017 23:04, Chris Murphy пишет:
> Btrfs
> is not just supported by SUSE, it's the default file system.
> 

It is default choice for root starting with SLES12, not in SLES11. But
yes, it should still be supported.

I do not hold my breath though. For all I can tell transid errors are
usually fatal and if this is root, it may be easier and faster to just
reinstall.
