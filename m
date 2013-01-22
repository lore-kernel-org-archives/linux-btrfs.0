Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:49372 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3AVVwz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Jan 2013 16:52:55 -0500
Received: by mail-oa0-f43.google.com with SMTP id k1so7766125oag.16
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jan 2013 13:52:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1358875326-28636-3-git-send-email-gene@czarc.net>
References: <1358875326-28636-1-git-send-email-gene@czarc.net>
	<1358875326-28636-3-git-send-email-gene@czarc.net>
Date: Tue, 22 Jan 2013 21:52:54 +0000
Message-ID: <CAMU1PDg3is5atwBnKCnA0e-xQAH2GnYZcb1WF4Xk7VRbLL2vVw@mail.gmail.com>
Subject: Re: [PATCH 2/3] Btrfs-progs Add make archive
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22 January 2013 17:22, Gene Czarcinski <gene@czarc.net> wrote:
> This adds the archive target to the Makefile which simply executes
> do-archive.sh.  It also adds the remove of btrfs-progs.spec.in to

I think you mean btrfs-progs.spec without the .in as that's the generated file.

> make clean.
> Signed-off-by: Gene Czarcinski <gene@czarc.net>
> ---
>  Makefile | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index d524f69..6812258 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -111,9 +111,13 @@ manpages:
>  install-man:
>         cd man; $(MAKE) install
>
> +archive:
> +       bash do-archive.sh
> +
>  clean :
>         rm -f $(progs) cscope.out *.o .*.d btrfs-convert btrfs-image btrfs-select-super \
> -             btrfs-zero-log btrfstune dir-test ioctl-test quick-test version.h
> +             btrfs-zero-log btrfstune dir-test ioctl-test quick-test version.h \
> +             btrfs-progs.spec
>         cd man; $(MAKE) clean
>
>  install: $(progs) install-man
> --
> 1.8.1

Mike
