From: "Ryan C. Underwood" <nemesis-lists@icequake.net>
Subject: Re: Several unhappy btrfs's after RAID meltdown
Date: Tue, 7 Feb 2012 09:42:25 -0600
Message-ID: <20120207154225.GD5639@localhost.localdomain>
References: <20120205184128.GC18806@localhost.localdomain>
 <20120207033945.GA5639@localhost.localdomain>
 <pan.2012.02.07.09.53.58@cox.net>
 <20120207140431.GB5639@localhost.localdomain>
 <CAKcLGm9mLhwc1ZFp=ingR814X77QetX3LOkSqxdbussjj2gykQ@mail.gmail.com>
Reply-To: nemesis@icequake.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm9mLhwc1ZFp=ingR814X77QetX3LOkSqxdbussjj2gykQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Tue, Feb 07, 2012 at 08:36:15AM -0600, Mitch Harder wrote:
> 
> Since you're getting "failed to read /dev/sr0" messages, that might be
> an indication there are some newer btrfs-progs tools available.
> 
> You might want to try the building btrfs-progs from the git repository:
> http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs.git;a=summary

I did so, here's the new output (not much changed)
# /usr/local/btrfs-progs/bin/btrfs-show
**
** WARNING: this program is considered deprecated
** Please consider to switch to the btrfs utility
**
failed to read /dev/sr0: No medium found
Label: vicep-library  uuid: 89b14d35-b31a-4fbe-a2d9-cb83cbcd3851
        Total devices 1 FS bytes used 254.35GB
        devid    1 size 1.00TB used 299.04GB path /dev/dm-32

Btrfs Btrfs v0.19

# /usr/local/btrfs-progs/bin/btrfs device scan
Scanning for Btrfs filesystems
failed to read /dev/sr0

> 
> There are some recovery tools there that may extract your data (look
> at the "recover" program).

I found a 'restore' program, are you referring to the mount option '-o
recovery'?

-- 
Ryan C. Underwood, <nemesis@icequake.net>
