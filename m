Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23273 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751097AbdFADw2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 23:52:28 -0400
Subject: Re: [PATCH 3/3] btrfs: switch to kvmalloc and GFP_KERNEL in lzo/zlib
 alloc_workspace
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1496245064.git.dsterba@suse.com>
 <5e5885e05f14e5449d48b9c512c934c241f6139f.1496245064.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <00db6185-fc87-f4e2-4114-4f3cb43b4eb7@oracle.com>
Date: Thu, 1 Jun 2017 11:58:31 +0800
MIME-Version: 1.0
In-Reply-To: <5e5885e05f14e5449d48b9c512c934c241f6139f.1496245064.git.dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> @@ -59,7 +59,7 @@ static struct list_head *zlib_alloc_workspace(void)
>
>  	workspacesize = max(zlib_deflate_workspacesize(MAX_WBITS, MAX_MEM_LEVEL),
>  			zlib_inflate_workspacesize());
> -	workspace->strm.workspace = vmalloc(workspacesize);
> +	workspace->strm.workspace = kvmalloc(workspacesize, GFP_KERNEL);
>  	workspace->buf = kmalloc(PAGE_SIZE, GFP_KERNEL);

  Workspace->buf can be a kvmalloc as well as in lzo? or I don't know if
  there was any purpose for not doing it for zlib.

Thanks, Anand
