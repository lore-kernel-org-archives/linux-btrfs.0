Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbaFCJOJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Jun 2014 05:14:09 -0400
Date: Tue, 3 Jun 2014 11:14:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Christian Hesse <mail@eworm.de>
Cc: linux-btrfs@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        David Sterba <dsterba@suse.cz>, clm@fb.com
Subject: Re: [PATCH 1/1] btrfs-progs: fix build, manpage compression command
Message-ID: <20140603091407.GG22324@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1401775765-16646-1-git-send-email-mail@eworm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401775765-16646-1-git-send-email-mail@eworm.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 03, 2014 at 08:09:25AM +0200, Christian Hesse wrote:
> man pages for btrfs-progs are compressed by gzip by default. In Makefile
> the variable GZIP is use, this evaluates to 'gzip gzip' on my system.
> >From man gzip:
> 
> > The environment variable GZIP can hold a set of default options for
> > gzip. These options are interpreted first and can be overwritten by
> > explicit command line parameters.
> 
> So using any other variable name fixes this.

Thanks, I can see that you've fixed this bug for the second time.  The
GZIP variable name got reverted during the asciidoc update and slipped
through, sorry for that.

> --- a/Documentation/Makefile
> +++ b/Documentation/Makefile
> @@ -56,7 +56,7 @@ ifneq ($(findstring $(MAKEFLAGS),s),s)
>  ifndef V
>  	QUIET_ASCIIDOC	= @echo '   ' ASCIIDOC $@;
>  	QUIET_XMLTO	= @echo '   ' XMLTO $@;
> -	QUIET_GZIP	= @echo '   ' GZIP $@;
> +	QUIET_GZIP	= @echo '   ' GZIPCMD $@;

JFYI, I've removed this change so the output stays the same.

I've assembled a branch containing doc-only fixes, including this one,
and asked Chris do do a 3.14.3 release.
