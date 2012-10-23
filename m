Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45137 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab2JWSsK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 14:48:10 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1542229eek.19
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 11:48:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1351014715-5727-1-git-send-email-kreijack@inwind.com>
References: <1351014715-5727-1-git-send-email-kreijack@inwind.com>
Date: Tue, 23 Oct 2012 20:48:08 +0200
Message-ID: <CAJHuE_DAJNSMF5nXiMxUiG0X4KGj4vwuT6QJbWpRBppuHA9HjQ@mail.gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS][V2] Update to parse_size()
From: Goffredo Baroncelli <kreijack@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry the version is V1 and not V2

On Tue, Oct 23, 2012 at 7:51 PM, Goffredo Baroncelli <kreijack@gmail.com> wrote:
> Hi all,
>
> the following patches attempt to address some issues to the function
> parse_size():
> - this function is defined both in mkfs.c and cmds-filesystem.c; I
> moved it in utils.c (which is already used in both mkfs.btrfs and
> btrfs) in order to avoid code duplication.
> - it used the function atoll(); I replaceed atoll() with strtoull()
> because we are dealing with u64
> - no check on suffixes was performed. If the user put 'MB' as suffix he got
> bytes instead megabytes. The patches check the suffix is valid
> - add new suffixes (t,p,e for terabytes, petabytes, exabytes)
> - update the man page of the command mkfs.btrfs and
> "btrfs filesystem defragment", both use parse_size()
>
> Several peoples (see cc's) suggested these improvements with different
> patches, I collected them togheter.
>
> Please reviewed them, test them. Comments are welcome.
>
> The patches are available also to
>
> You can pull the patch from
>         http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
> branch
>         parse_size
>
>
> Signed-off-by: Goffredo Baroncelli <kreij...@inwind.it>
>
> Changelog:
> V1: avoid to change the parse_size argument;
>     better check of a wrong suffix;
>     force strtoull to use a decimal base
>
