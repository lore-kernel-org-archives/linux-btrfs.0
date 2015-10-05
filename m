Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:37092 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbbJELkz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Oct 2015 07:40:55 -0400
Received: by igbni9 with SMTP id ni9so55032038igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Oct 2015 04:40:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56125BF3.10700@bouton.name>
References: <55F88ECC.1040604@menke.ac>
	<201510021421.09558.russell@coker.com.au>
	<560E737C.7050206@gmail.com>
	<201510031832.17802.russell@coker.com.au>
	<pan$e9b6$f764fa8a$deeffa51$be52ef68@cox.net>
	<56111598.2080403@bouton.name>
	<56125BF3.10700@bouton.name>
Date: Mon, 5 Oct 2015 07:40:54 -0400
Message-ID: <CAGfcS_nUAey=bgoQzCvhmM9MjgCTQ_fXTS7AcOvLTMT-NCsB5w@mail.gmail.com>
Subject: Re: BTRFS as image store for KVM?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Lionel Bouton <lionel-subscription@bouton.name>
Cc: Duncan <1i5t5.duncan@cox.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 5, 2015 at 7:16 AM, Lionel Bouton
<lionel-subscription@bouton.name> wrote:
> According to the bad performance -> unstable logic, md would then be the
> less stable RAID1 implementation which doesn't make sense to me.
>

The argument wasn't that bad performance meant that something was unstable.

The argument was that a lack of significant performance optimization
meant that the developers considered it unstable and not worth
investing time on optimizing.

So, the question isn't whether btrfs is or isn't faster than something
else.  the question is whether it is or isn't faster than it could be
if it were properly optimized.  That is, how does btrfs perform today
against btrfs from 20 years from now, which obviously cannot be
benchmarked today.

That said, I'm not really convinced that the developers haven't fixed
this because they feel that it would need to be redone later after
major refactoring.  I think it is more likely that there are just very
few developers working on btrfs and load-balancing on raid just
doesn't rank high on their list of interests or possibly expertise.
If any are being paid to work on btrfs then most likely their
employers don't care too much about it either.

I did find the phoronix results interesting though.  The whole driver
for "layer-violation" is that with knowledge of the filesystem you can
better optimize what you do/don't read and write, and that may be
showing here.

--
Rich
