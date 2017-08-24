Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:65229 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751124AbdHXHqh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 03:46:37 -0400
Subject: Re: [PATCH] btrfs-progs: doc: fix btrfs-inspect-internal rootid doc
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <453da244-de65-e58b-ef28-f6dbff093052@jp.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <8069ab44-e6c9-b4e0-d1c4-a16d6a21f451@gmx.com>
Date: Thu, 24 Aug 2017 15:46:26 +0800
MIME-Version: 1.0
In-Reply-To: <453da244-de65-e58b-ef28-f6dbff093052@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月24日 15:39, Misono, Tomohiro wrote:
> "btrfs inspect-internal rootid <path>" rejects a file to be specified in 
> the implementation.
> Therefore change "file or directory" to "directory" in the doc.
> 
> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
> ---
>    Documentation/btrfs-inspect-internal.asciidoc | 2 +-
>    1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/btrfs-inspect-internal.asciidoc
> b/Documentation/btrfs-inspect-internal.asciidoc
> index 62b1029..a1ed1a3 100644
> --- a/Documentation/btrfs-inspect-internal.asciidoc
> +++ b/Documentation/btrfs-inspect-internal.asciidoc
> @@ -136,7 +136,7 @@ resize operation, this may be useful before 
> executing the actual resize operatio
>    specify the device 'id' to query, default is 1 if this option is not 
> used
> 
>    *rootid* <path>::

What about changing "<path>" to "<directory>"?

Thanks,
Qu

> -for a given file or directory, return the containing tree root id, for a
> +for a given directory, return the containing tree root id, for a
>    subvolume itself return it's own tree id (ie. subvol id)
>    +
>    NOTE: The result is undefined for the so-called empty subvolumes 
> (identified by
> -- 
> 2.9.5
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
