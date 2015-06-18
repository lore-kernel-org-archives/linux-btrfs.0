Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f44.google.com ([209.85.213.44]:32970 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbbFREPT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 00:15:19 -0400
Received: by yhpn97 with SMTP id n97so48495440yhp.0
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 21:15:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <B7F2379062E32745A8651FBDB20F64595D40C1BD@Server.waterlogic.com.au>
References: <mlpb8i$dus$1@ger.gmane.org>
	<CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>
	<55816E7B.5040905@gmail.com>
	<CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>
	<mls0gb$s7m$1@ger.gmane.org>
	<B7F2379062E32745A8651FBDB20F64595D40C1BD@Server.waterlogic.com.au>
Date: Wed, 17 Jun 2015 22:15:18 -0600
Message-ID: <CAJCQCtQNB3_y-+QQckd_chLqokUxpvrAt3e33s1xQROjzeuHBQ@mail.gmail.com>
Subject: Re: trim not working and irreparable errors from btrfsck
From: Chris Murphy <lists@colorremedies.com>
To: Paul Jones <paul@pauljones.id.au>
Cc: Christian <cdysthe@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

File a new bug at bugzilla.kernel.org describing this problem. Include
make/model of all involved SSDs, which you can get from smartctl or
hdparm. And then do a strace fstrim on the working and non-working
volumes, saving the output to separate files and attaching them to the
bug report. And then it's probably best to create a new list thread to
post the URL for the bug, since this thread is really about two
problems that may not be related.

Chris Murphy
