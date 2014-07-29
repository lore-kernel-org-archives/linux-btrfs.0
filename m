Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:58230 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaG2AJi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jul 2014 20:09:38 -0400
Received: by mail-lb0-f177.google.com with SMTP id s7so6221618lbd.8
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jul 2014 17:09:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53D6D04F.7050904@posteo.de>
References: <53D6D04F.7050904@posteo.de>
Date: Mon, 28 Jul 2014 17:09:37 -0700
Message-ID: <CAKgsxVQbP-3huz92Y4Z3d6zVq6dnKekgs0mQzBfbLnhvD-VMjQ@mail.gmail.com>
Subject: Re: How to skip "looping a lot" question of btrfs restore 3.15?
From: Justin Maggard <jmaggard10@gmail.com>
To: Karl-Philipp Richter <krichter@posteo.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 28, 2014 at 3:35 PM, Karl-Philipp Richter
<krichter@posteo.de> wrote:
> Hi together,
> In the current HEAD (3f11e516db629f7a662bfd6376231817b4e34cc9) of
> https://github.com/kdave/btrfs-progs.git (I assume this list is the
> right address because I got some hints to the project from here) the
> btrfs restore subcommand asks often (up to 100 time during restauration
> of 400 GB)
>
>     We seem to be looping a lot on /a/path/to/our/precious, do you want
> to keep going on ? (y/N):
>
> which can't be suppressed with the `-i` option (which might be right
> because it's technically not an error), but I can't see how to get
> around this. Am I missing something? Otherwise it would be nice to have
> an extra option maybe with an argument how often "we" are looping on a
> file before the command asks for interaction.
>
> Best regards,
> Karl-P. Richter
>

I just posted the patch we use to get around that.  Or, if you don't
want to build a modified btrfs-progs, you could always use the `yes`
command to press y for you.

-Justin
