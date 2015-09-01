Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbbIAMdU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Sep 2015 08:33:20 -0400
Date: Tue, 1 Sep 2015 14:32:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: tests: Use --no-same-owner option for tar
Message-ID: <20150901123240.GI11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <11005b0b3385117fa772b223513cea16920ec7b9.1441101154.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <11005b0b3385117fa772b223513cea16920ec7b9.1441101154.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 01, 2015 at 06:03:14PM +0800, Zhao Lei wrote:
> Some test failed in my nfs dir:
>   ...
>     [TEST]   006-bad-root-items
>   tar: test.img: Cannot change ownership to uid 1000, gid 1000: Invalid argument
>   tar: Exiting with failure status due to previous errors
>   failed to extract default_case.tar.xz
>   test failed for case 006-bad-root-items
> 
> It is because the image file's owner is:
>  # tar tvf default_case.tar.xz
>  -rw-r--r-- fdmanana/fdmanana 2147483648 2014-10-17 17:59 test.img
> 
> And make tar failed in chown in nfs.
> 
> It is not a big issue because we don't use nfs commonly, but extract
> the image file with ownership of current user will be a better choice.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
