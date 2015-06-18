Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:36408 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbbFRETo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 00:19:44 -0400
Received: by yhan67 with SMTP id n67so48471252yha.3
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 21:19:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQNB3_y-+QQckd_chLqokUxpvrAt3e33s1xQROjzeuHBQ@mail.gmail.com>
References: <mlpb8i$dus$1@ger.gmane.org>
	<CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>
	<55816E7B.5040905@gmail.com>
	<CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>
	<mls0gb$s7m$1@ger.gmane.org>
	<B7F2379062E32745A8651FBDB20F64595D40C1BD@Server.waterlogic.com.au>
	<CAJCQCtQNB3_y-+QQckd_chLqokUxpvrAt3e33s1xQROjzeuHBQ@mail.gmail.com>
Date: Wed, 17 Jun 2015 22:19:43 -0600
Message-ID: <CAJCQCtSbrRO+DSdudSEhzxLmX1zWoUqZQSECfq2tSUvboEJy7A@mail.gmail.com>
Subject: Re: trim not working and irreparable errors from btrfsck
From: Chris Murphy <lists@colorremedies.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And you might as well just attach a full dmesg to the bug report too.
Who knows there might be something buried in there that's useful. The
cleanest approach is to reboot and then reproduce all of this with
fstrim on each volume, then capture the dmesg to a file. Then do the
strace fstrim for each volume. But a bunch of kernel message clutter
may be better than no messages at all.


Chris Murphy
