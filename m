Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59302 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753264AbbAFBOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 20:14:44 -0500
Message-ID: <54AB36FE.60508@cn.fujitsu.com>
Date: Tue, 6 Jan 2015 09:14:38 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Peter Wu <peter@lekensteyn.nl>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Documentation: fix broken conversion
References: <1420467009-11738-1-git-send-email-peter@lekensteyn.nl>
In-Reply-To: <1420467009-11738-1-git-send-email-peter@lekensteyn.nl>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH] Documentation: fix broken conversion
From: Peter Wu <peter@lekensteyn.nl>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年01月05日 22:10
> Fixes various formatting issues:
>
> Fixes quoting issues in various manpages. Before/After excerpts for
> mkfs.btrfs(8), btrfs-qgroup(8):
>
>      mkfs.btrfs [-A|--alloc-start '<alloc-start>']
>      mkfs.btrfs [-A|--alloc-start <alloc-start>]
>      id 0/<subvolume id>''
>      id 0/<subvolume id>
>      If multiple '<attr>'s is given, use comma to separate.
>      If multiple <attr>s is given, use comma to separate.
>
> The one that is most apparent is the removal of text in
> btrfs-subvolume(8) and others. Before/After:
>
>      list [options] [-G <value>] [-C <value>] [--sort=rootid,gen,ogen,path] <path>
>      list [options] [-G [+|-]<value>] [-C [+|-]<value>] [--sort=rootid,gen,ogen,path] <path>
>      create [-i <qgroupid>] <name>
>      create [-i <qgroupid>] [<dest>]<name>
Nice catch!
>
> This happens because `<foo>` was replaced by `'<foo>'` in the sed
> expression, which is then treated as a constrained quote. As a result,
> the `[...]` before the string gets interpreted as "quoted text
> attributes".
>
> In this patch, the sed expression is dropped and asciidoc is configured
> to recognize `<...>` as a unconstrained quoted string (such that
> `<attr>s` is correctly emphasized) and to avoid adding quotes in
> contexts where it is not needed.
>
> A remaining problem is that some texts (the one between brackets) do not
> add the emphasis for `<...>`.
IMHO, current implement in this patch is already good enough, although 
it is still not perfect,
but much much better than previous one and such missing of emphasize is 
acceptable.
> While this could be solved by replacing
> `[` and `]` with `&#91;` and `&#93;` using sed, it introduces formatting
> problems in btrfs-zero-log(8) because the context is ignored.
>
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---
>   Documentation/Makefile      | 8 +++-----
>   Documentation/asciidoc.conf | 6 ++++++
>   2 files changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/Makefile b/Documentation/Makefile
> index ef4f1bd..72ab77b 100644
> --- a/Documentation/Makefile
> +++ b/Documentation/Makefile
> @@ -113,10 +113,8 @@ clean:
>   	$(XMLTO) -m $(MANPAGE_XSL) $(XMLTO_EXTRA) man $<
>   
>   %.xml : %.txt asciidoc.conf
> -	$(QUIET_ASCIIDOC)$(RM) $@.tmp[12] $@ && \
> -	sed -e "s/\(<[^>]\+>\)/'\1'/g" < $< > $@.tmp1 && \
> +	$(QUIET_ASCIIDOC)$(RM) $@+ $@ && \
>   	$(ASCIIDOC) -b docbook -d manpage -f asciidoc.conf \
>   		$(ASCIIDOC_EXTRA) -abtrfs_version=$(BTRFS_VERSION) \
> -		-o $@.tmp2 $@.tmp1 && \
> -	mv $@.tmp2 $@ && \
> -	rm -f -- $@.tmp1
> +		-o $@+ $< && \
> +	mv $@+ $@
> diff --git a/Documentation/asciidoc.conf b/Documentation/asciidoc.conf
> index 313f185..1ea7459 100644
> --- a/Documentation/asciidoc.conf
> +++ b/Documentation/asciidoc.conf
> @@ -10,6 +10,12 @@
>   [macros]
>   (?su)[\\]?(?P<name>linkbtrfs):(?P<target>\S*?)\[(?P<attrlist>.*?)\]=
>   
> +[tags]
> +bracket-emphasis={1?[{1}]}<emphasis>&lt;|&gt;</emphasis>
> +
> +[quotes]
> +&lt;|&gt;=#bracket-emphasis
> +
This method is more elegant than the original sed method.

Thanks a lot.
Qu
>   [attributes]
>   asterisk=&#42;
>   plus=&#43;

