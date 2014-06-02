Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:47017 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaFBTal (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jun 2014 15:30:41 -0400
Received: by mail-oa0-f50.google.com with SMTP id i7so5108135oag.37
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jun 2014 12:30:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADVynFBKtAKUACDsmy2fmtBonkoscWSXD-WDr6RAcmxizE+5yQ@mail.gmail.com>
References: <20140601020750.0283af6c@ws> <CADVynFBKtAKUACDsmy2fmtBonkoscWSXD-WDr6RAcmxizE+5yQ@mail.gmail.com>
From: Shaun Reich <sreich@kde.org>
Date: Mon, 2 Jun 2014 15:30:01 -0400
Message-ID: <CADVynFAxdScpcnHV5tH5tEB2yp7Em64-XX53D6B=82LQGaxcAw@mail.gmail.com>
Subject: Re: superblock corruption, cannot obtain data
To: linux-btrfs@vger.kernel.org, Duncan <1i5t5.duncan@cox.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tl;dr tried nearly everything, couldn't get it to recover, gave up and
restored my old backup. I was running the newest Archlinux kernel
release.

.. Extracting data with Btrfs restore was quite useless, Btrfs find
root didn't list any object id's either, which I was unsure why. I
guess I was just unlucky or the utility got changed since all the
other people I've seen had used it.

Still have a full dd image of the disk that I'll keep for a week or
so, and a Btrfs-image, if anyone is at all interested.
