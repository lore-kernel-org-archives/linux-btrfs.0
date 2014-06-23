Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:44329 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaFWCdP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 22:33:15 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id 4AF8C3EE0D1
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 11:33:14 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 572FAAC0406
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 11:33:13 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 0E69E1DB803B
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 11:33:13 +0900 (JST)
Message-ID: <53A791E0.50008@jp.fujitsu.com>
Date: Mon, 23 Jun 2014 11:33:04 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Nils Steinger <git@n-st.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs-progs: Add uninstall targets to Makefiles.
References: <53A78988.7050602@jp.fujitsu.com> <1403490228-3513-1-git-send-email-git@n-st.de>
In-Reply-To: <1403490228-3513-1-git-send-email-git@n-st.de>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/06/23 11:23), Nils Steinger wrote:
> Signed-off-by: Nils Steinger <git@n-st.de>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> ---
> 
> v2: As Satoru Takeuchi pointed out, I forgot to remove $(libs) in the main
> Makefile.
> 
>   Documentation/Makefile | 4 ++++
>   Makefile               | 9 +++++++++
>   2 files changed, 13 insertions(+)
> 
> diff --git a/Documentation/Makefile b/Documentation/Makefile
> index 45299bb..5c9780b 100644
> --- a/Documentation/Makefile
> +++ b/Documentation/Makefile
> @@ -76,6 +76,10 @@ install-man: man
>   	$(INSTALL) -m 644 $(GZ_MAN8) $(DESTDIR)$(man8dir)
>   	$(LNS) btrfs-check.8.gz $(DESTDIR)$(man8dir)
>   
> +uninstall:
> +	cd $(DESTDIR)$(man8dir); rm -f btrfs-check.8.gz $(GZ_MAN8)
> +	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(man8dir)
> +
>   clean:
>   	$(RM) *.xml *.xml+ *.8 *.8.gz
>   
> diff --git a/Makefile b/Makefile
> index 76565e8..fe6a2f8 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -257,6 +257,15 @@ $(INSTALLDIRS):
>   	@echo "Making install in $(patsubst install-%,%,$@)"
>   	$(Q)$(MAKE) $(MAKEOPTS) -C $(patsubst install-%,%,$@) install
>   
> +uninstall:
> +	$(Q)$(MAKE) $(MAKEOPTS) -C Documentation uninstall
> +	cd $(DESTDIR)$(incdir); rm -f $(headers)
> +	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(incdir)
> +	cd $(DESTDIR)$(libdir); rm -f $(lib_links) $(libs)
> +	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(libdir)
> +	cd $(DESTDIR)$(bindir); rm -f btrfsck fsck.btrfs $(progs)
> +	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(bindir)
> +
>   ifneq ($(MAKECMDGOALS),clean)
>   -include $(objects:.o=.o.d) $(cmd-objects:.o=.o.d) $(subst .btrfs,, $(filter-out btrfsck.o.d, $(progs:=.o.d)))
>   endif
> 

