From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: "Appending" data to the middle of a file using btrfs-specific features
Date: Mon, 6 Dec 2010 11:35:42 -0800
Message-ID: <AANLkTinxioDVnbSB1p8wg2z1WP4Hhk0oMqqFJg6DGAgR@mail.gmail.com>
References: <AANLkTinXfbKmXYy52JF-QuJr0WTzgvbMXHAw-tYK4i5X@mail.gmail.com>
	<1291651254-sup-4263@think>
	<AANLkTi=1z3kPVyYxW1njwMfXyxoBPqHSZ2NQUG4X8uXN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Nirbheek Chauhan <nirbheek.chauhan@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=1z3kPVyYxW1njwMfXyxoBPqHSZ2NQUG4X8uXN@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 6, 2010 at 11:14 AM, Nirbheek Chauhan
<nirbheek.chauhan@gmail.com> wrote:
> As an aside, my primary motivation for this was that doing an
> incremental backup of things like git bare repositories and databases
> using btrfs subvolume snapshots is expensive w.r.t. disk space. Even
> though rsync calculates a binary delta before transferring data, it
> has to write everything out (except if just appending). So in that
> case, each "incremental" backup is hardly so.

Since btrfs is Copy-on-Write, have you experimented with --inplace on
the rsync command-line?  That way, rsync writes the changes "over-top"
of the existing file, thus allowing btrfs to only write out the blocks
that have changed, via CoW?

We do this with our ZFS rsync backups, and found disk usage to go way
down over the default "write out new data to new file, rename overtop"
method that rsync uses.

There's also the --no-whole-file option which causes rsync to only
send delta changes for existing files, another useful feature with CoW
filesystems.

-- 
Freddie Cash
fjwcash@gmail.com
