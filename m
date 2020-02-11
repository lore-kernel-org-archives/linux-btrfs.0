Return-Path: <SRS0=4n2k=37=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 756FEC3B186
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Feb 2020 01:08:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ABC720848
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Feb 2020 01:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbgBKBIt (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Feb 2020 20:08:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:58892 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbgBKBIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Feb 2020 20:08:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 20707AF23;
        Tue, 11 Feb 2020 01:08:47 +0000 (UTC)
Message-ID: <3e45f382a11ccff9aa1f63210ae86764116d1959.camel@suse.de>
Subject: Re: [PATCH v2] fstests: common/btrfs: use complete sub command
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, mpdesouza@suse.com
Date:   Mon, 10 Feb 2020 22:11:31 -0300
In-Reply-To: <1581381911-6727-1-git-send-email-anand.jain@oracle.com>
References: <1581381911-6727-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 2020-02-11 at 08:45 +0800, Anand Jain wrote:
> Search for 'subvolume' in the file common/btrfs failed to find all of
> them, leading to a wrong inference for a moment.
> 
> Make sure we use the full subcommand name in the btrfs command.

Hum, in my tests realted to subvol delete by id[1], this function
successfully got the subvolid for subvol names like subvol[123].. Do
you have a case where it fails? 

> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Marcos Paulo de Souza <mpdesouza@suse.com>

Here you meant I reviewed the first version of the patch?

Thanks,
  Marcos

[1]: 
https://lore.kernel.org/linux-btrfs/20200207131951.15859-3-marcos.souza.org@gmail.com/

> ---
> v2: Update commit log.
> 
>  common/btrfs | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/common/btrfs b/common/btrfs
> index 19ac7cc4b18c..33ad7e3b41cc 100644
> --- a/common/btrfs
> +++ b/common/btrfs
> @@ -7,7 +7,7 @@ _btrfs_get_subvolid()
>  	mnt=$1
>  	name=$2
>  
> -	$BTRFS_UTIL_PROG sub list $mnt | grep $name | awk '{ print $2
> }'
> +	$BTRFS_UTIL_PROG subvolume list $mnt | grep $name | awk '{
> print $2 }'
>  }
>  
>  # _require_btrfs_command <command> [<subcommand>|<option>]

