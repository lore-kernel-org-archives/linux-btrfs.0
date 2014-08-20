Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:59213 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaHTSYj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 14:24:39 -0400
Date: Wed, 20 Aug 2014 11:24:37 -0700
From: Zach Brown <zab@zabbo.net>
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/15] xfstests: new btrfs stress test cases
Message-ID: <20140820182437.GJ429@lenny.home.zabbo.net>
References: <1408556044-907-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1408556044-907-1-git-send-email-eguan@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 21, 2014 at 01:33:48AM +0800, Eryu Guan wrote:
> This patchset add new stress test cases for btrfs by running two
> different btrfs operations simultaneously under fsstress to ensure
> btrfs doesn't hang or oops in such situations. btrfs scrub and
> btrfs check will be run after each test.

Cool.

> The test matrix is the combination of 6 btrfs operations:
> 
> 	balance
> 	create/mount/umount/delete subvolume
> 	replace device
> 	scrub
> 	defrag
> 	remount with different compress algorithms
> 	
> Short descriptions:
> 
> 	057: balance-subvolume
> 	058: balance-scrub
> 	059: balance-defrag
> 	060: balance-remount
> 	061: balance-replace
> 	062: subvolume-replace
> 	063: subvolume-scrub
> 	064: subvolume-defrag
> 	065: subvolume-remount
> 	066: replace-scrub
> 	067: replace-defrag
> 	068: replace-remount
> 	069: scrub-defrag
> 	070: scrub-remount
> 	071: defrag-remount

But I'm not sure it should be built this way.

At the very least each operation's implementation should be in a shared
function somewhere instead of being duplicated in each test.

But I don't think there should be a seperate test for each combination.
With a bit of fiddly bash you can automate generating unique
combinations of operations that are defined as functions in one test.

btrfs_op_balance()
{
        echo hi
}

btrfs_op_scrub()
{
        echo hi
}

btrfs_op_defrag()
{
        echo hi
}

ops=($(declare -F | awk '/-f btrfs_op_/ {print $3}'))
nr=${#ops[@]}

for i in $(seq 0          $((nr - 2))); do
for j in $(seq $((i + 1)) $((nr - 1))); do
	echo ${ops[i]} ${ops[j]}
done
done

Something like that.

- z
