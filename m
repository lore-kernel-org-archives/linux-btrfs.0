Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45826 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731069AbeHGQCu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Aug 2018 12:02:50 -0400
Date: Tue, 7 Aug 2018 15:48:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Mike Gilbert <floppym@gentoo.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Install btrfs-ioctl.3 man page
Message-ID: <20180807134819.GF3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180806205432.11009-1-floppym@gentoo.org>
 <20180806205432.11009-2-floppym@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180806205432.11009-2-floppym@gentoo.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 06, 2018 at 04:54:32PM -0400, Mike Gilbert wrote:
> ---
>  Documentation/Makefile.in | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/Makefile.in b/Documentation/Makefile.in
> index c4c843cb..5bc0d80d 100644
> --- a/Documentation/Makefile.in
> +++ b/Documentation/Makefile.in
> @@ -94,8 +94,10 @@ html: $(MAN_HTML)
>  install: install-man
>  
>  install-man: man
> +	$(INSTALL) -d -m 755 $(DESTDIR)$(man3dir)
>  	$(INSTALL) -d -m 755 $(DESTDIR)$(man5dir)
>  	$(INSTALL) -d -m 755 $(DESTDIR)$(man8dir)
> +	$(INSTALL) -m 644 $(MAN3) $(DESTDIR)$(man3dir)

MAN3_TXT += btrfs-ioctl.asciidoc

The section 3 page is not ready to be published so it's intentionally
left out of installation.
