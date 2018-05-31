Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:63035 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750910AbeEaE1B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 May 2018 00:27:01 -0400
Received: from g01jpfmpwyt01.exch.g01.fujitsu.local (g01jpfmpwyt01.exch.g01.fujitsu.local [10.128.193.38])
        by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id AA67BAC00A2
        for <linux-btrfs@vger.kernel.org>; Thu, 31 May 2018 13:26:57 +0900 (JST)
Subject: Re: [bug report] btrfs: Add unprivileged version of ino_lookup ioctl
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
References: <20180530101906.bsnokgp5w2rfh3oh@kili.mountain>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <03e49e86-3120-e3c3-0c66-0de156b6beb7@jp.fujitsu.com>
Date: Thu, 31 May 2018 13:26:47 +0900
MIME-Version: 1.0
In-Reply-To: <20180530101906.bsnokgp5w2rfh3oh@kili.mountain>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the reporting.
I will update the patch.

Regards,
Tomohiro Misono

On 2018/05/30 19:19, Dan Carpenter wrote:
> Hello Tomohiro Misono,
> 
> The patch 56bfce6502b7: "btrfs: Add unprivileged version of
> ino_lookup ioctl" from May 16, 2018, leads to the following static
> checker warning:
> 
> 	fs/btrfs/ioctl.c:2478 btrfs_search_path_in_tree_user()
> 	error: 'temp_inode' dereferencing possible ERR_PTR()
> 
> fs/btrfs/ioctl.c
>   2469                          l = path->nodes[0];
>   2470                          slot = path->slots[0];
>   2471                          btrfs_item_key_to_cpu(l, &key2, slot);
>   2472                          if (key2.objectid != dirid) {
>   2473                                  ret = -ENOENT;
>   2474                                  goto out;
>   2475                          }
>   2476  
>   2477                          temp_inode = btrfs_iget(sb, &key2, root, NULL);
>                                 ^^^^^^^^^^^^^^^^^^^^^^^
>   2478                          ret = inode_permission(temp_inode, MAY_READ | MAY_EXEC);
>                                                        ^^^^^^^^^^
>   2479                          iput(temp_inode);
>   2480                          if (ret) {
>   2481                                  ret = -EACCES;
>   2482                                  goto out;
>   2483                          }
>   2484  
> 
> 
> regards,
> dan carpenter
> 
> 

