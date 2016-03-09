Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:20039 "EHLO
	mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbcCIB1N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Mar 2016 20:27:13 -0500
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 897D7AC0272
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Mar 2016 10:27:03 +0900 (JST)
Subject: Re: [PATCH] Documentation: btrfs: remove usage specific information
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <1457456686-30474-1-git-send-email-dsterba@suse.com>
Cc: clm@fb.com
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <56DF7BDB.8000109@jp.fujitsu.com>
Date: Wed, 9 Mar 2016 10:26:51 +0900
MIME-Version: 1.0
In-Reply-To: <1457456686-30474-1-git-send-email-dsterba@suse.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/03/09 2:04, David Sterba wrote:
> The document in the kernel sources is yet another palce where the
> documentation would need to be updated, while it is not the primary
> source. We actively maintain the wiki pages.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   Documentation/filesystems/btrfs.txt | 261 ++----------------------------------
>   1 file changed, 11 insertions(+), 250 deletions(-)
> 
> diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
> index c772b47e7ef0..f9dad22d95ce 100644
> --- a/Documentation/filesystems/btrfs.txt
> +++ b/Documentation/filesystems/btrfs.txt
> @@ -1,20 +1,10 @@
> -
>   BTRFS
>   =====
>   
...
> -* btrfs-convert: in-place conversion from ext2/3/4 filesystems
> +  https://btrfs.wiki.kernel.org
>   
> -* btrfs-image: dump filesystem metadata for debugging
> +that maintains information about administration tasks, frequently asked
> +questions, use cases, mount options, comprehensible changelogs, features,
> +manual pages, source code repositories, contacts etc.

About mount options, we also have "man 5 btrfs" and it's
newer than wiki page's one.

https://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg34545.html
commit 26341f734d6d ("btrfs-progs: add mount options to btrfs-mount.5")

Last update:
 - Btrfs wiki -> Mount options: Sep 19 2015
 - btrfs-man5.asciidoc: Jan 11 2016

So, how about refer to "man 5 btrfs" from
"Btrfs wiki -> Mount options -> List of options"
and/or this document?

Thanks,
Satoru
