Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail2.fujitsu.co.jp ([164.71.1.135]:59279 "EHLO
	fgwmail2.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaFWB5k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 21:57:40 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail2.fujitsu.co.jp (Postfix) with ESMTP id 929BA3EE0BC
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 10:57:38 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.nic.fujitsu.com [10.0.50.91])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 8BD2BAC04B8
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 10:57:37 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 21E6A1DB8049
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 10:57:37 +0900 (JST)
Message-ID: <53A78988.7050602@jp.fujitsu.com>
Date: Mon, 23 Jun 2014 10:57:28 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Nils Steinger <git@n-st.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: Add uninstall targets to Makefiles.
References: <1403293685-23536-1-git-send-email-git@n-st.de> <1403293685-23536-2-git-send-email-git@n-st.de>
In-Reply-To: <1403293685-23536-2-git-send-email-git@n-st.de>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Nils,

(2014/06/21 4:48), Nils Steinger wrote:
> Signed-off-by: Nils Steinger <git@n-st.de>
> ---
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

This code snippet looks good.

>   clean:
>   	$(RM) *.xml *.xml+ *.8 *.8.gz
>   
> diff --git a/Makefile b/Makefile
> index 76565e8..4cafa37 100644
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
> +	cd $(DESTDIR)$(libdir); rm -f $(lib_links)

You forgot to remove $(libs) here.

Thanks,
Satoru

> +	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(libdir)
> +	cd $(DESTDIR)$(bindir); rm -f btrfsck fsck.btrfs $(progs)
> +	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(bindir)
> +
>   ifneq ($(MAKECMDGOALS),clean)
>   -include $(objects:.o=.o.d) $(cmd-objects:.o=.o.d) $(subst .btrfs,, $(filter-out btrfsck.o.d, $(progs:=.o.d)))
>   endif
>

