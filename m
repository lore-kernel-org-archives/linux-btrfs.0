Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34778 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbbDZLh7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Apr 2015 07:37:59 -0400
Received: by iget9 with SMTP id t9so53222973ige.1
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2015 04:37:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150426111943.GZ18187@carfax.org.uk>
References: <1430043165-20641-1-git-send-email-lauri.vosandi@gmail.com>
	<20150426111943.GZ18187@carfax.org.uk>
Date: Sun, 26 Apr 2015 14:37:58 +0300
Message-ID: <CAJ1pDqR6Q_cfLiKoNKReC1Rx76BkNXj3pY6_CqHeyL3J_hSf6g@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: receive explicit parent support
From: lauri <lauri.vosandi@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Lauri_V=F5sandi?= <lauri.vosandi@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> Subvol A on source side: (A, -)
> Send this to A' on target side: (A', A)
> Send this back to A'' on source side: (A'', A) <-- Note the A here, not A'

I also think your approach is the real solution to the problem, but as
some pointed out on IRC this changes the behaviour of btrfs receive
and will break things for someone. When I asked whose obscure workflow
does it break nobody could come up with any reasonable example whereas
sending snapshots back and forth seems to be the major usecase for
btrfs receive and it's impossible to for example restore snapshots
with current implementation.

I know that -p may fail horribly but the idea was to have *option* to
replace parent lookup logic and instead of relying on UUID-s simply
have it specified by userspace application.

>    More later, when I've had a little time to play with things and
> think through the semantics properly.

You want to give it a try?

-- 
Lauri Võsandi
tel: +372 53329412
e-mail: lauri.vosandi@gmail.com
blog: http://lauri.vosandi.com/
