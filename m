Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:34446 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941318AbcKOIoV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Nov 2016 03:44:21 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id AAF75AC0225
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Nov 2016 17:44:13 +0900 (JST)
Subject: Re: [PATCH 2/3] btrfs-progs: send: fix handling of multiple snapshots
 (-p option)
To: linux-btrfs@vger.kernel.org
References: <201610190235.AA00002@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <68ca0b77-c3d2-ba42-7e0f-b5fcc8d54428@jp.fujitsu.com>
Date: Tue, 15 Nov 2016 17:44:07 +0900
MIME-Version: 1.0
In-Reply-To: <201610190235.AA00002@WIN-5MHF4RKU941.jp.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

xfstests btrfs/038 fails when this patch is applied. Sorry for my fault.
I posted the patch that corrected this problem.

  [PATCH] btrfs-progs: send: fix failure of xfstests btrfs/038

Thanks,
Tsutomu

On 2016/10/19 11:35, Tsutomu Itoh wrote:
> We cannot send multiple snapshots at once by -p option.
> 
> [before]
> # btrfs send -f /tmp/data0 -p Snap0 Snap[12]
> At subvol Snap1
> At subvol Snap2
> ERROR: parent determination failed for 0
> # 
> 
> [after]
> # btrfs send -f /tmp/data0 -p Snap0 Snap[12]
> At subvol Snap1
> At subvol Snap2
> # 
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
>  cmds-send.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/cmds-send.c b/cmds-send.c
> index dfdfe01..2a8a697 100644
> --- a/cmds-send.c
> +++ b/cmds-send.c
> @@ -650,7 +650,7 @@ int cmd_send(int argc, char **argv)
>  			goto out;
>  		}
>  
> -		if (!full_send && !parent_root_id) {
> +		if (!full_send && root_id) {
>  			ret = find_good_parent(&send, root_id, &parent_root_id);
>  			if (ret < 0) {
>  				error("parent determination failed for %lld",
> @@ -673,7 +673,7 @@ int cmd_send(int argc, char **argv)
>  		if (ret < 0)
>  			goto out;
>  
> -		if (!full_send) {
> +		if (!full_send && root_id) {
>  			/* done with this subvol, so add it to the clone sources */
>  			ret = add_clone_source(&send, root_id);
>  			if (ret < 0) {
> @@ -681,8 +681,6 @@ int cmd_send(int argc, char **argv)
>  				goto out;
>  			}
>  		}
> -
> -		parent_root_id = 0;
>  	}
>  
>  	ret = 0;
> 

