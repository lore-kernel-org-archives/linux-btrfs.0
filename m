Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbbHaOwg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 10:52:36 -0400
Date: Mon, 31 Aug 2015 16:51:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/4] btrfs-progs: tests: umount TEST_MNT in
 clean-tests.sh
Message-ID: <20150831145156.GV11834@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1440997237.git.zhaolei@cn.fujitsu.com>
 <df9f4f0f57be049efe6e5002311b6cbff0fb1167.1440997237.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <df9f4f0f57be049efe6e5002311b6cbff0fb1167.1440997237.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 31, 2015 at 01:04:38PM +0800, Zhao Lei wrote:
> If a testcase failed, we can't run it(or other tests needs mount) again,
>   # ./misc-tests.sh 007
>    [TEST]   007-subvolume-sync
>    failed: fail
>    test failed for case 007-subvolume-sync
>   # ./misc-tests.sh 007
>    [TEST]   007-subvolume-sync
>    failed: mount /root/btrfs-progs/tests/test.img /root/btrfs-progs/tests/mnt
>    test failed for case 007-subvolume-sync
>   #
> 
> This patch add "umount $TEST_MNT" to clean-tests.sh, to let user
> clean mountpoint easily.
> 
> After patch:
>   # ./misc-tests.sh  007
>    [TEST]   007-subvolume-sync
>    failed: fail
>    test failed for case 007-subvolume-sync
>   #
>   # clean-tests.sh
>   #
>   # ./misc-tests.sh  007
>    [TEST]   007-subvolume-sync
>    failed: fail
>    test failed for case 007-subvolume-sync
>   #
> 
> Changelog v1->v2:
>   Put umount command to clean-tests.sh instead of in testscript,
>   to keep failed-test stat until user run clean-tests.sh
>   explicitly, Suggested-by: David Sterba <dsterba@suse.cz>
> 
> Suggested-by: David Sterba <dsterba@suse.cz>
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
