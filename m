Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38872 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932240AbcKGP57 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Nov 2016 10:57:59 -0500
Date: Mon, 7 Nov 2016 16:57:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 3/3] btrfs-progs: send: fix handling of -c option
Message-ID: <20161107155756.GO12522@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201610190235.AA00003@WIN-5MHF4RKU941.jp.fujitsu.com>
 <201611040833.AA00011@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201611040833.AA00011@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 04, 2016 at 05:33:58PM +0900, Tsutomu Itoh wrote:
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
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Applied, thanks.
