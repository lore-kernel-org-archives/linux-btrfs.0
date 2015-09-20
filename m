Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbbITMat (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Sep 2015 08:30:49 -0400
Date: Sun, 20 Sep 2015 14:29:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND] btrfs-progs: tests: Add '-o loop' to mount
 command line in convert-tests.sh
Message-ID: <20150920122954.GV8891@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <b92776bec0a72128214ec931003869a36940e226.1442308835.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b92776bec0a72128214ec931003869a36940e226.1442308835.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 15, 2015 at 05:22:17PM +0800, Zhao Lei wrote:
> To fix following bug:
>  # ./convert-tests.sh
>      [TEST]   ext2 4k nodesize, btrfs defaults
>  failed: mount /root/btrfsprogs/tests/test.img /root/btrfsprogs/tests/mnt
>  # tail convert-tests-results.txt
>  ...
>  ############### mount /root/btrfsprogs/tests/test.img /root/btrfsprogs/tests/mnt
>  mount: /root/btrfsprogs/tests/test.img is not a block device (maybe try `-o loop'?)
>  failed: mount /root/btrfsprogs/tests/test.img /root/btrfsprogs/tests/mnt
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

For a reason that I don't remember, I marked the first posting of this
patch to skip it. Looking at it again, it makes sense so I'm applying
it, thanks.
