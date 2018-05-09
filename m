Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54490 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932875AbeEIMhx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 9 May 2018 08:37:53 -0400
Date: Wed, 9 May 2018 14:35:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: tests: test mkfs.btrfs fails on small
 backing size thin provision device
Message-ID: <20180509123515.GX6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180412011028.1064-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180412011028.1064-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2018 at 09:10:28AM +0800, Su Yue wrote:
> This tests is most similar to xfstests generic/405.
> It calls device mapper to create a thin provision device with small
> backing size and big virtual size. mkfs.btrfs should fail on such
> devices.
> 
> This test should pass after commit e805b143a4fe
> ("btrfs-progs: mkfs: return nozero value on thin provisioned device").
> 
> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>

Applied with some tweaks, thanks.

> +	# wait for device to be fully settled
> +	run_check $SUDO_HELPER udevadm settle
> +	run_check $SUDO_HELPER dmsetup remove "$DMTHIN_VOL_NAME"
> +	run_check $SUDO_HELPER dmsetup remove "$DMTHIN_POOL_NAME"
> +	run_check $SUDO_HELPER dmsetup remove "$DMTHIN_META_NAME"
> +	run_check $SUDO_HELPER dmsetup remove "$DMTHIN_DATA_NAME"

extrenal utilities should be checked by check_global_prereq

> +# mkfs.btrfs should fail due to the small backing device
> +run_mustfail "should fail for small backing size thin provision device" \
> +	     $SUDO_HELPER "$TOP/mkfs.btrfs" -f "$DMTHIN_VOL_DEV"

the automatic trim will slow mkfs down, so -K
