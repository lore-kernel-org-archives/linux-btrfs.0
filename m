From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Subject: Re: Atomic file data replace API
Date: Fri, 7 Jan 2011 13:55:07 +0000
Message-ID: <AANLkTikE2Rr3KdGA5bN77o+BmkD6nsBvDasgx4085MiL@mail.gmail.com>
References: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Olaf van der Spek <olafvdspek@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=paCEdAFZkHWTSwTCjYavMPOaGY8MsLknryk=_@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 6 January 2011 20:01, Olaf van der Spek <olafvdspek@gmail.com> wrote:
> Hi,
>
> Does btrfs support atomic file data replaces?

Hi Olaf,

Yes btrfs does support atomic replace, since kernel 2.6.30 circa June 2009. [1]

Special handling was added to ext3, ext4, btrfs (and probably other
Linux FSs) for your replace-via-truncate and the alternative
replace-via-rename application patterns.  Try reading "Delayed
allocation and the zero-length file problem" article and comments by
Ted Ts'o for further discussion. [2]

Mike
-- 
[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5a3f23d515a2ebf0c750db80579ca57b28cbce6d
[2] http://thunk.org/tytso/blog/2009/03/12/delayed-allocation-and-the-zero-length-file-problem/
