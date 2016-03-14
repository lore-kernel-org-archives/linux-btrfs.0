Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40949 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbcCNM3C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 08:29:02 -0400
Date: Mon, 14 Mar 2016 13:28:38 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] btrfs-progs: Avoid interpreting options after "--"
 when getting unit mode
Message-ID: <20160314122838.GC18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56E5FF9A.4020609@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56E5FF9A.4020609@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 14, 2016 at 09:02:34AM +0900, Satoru Takeuchi wrote:
> * actual result
> 
>   ======================================
>   # ./btrfs device usage -- -m /btrfs
> 
>   /dev/sdf1, ID: 1
>      Device size:          95367.41MiB
>      Data,single:          2056.00MiB
>      Metadata,DUP:         2048.00MiB
>      System,DUP:             16.00MiB
>      Unallocated:          91247.41MiB
>   ======================================
> 
> * expected result
> 
>   ======================================
>   # ./btrfs device usage -- -m /btrfs
> 
>   ERROR: can't access '-m': No such file or directory
>   ======================================
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Applied, thanks.
