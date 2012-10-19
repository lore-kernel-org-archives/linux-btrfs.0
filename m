Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35364 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756594Ab2JSHhu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Oct 2012 03:37:50 -0400
Message-ID: <50810363.1090304@cn.fujitsu.com>
Date: Fri, 19 Oct 2012 15:38:11 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Anand jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] filter snapshot(s) by its parent uuid
References: <1350627837-27639-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1350627837-27639-1-git-send-email-Anand.Jain@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On fri, 19 Oct 2012 14:23:53 +0800, Anand jain wrote:
> From: Anand Jain <anand.jain@oracle.com>
> 
> This set of patch will make
> btrfs su list -s <subvol>
> to list only snapshot(s) of the given subvol.
> 
> before:
> btrfs su list -s /btrfs/sv1
> <nothing>
> btrfs su list -s /btrfs
> ID 258 gen 6 cgen 6 top level 5 otime 2012-10-18 17:01:56 uuid f648cdda-4efa-6f45-bd6b-041a8ae1538e path ss1
> ID 260 gen 8 cgen 8 top level 5 otime 2012-10-18 17:02:20 uuid ea8fdf85-8d3f-8946-b3af-ede510cdcf19 path ss2
> ID 261 gen 9 cgen 9 top level 5 otime 2012-10-19 13:37:42 uuid 44560e56-3879-2146-8b24-e9048871892f path ss3
> 
> with this patch:
> btrfs su list -s /btrfs/sv1
> ID 258 gen 6 cgen 6 top level 5 otime 2012-10-18 17:01:56 uuid f648cdda-4efa-6f45-bd6b-041a8ae1538e path ss1
> ID 261 gen 9 cgen 9 top level 5 otime 2012-10-19 13:37:42 uuid 44560e56-3879-2146-8b24-e9048871892f path ss3

Though the function implemented by your patch is very useful, you change the semantic of "-s",
I think it is not allowed, or the programs that use "btrfs us list -s" may fail.

I think it is better to add a new option.

Thanks
Miao

> 
> btrfs su list -s /btrfs
> ID 258 gen 6 cgen 6 top level 5 otime 2012-10-18 17:01:56 uuid f648cdda-4efa-6f45-bd6b-041a8ae1538e path ss1
> ID 260 gen 8 cgen 8 top level 5 otime 2012-10-18 17:02:20 uuid ea8fdf85-8d3f-8946-b3af-ede510cdcf19 path ss2
> ID 261 gen 9 cgen 9 top level 5 otime 2012-10-19 13:37:42 uuid 44560e56-3879-2146-8b24-e9048871892f path ss3
> 
> Anand Jain (4):
>   Btrfs-progs: provide method to check if filter is set
>   Btrfs-progs: fix irrelevant string in the subvol path
>   Btrfs-progs: add method to filter snapshots by parent uuid
>   Btrfs-progs: list only snapshots of the given subvol
> 
>  btrfs-list.c     |   17 +++++++++++++++++
>  btrfs-list.h     |    3 +++
>  cmds-subvolume.c |   39 +++++++++++++++++++++++++++++++++++++--
>  3 files changed, 57 insertions(+), 2 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


