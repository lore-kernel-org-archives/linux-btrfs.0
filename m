From: "Ryan C. Underwood" <nemesis-lists@icequake.net>
Subject: Re: Several unhappy btrfs's after RAID meltdown
Date: Sun, 12 Feb 2012 10:31:34 -0600
Message-ID: <20120212163134.GA15216@localhost.localdomain>
References: <20120205184128.GC18806@localhost.localdomain>
 <20120207033945.GA5639@localhost.localdomain>
 <pan.2012.02.07.09.53.58@cox.net>
 <20120207140431.GB5639@localhost.localdomain>
 <CAKcLGm9mLhwc1ZFp=ingR814X77QetX3LOkSqxdbussjj2gykQ@mail.gmail.com>
 <20120207154225.GD5639@localhost.localdomain>
 <20120207174645.GE5639@localhost.localdomain>
 <20120207174907.GF5639@localhost.localdomain>
Reply-To: nemesis@icequake.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120207174907.GF5639@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


So, I examined the below filesystem, the one of the two that I would
really like to restore.  There is basically nothing but zeros, and
very occasionally a sparse string of data, until exactly 0x200000
offset, at which point the data is suddenly very packed and looks like
usual compressed data should.  Is there a way one could de-LZO the
data chunkwise and dump to another device so I could even get an idea
what I am looking at?  What about a 'superblock' signature I can scan
for?

> # /usr/local/btrfs-progs/bin/restore -v /dev/mapper/tr5ut-vicep--library /mnt2
> checksum verify failed on 317874630656 wanted 8E19212D found FFFFFFA6
> checksum verify failed on 317874630656 wanted 8E19212D found FFFFFFA6
> checksum verify failed on 317874630656 wanted 491D9C1A found FFFFFFA6
> checksum verify failed on 317874630656 wanted 8E19212D found FFFFFFA6
> Csum didn't match
> restore: root-tree.c:46: btrfs_find_last_root: Assertion
> `!(path->slots[0] == 0)' failed.
> Aborted

-- 
Ryan C. Underwood, <nemesis@icequake.net>
