Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:56832 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaHVSWg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 14:22:36 -0400
Received: by mail-vc0-f176.google.com with SMTP id id10so12581033vcb.21
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Aug 2014 11:22:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53F731BC.6000200@gmail.com>
References: <CAH-HCWVMO+NO0B5i0o0gCHBy9dLjc08gcqxT7oEV5WkO2BHvMA@mail.gmail.com>
	<53F731BC.6000200@gmail.com>
Date: Fri, 22 Aug 2014 14:22:35 -0400
Message-ID: <CAGfcS_=ArzTNUGCmyhcOSL-acTgfThF5XVu_-AHVaCssmsuKkQ@mail.gmail.com>
Subject: Re: Distro vs latest kernel for BTRFS?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 22, 2014 at 8:04 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
>>
> I personally use Gentoo Unstable on all my systems, so I build all my
> kernels locally anyway, and stay pretty much in-line with the current
> stable Mainline kernel.

"Gentoo Unstable" probably means gentoo-sources, testing version,
which follows the stable kernel branch, but the most recent stable,
and not the long-term stable.  gentoo-sources stable version generally
follows the most recent longterm stable kernel (so 3.14 right now).
I'm not sure what the exact policy is, but that is my sense of it.

So, you're still running a stable kernel most likely.  If you really
want mainline then you want git-sources.  That follows the most recent
mainline I believe.  Of course, if you're following it that closely
then you probably should think about just doing a git clone and
managing it yourself, since then you can handle patches/etc more
easily.

I think the best option for somebody running btrfs is to stick with a
stable kernel branch, either the current stable or a very recent
longterm.  I wouldn't go back into 3.2 land or anything like that.

But, yes, if you had stuck with 3.14 and not gone to the current
stable then you would have missed the compress=lzo deadlock.  So, pick
your poison.  :)

Rich
