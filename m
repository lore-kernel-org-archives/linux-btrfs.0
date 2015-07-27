Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbbG0NY5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 09:24:57 -0400
Date: Mon, 27 Jul 2015 15:24:46 +0200
From: David Sterba <dsterba@suse.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs-tests: Add -o loop to
 fsck-tests/012-leaf-corruption for loop device
Message-ID: <20150727132446.GB6306@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <7d731282f5ddb1a3f1baedf6586772c4fe8838b9.1438002072.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7d731282f5ddb1a3f1baedf6586772c4fe8838b9.1438002072.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 27, 2015 at 09:01:50PM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> To avoid following mount error in test:
>   mount: /root/btrfs/progs/tests/fsck-tests/012-leaf-corruption/test.img
>   is not a block device (maybe try `-o loop'?)
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
