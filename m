Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:34947 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab3B0Pzc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 10:55:32 -0500
Received: by mail-la0-f52.google.com with SMTP id fs12so737550lab.11
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 07:55:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130211125718.GN12339@twin.jikos.cz>
References: <CAFhuFEcT=2rNA0dkyKjeEExOX5dMJt04hkgEr1QGgq8M74UYsg@mail.gmail.com>
	<CAFhuFEff9KV1QFE8geEw__jRAcjnBEbTkG9p6S6v0xMsf7G=Vg@mail.gmail.com>
	<CAFhuFEeZqu_t0geQSi-8sfGnwvxaJYqvVx9izvpb4UdGS8Zt-g@mail.gmail.com>
	<CAFhuFEeKTSZEr-Hy_1wj0GwKTP29SgG1sQr4Et7icBeRqh8CMQ@mail.gmail.com>
	<20130211125718.GN12339@twin.jikos.cz>
Date: Wed, 27 Feb 2013 21:25:27 +0530
Message-ID: <CAFhuFEfg46bfK8NQ+b6TKQZ137GOCFoaqu9AJXKm720cngj_Hg@mail.gmail.com>
Subject: Re: Diff using send-receive code
From: nafisa mandliwala <nafisa.mandliwala@gmail.com>
To: dsterba@suse.cz
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sir,
      Our implementation differs from that of Mark's. According to
Mark- "send works quite nicely except that it always reads changed
file data from disk and puts it in the stream - snapper doesn't want
this overhead and would prefer to produce the changed data itself."
Thus, the first patch by Mark (BTRFS_SEND_FLAG_NO_FILE_DATA), I
believe, is specific to Snapper.

      We haven't altered the kernel-side but have used it as it is and
re-written the receive-side code to generate a diff. Please provide us
with a feedback on this.

Thanks!


On Feb 11, 2013 6:27 PM, "David Sterba" <dsterba@suse.cz> wrote:
>
> On Sun, Feb 10, 2013 at 10:21:31PM +0530, nafisa mandliwala wrote:
> > Hello,
> >         We're a team of 4 final year computer science students and are
> > working on generating a diff between file system snapshots using the
> > send receive code.
>
> Looks like a duplicated effort. Did you see Mark's initial proposal
> https://patchwork.kernel.org/patch/1921821/
>
> and the latest version
>
> https://patchwork.kernel.org/patch/2069961/
>
> ?
>
> Do you build on top of these patches or have your own kernel-side
> implementation?
>
> david
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
