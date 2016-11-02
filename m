Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51335 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751492AbcKBMWM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Nov 2016 08:22:12 -0400
Date: Wed, 2 Nov 2016 13:22:08 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs-progs: send: fix handling of -c option
Message-ID: <20161102122208.GD12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201610190235.AA00003@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201610190235.AA00003@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 19, 2016 at 11:35:40AM +0900, Tsutomu Itoh wrote:
> When two or more -c options are specified, cannot find a suitable
> parent. So, output stream is bigger than correct one.
> 
> [before]
> # btrfs send -f /tmp/data1 -c Snap0 -c ../SnapX Snap[12] ../SnapY
> At subvol Snap1
> At subvol Snap2
> At subvol ../SnapY
> # ls -l /tmp/data1
> -rw------- 1 root root 3153 Oct 19 10:37 /tmp/data1
> #
> 
> [after]
> # btrfs send -f /tmp/data1 -c Snap0 -c ../SnapX Snap[12] ../SnapY
> At subvol Snap1
> At subvol Snap2
> At subvol ../SnapY
> # ls -l /tmp/data1
> -rw------- 1 root root 1492 Oct 19 10:39 /tmp/data1
> #

Can you please create a test for that?

> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
>  cmds-send.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/cmds-send.c b/cmds-send.c
> index 2a8a697..b93a667 100644
> --- a/cmds-send.c
> +++ b/cmds-send.c
> @@ -651,6 +651,18 @@ int cmd_send(int argc, char **argv)
>  		}
>  
>  		if (!full_send && root_id) {
> +			ret = init_root_path(&send, subvol);
> +			if (ret < 0)
> +				goto out;
> +
> +			ret = get_root_id(&send,
> +				subvol_strip_mountpoint(send.root_path, subvol),
> +				&root_id);
> +			if (ret < 0) {
> +				error("cannot resolve rootid for %s", subvol);
> +				goto out;
> +			}

This duplicates the code that handles the '-c' option, please factori it
toa helper function.

> +
>  			ret = find_good_parent(&send, root_id, &parent_root_id);
>  			if (ret < 0) {
>  				error("parent determination failed for %lld",
