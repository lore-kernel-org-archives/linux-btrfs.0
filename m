Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218AbbIYQeI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 12:34:08 -0400
Date: Fri, 25 Sep 2015 18:33:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs-tests: Avoid outputting useless warning in
 ./fsck-tests.sh
Message-ID: <20150925163310.GL11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <da33d0fb2b6ac7f8a52a4550ec74293f9e2f1af9.1438050482.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <da33d0fb2b6ac7f8a52a4550ec74293f9e2f1af9.1438050482.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 28, 2015 at 10:28:13AM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> 002-bad-transid outout 'transid verify failed' message in screen
> which is just a warning in btrfs-image in normal condition of this
> test.
> 
> This patch move above warning into $RESULTS, to:
> 1: Avoid trouble screen output
> 2: Let user known detail if other error happened in btrfs-image
> 
> Before patch:
>   # ./fsck-tests.sh
>     [TEST]   001-bad-file-extent-bytenr
>     [TEST]   002-bad-transid
>   parent transid verify failed on 29360128 wanted 9 found 755944791
>   parent transid verify failed on 29360128 wanted 9 found 755944791
>   Ignoring transid failure
>     [TEST]   003-shift-offsets
>     [TEST]   004-no-dir-index
>   ...
> 
> After patch:
>   # ./fsck-tests.sh
>   [TEST]   001-bad-file-extent-bytenr
>   [TEST]   002-bad-transid
>   [TEST]   003-shift-offsets
>   [TEST]   004-no-dir-index
>   ...
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

I missed this patch before, sorry. Applied.
