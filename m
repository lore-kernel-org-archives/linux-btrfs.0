Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab3IIOS5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Sep 2013 10:18:57 -0400
Date: Mon, 9 Sep 2013 16:18:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/5] btrfs-progs:local variable memory freed
Message-ID: <20130909141855.GM32382@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1378348738-14451-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1378348738-14451-3-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1378348738-14451-3-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 05, 2013 at 10:38:55AM +0800, Gui Hecheng wrote:
> The local probe variable in is_ssd() freed upon unsuccessful return;

FYI, I've applied a patch from Wang Shilong "Btrfs-progs: fix compile
warning in is_ssd()" instead of the hunk below and will remove the
respective changelog line. The rest of your patch stays.

> @@ -1161,8 +1169,10 @@ static int is_ssd(const char *file)
>  
>  	/* Device number of this disk (possibly a partition) */
>  	devno = blkid_probe_get_devno(probe);
> -	if (!devno)
> +	if (!devno) {
> +		blkid_free_probe(probe);
>  		return 0;
> +	}
>  
>  	/* Get whole disk name (not full path) for this devno */
>  	blkid_devno_to_wholedisk(devno, wholedisk, sizeof(wholedisk), NULL);
