Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34636 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751107AbaDQAq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 20:46:28 -0400
Message-ID: <534F24A0.5000304@cn.fujitsu.com>
Date: Thu, 17 Apr 2014 08:47:28 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: doc: link btrfsck to btrfs-check
References: <20140416171219.GC29256@twin.jikos.cz> <1397668577-846-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1397668577-846-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: [PATCH] btrfs-progs: doc: link btrfsck to btrfs-check
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Date: 2014年04月17日 01:16
> The 'btrfsck' command has been deprecated in favor of 'btrfs check'. For
> compatibility install a symlink to the btrfs-check.8 manpage.
>
> CC: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>   Documentation/Makefile        | 2 ++
>   Documentation/btrfs-check.txt | 3 ++-
>   2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/Makefile b/Documentation/Makefile
> index ec8598bb57d3..1eef9fd57da3 100644
> --- a/Documentation/Makefile
> +++ b/Documentation/Makefile
> @@ -48,6 +48,7 @@ XMLTO_EXTRA = -m manpage-bold-literal.xsl
>   GZIP = gzip
>   INSTALL ?= install
>   RM ?= rm -f
> +LNS ?= ln -sf
>   BTRFS_VERSION = $(shell sed -n 's/.*BTRFS_BUILD_VERSION "Btrfs \(.*\)"/\1/p'\
>   		  ../version.h)
>   
> @@ -73,6 +74,7 @@ install: install-man
>   install-man: man
>   	$(INSTALL) -d -m 755 $(DESTDIR)$(man8dir)
>   	$(INSTALL) -m 644 $(GZ_MAN8) $(DESTDIR)$(man8dir)
> +	$(LNS) btrfs-check.txt $(DESTDIR)$(man8dir)
Shouldn't the source of soft link be btrfs-check.8.gz. ?
>   
>   clean:
>   	$(RM) *.xml *.xml+ *.8 *.8.gz
> diff --git a/Documentation/btrfs-check.txt b/Documentation/btrfs-check.txt
> index ddd7fe77eca2..485a49cbc3ec 100644
> --- a/Documentation/btrfs-check.txt
> +++ b/Documentation/btrfs-check.txt
> @@ -18,6 +18,8 @@ command, it is *highly* recommended to read the following btrfs wiki before
>   executing 'btrfs check' with '--repair' option: +
>   https://btrfs.wiki.kernel.org/index.php/Btrfsck
>   
> +'btrfsck' is an alias of 'btrfs check' command and is now deprecated.
> +
>   OPTIONS
>   -------
>   -s|--support <superblock>::
> @@ -47,4 +49,3 @@ SEE ALSO
>   `mkfs.btrfs`(8),
>   `btrfs-scrub`(8),
>   `btrfs-rescue`(8)
> -`btrfsck`(8)
Sorry to bother you but 'btrfs-scrub'/'btrfs-rescue' and 'btrfs-restore' 
seems also metioning 'btrfsck' and may also needs to remove 'btrfsck'.

Thanks,
Qu
