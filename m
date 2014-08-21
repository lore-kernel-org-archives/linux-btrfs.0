Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:34241 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753614AbaHUJfL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 05:35:11 -0400
Date: Thu, 21 Aug 2014 19:35:05 +1000
From: Dave Chinner <david@fromorbit.com>
To: Zach Brown <zab@zabbo.net>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/15] xfstests: new btrfs stress test cases
Message-ID: <20140821093505.GM26465@dastard>
References: <1408556044-907-1-git-send-email-eguan@redhat.com>
 <20140820182437.GJ429@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140820182437.GJ429@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 20, 2014 at 11:24:37AM -0700, Zach Brown wrote:
> On Thu, Aug 21, 2014 at 01:33:48AM +0800, Eryu Guan wrote:
> > This patchset add new stress test cases for btrfs by running two
> > different btrfs operations simultaneously under fsstress to ensure
> > btrfs doesn't hang or oops in such situations. btrfs scrub and
> > btrfs check will be run after each test.
> 
> Cool.
> 
> > The test matrix is the combination of 6 btrfs operations:
> > 
> > 	balance
> > 	create/mount/umount/delete subvolume
> > 	replace device
> > 	scrub
> > 	defrag
> > 	remount with different compress algorithms
> > 	
> > Short descriptions:
> > 
> > 	057: balance-subvolume
> > 	058: balance-scrub
> > 	059: balance-defrag
> > 	060: balance-remount
> > 	061: balance-replace
> > 	062: subvolume-replace
> > 	063: subvolume-scrub
> > 	064: subvolume-defrag
> > 	065: subvolume-remount
> > 	066: replace-scrub
> > 	067: replace-defrag
> > 	068: replace-remount
> > 	069: scrub-defrag
> > 	070: scrub-remount
> > 	071: defrag-remount
> 
> But I'm not sure it should be built this way.
> 
> At the very least each operation's implementation should be in a shared
> function somewhere instead of being duplicated in each test.
> 
> But I don't think there should be a seperate test for each combination.
> With a bit of fiddly bash you can automate generating unique
> combinations of operations that are defined as functions in one test.
> 
> btrfs_op_balance()
> {
>         echo hi
> }
> 
> btrfs_op_scrub()
> {
>         echo hi
> }
> 
> btrfs_op_defrag()
> {
>         echo hi
> }
> 
> ops=($(declare -F | awk '/-f btrfs_op_/ {print $3}'))
> nr=${#ops[@]}
> 
> for i in $(seq 0          $((nr - 2))); do
> for j in $(seq $((i + 1)) $((nr - 1))); do
> 	echo ${ops[i]} ${ops[j]}
> done
> done

Yes, it could be done like that, but historically that has proven to
be a bad idea. Multiplexing tens of tests within a single test is
just makes it hard to determine what failed. It might fail one
combination in 3.16, a different combo in 3.17 and yet another in
3.18. But from a reporting point of view, all we see is that a
single test failed, rather than being able to see that there were
three separate problems and that btrfs_op_scrub() was the common
factor in all three failures.

It's trivial to write this as a bunch of helper functions and then
boiler-plate the actual tests themselves. There will be little
difference in terms of run time, but we get much more fine-grained
control of execution and reporting....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
