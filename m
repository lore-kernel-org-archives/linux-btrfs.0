From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: btrfs: free space inode generation (0) did not match free space cache
 generation
Date: Fri, 28 Jan 2011 10:59:56 +0100
Message-ID: <4D42939C.5020605@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Not sure if the:

btrfs: free space inode generation (0) did not match free space cache generation

is supposed to be fixed in 2.6.38-rc2?


I'm getting such entries in dmesg:

[12638.713154] device fsid 1142843480ad2d13-4bdc742fd9b1f7b0 devid 1 transid 3501 /dev/sdb4
[12638.713528] btrfs: force zlib compression
[12638.959864] btrfs: disk space caching is enabled
[12679.397549] btrfs: free space inode generation (0) did not match free space cache generation (3491) for block group 10766778368
[12853.160162] btrfs: free space inode generation (0) did not match free space cache generation (3467) for block group 282960330752
[12853.160176] btrfs: free space inode generation (0) did not match free space cache generation (3470) for block group 285107814400
[12853.160187] btrfs: free space inode generation (0) did not match free space cache generation (3478) for block group 290476523520
[12853.160198] btrfs: free space inode generation (0) did not match free space cache generation (3480) for block group 292624007168
[12853.237298] btrfs: free space inode generation (0) did not match free space cache generation (3485) for block group 296918974464
[12853.237316] btrfs: free space inode generation (0) did not match free space cache generation (3486) for block group 299066458112
[12853.237328] btrfs: free space inode generation (0) did not match free space cache generation (3487) for block group 300140199936
[12853.237339] btrfs: free space inode generation (0) did not match free space cache generation (3488) for block group 301213941760
[12858.468374] btrfs: free space inode generation (0) did not match free space cache generation (3430) for block group 223904530432
[12858.468392] btrfs: free space inode generation (0) did not match free space cache generation (3432) for block group 226052014080
[12858.468405] btrfs: free space inode generation (0) did not match free space cache generation (3434) for block group 228199497728
[12860.040819] btrfs: free space inode generation (0) did not match free space cache generation (3420) for block group 213167112192
[12860.040836] btrfs: free space inode generation (0) did not match free space cache generation (3422) for block group 215314595840
[12860.040852] btrfs: free space inode generation (0) did not match free space cache generation (3424) for block group 217462079488
[12860.040865] btrfs: free space inode generation (0) did not match free space cache generation (3426) for block group 219609563136
[12860.040877] btrfs: free space inode generation (0) did not match free space cache generation (3428) for block group 221757046784


I saw a similar discussion in December 2010, but I'm not sure if the fix was pushed yet or not?

The filesystem should have plenty of free space free:

Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb4             336G  156G  179G  47% /srv



-- 
Tomasz Chmielewski
http://wpkg.org

