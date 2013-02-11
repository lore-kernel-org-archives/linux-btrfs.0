Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903Ab3BKM5T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 07:57:19 -0500
Date: Mon, 11 Feb 2013 13:57:18 +0100
From: David Sterba <dsterba@suse.cz>
To: nafisa mandliwala <nafisa.mandliwala@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Diff using send-receive code
Message-ID: <20130211125718.GN12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAFhuFEcT=2rNA0dkyKjeEExOX5dMJt04hkgEr1QGgq8M74UYsg@mail.gmail.com>
 <CAFhuFEff9KV1QFE8geEw__jRAcjnBEbTkG9p6S6v0xMsf7G=Vg@mail.gmail.com>
 <CAFhuFEeZqu_t0geQSi-8sfGnwvxaJYqvVx9izvpb4UdGS8Zt-g@mail.gmail.com>
 <CAFhuFEeKTSZEr-Hy_1wj0GwKTP29SgG1sQr4Et7icBeRqh8CMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFhuFEeKTSZEr-Hy_1wj0GwKTP29SgG1sQr4Et7icBeRqh8CMQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 10, 2013 at 10:21:31PM +0530, nafisa mandliwala wrote:
> Hello,
>         We're a team of 4 final year computer science students and are
> working on generating a diff between file system snapshots using the
> send receive code.

Looks like a duplicated effort. Did you see Mark's initial proposal
https://patchwork.kernel.org/patch/1921821/

and the latest version

https://patchwork.kernel.org/patch/2069961/

?

Do you build on top of these patches or have your own kernel-side
implementation?

david
