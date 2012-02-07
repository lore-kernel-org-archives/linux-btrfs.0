From: "Ryan C. Underwood" <nemesis-lists@icequake.net>
Subject: Re: Several unhappy btrfs's after RAID meltdown
Date: Tue, 7 Feb 2012 11:46:45 -0600
Message-ID: <20120207174645.GE5639@localhost.localdomain>
References: <20120205184128.GC18806@localhost.localdomain>
 <20120207033945.GA5639@localhost.localdomain>
 <pan.2012.02.07.09.53.58@cox.net>
 <20120207140431.GB5639@localhost.localdomain>
 <CAKcLGm9mLhwc1ZFp=ingR814X77QetX3LOkSqxdbussjj2gykQ@mail.gmail.com>
 <20120207154225.GD5639@localhost.localdomain>
Reply-To: nemesis@icequake.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120207154225.GD5639@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


Output of btrfs-zero-log attempts similar to btrfsck.

# ./btrfs-zero-log /dev/mapper/tr5ut-vicep--clones 
No valid Btrfs found on /dev/mapper/tr5ut-vicep--clones

# ./btrfs-zero-log
/dev/mapper/tr5ut-vicep--library 
checksum verify failed on 317874630656 wanted 8E19212D found FFFFFFA6
checksum verify failed on 317874630656 wanted 8E19212D found FFFFFFA6
checksum verify failed on 317874630656 wanted 491D9C1A found FFFFFFA6
checksum verify failed on 317874630656 wanted 8E19212D found FFFFFFA6
Csum didn't match
btrfs-zero-log: root-tree.c:46: btrfs_find_last_root: Assertion
`!(path->slots[0] == 0)' failed.
Aborted


-- 
Ryan C. Underwood, <nemesis@icequake.net>
