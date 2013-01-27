Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:50462 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab3A0RLp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Jan 2013 12:11:45 -0500
Received: from eastrmimpo305 ([68.230.241.237]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130127171145.QDGB17456.eastrmfepo201.cox.net@eastrmimpo305>
          for <linux-btrfs@vger.kernel.org>;
          Sun, 27 Jan 2013 12:11:45 -0500
Message-ID: <51055FC9.9080602@czarc.net>
Date: Sun, 27 Jan 2013 12:11:37 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: Ian Kumlien <pomac@demius.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add static compile target
References: <1359158987-19921-1-git-send-email-pomac@demius.net>
In-Reply-To: <1359158987-19921-1-git-send-email-pomac@demius.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/25/2013 07:09 PM, Ian Kumlien wrote:
> Sometimes, when you least expect it, a static binary is what you need to
> rescue your data... Or just get a good enough handle on things to make
> it work again ;)
You certainly have a good point.  I took q quick look on Fedora 18 and 
e2fsprogs has a separate static package but xfsprogs, jfsutils, and 
reiserfs-utils do not.  On the other hand, those without a separate 
static package may be only static.

I guess it depends how much bloat there would be with static only. For 
e2fsprogs, the static package only contains the static (".a") 
libraries.  I believe your patch makes all of the binaries static linked.

Is this necessary?  1) Btrfs fixes a lot of stuff on-the fly.  2) If you 
need to recover "standalone", rescue has btrfs.

I did a quick check and most of the btrfs binaries are less than 200K 
bytes whereas the static versions are around 1.2M bytes.  I know that 
disk space is cheap these days but does this solve a real problem?

Gene
>
> "make static" is a gift to you, dear user with filesystem problems!
> ---
>   Makefile | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index 4894903..9148d0b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -117,4 +117,8 @@ install: $(progs) install-man
>   	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
>   	$(INSTALL) $(progs) $(DESTDIR)$(bindir)
>   
> +static: CFLAGS += -static
> +static: LIBS += -lpthread
> +static: all
> +
>   -include .*.d

