Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:37423 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3JUKht (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 06:37:49 -0400
Date: Mon, 21 Oct 2013 12:37:31 +0200
From: Xavier Bassery <xavier@bartica.org>
To: david pu <pulq.ustc@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: task btrfs-transacti:1076 blocked for more than 120 seconds
Message-ID: <20131021123731.4ea7a23e@renoir.lan>
In-Reply-To: <CA+yNr1dyhC1=Rv=wuzV-YzSdEOmEEB=OLo=SJwmSMvsvhmmZ-g@mail.gmail.com>
References: <CA+yNr1dyhC1=Rv=wuzV-YzSdEOmEEB=OLo=SJwmSMvsvhmmZ-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 21 Oct 2013 16:36:41 +0800
david pu <pulq.ustc@gmail.com> wrote:

> hello,
> I'm running into btrfs-transaction hang issue with below call trace
> from dmesg[1].
> when this issue happens, all filesystem r/w access will be blocked and
> no response in terminal. I'm using Ubuntu raring(linux 3.2 kernel)
> 64bit kernel as below:
> Linux dpu-e6410 3.2.0-36-generic #57-Ubuntu SMP Tue Jan 8 21:44:52 UTC
> 2013 x86_64 x86_64 x86_64 GNU/Linux
> 
> is it a known issue? How to recover from such task hung status?

Hi David,

a simple btrfs user reply here.

I don't know if this will solve your issue at hand, but when using
btrfs it is strongly advised to run a much more recent kernel than 3.2
as found in Ubuntu precise (12.4).
The reason is that they were plenty of bug fixes related to btrfs that
you would miss by sticking to an old kernel.
Could you please try the latest 3.11 (or 3.10) kernel available?
If this doesn't fix your issue, please report back so that we can
investigate further.

Regards,
Xavier

