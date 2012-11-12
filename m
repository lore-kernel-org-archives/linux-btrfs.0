Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47452 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2KLSYd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Nov 2012 13:24:33 -0500
Received: by mail-ie0-f174.google.com with SMTP id k13so9464002iea.19
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2012 10:24:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121110083111.25d3fcef@aspire.ty-penguin.org.uk>
References: <20121110083111.25d3fcef@aspire.ty-penguin.org.uk>
Date: Mon, 12 Nov 2012 19:24:32 +0100
Message-ID: <CAB9VWqC=vO9ATucv6hEYgcAeYCdzam0ty4jovCtSoknfbkj+jQ@mail.gmail.com>
Subject: Re: Bug in a couple of btrfs-progs components
From: Alexander Block <ablock84@googlemail.com>
To: Alun <alun.btrfs@ty-penguin.org.uk>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 10, 2012 at 9:31 AM, Alun <alun.btrfs@ty-penguin.org.uk> wrote:
> Hi,
>
> (I'm not a list member and may not see any responses to this)
>
> I've been using btrfs on my Raspberry Pi. Yesterday I tried to use the
> "btrfs scrub" function and, while the scrub started OK, I couldn't run
> "btrfs scrub status" to see what was happening. Whenever I ran it, I
> just got the command help.
>
> The same command on my x86 box worked OK. Checking out the git sources,
> I found that, in a couple of places, "char c" is used to store the
> return value from getopt. On the Pi, char is unsigned, so the
> subsequent test for getopt returning -1 never succeeds.
>
> I'm attaching a patch to fix this.
>
> Cheers,
> Alun.

We should probably also use -fsigned-char for CFLAGS in the Makefile.
Who knows if there will ever be other places where the signess of char
matters.
