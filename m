Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbcCXOYs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 10:24:48 -0400
Date: Thu, 24 Mar 2016 15:24:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: send: fix handling of multiple snapshots
Message-ID: <20160324142417.GQ29764@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201603240747.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201603240747.AA00000@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 24, 2016 at 04:47:28PM +0900, Tsutomu Itoh wrote:
> We cannot send multiple snapshots at once.
> 
> [before fix]
> # btrfs send ./snap[12] > snap12.data
> At subvol ./snap1
> At subvol ./snap2
> ERROR: parent determination failed for 0
> #
> 
> [after fix]
> # btrfs send ./snap[12] > snap12.data
> At subvol ./snap1
> At subvol ./snap2
> #
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Applied, thanks.
