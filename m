From: Nirbheek Chauhan <nirbheek.chauhan@gmail.com>
Subject: Re: "Appending" data to the middle of a file using btrfs-specific features
Date: Tue, 7 Dec 2010 02:00:09 +0530
Message-ID: <AANLkTikst-_dbPT7GLaEq8R7X7xjAgVGezpQEisEhFNp@mail.gmail.com>
References: <AANLkTinXfbKmXYy52JF-QuJr0WTzgvbMXHAw-tYK4i5X@mail.gmail.com>
 <1291651254-sup-4263@think> <AANLkTi=1z3kPVyYxW1njwMfXyxoBPqHSZ2NQUG4X8uXN@mail.gmail.com>
 <AANLkTinxioDVnbSB1p8wg2z1WP4Hhk0oMqqFJg6DGAgR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Freddie Cash <fjwcash@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinxioDVnbSB1p8wg2z1WP4Hhk0oMqqFJg6DGAgR@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 7, 2010 at 1:05 AM, Freddie Cash <fjwcash@gmail.com> wrote:
> On Mon, Dec 6, 2010 at 11:14 AM, Nirbheek Chauhan
> <nirbheek.chauhan@gmail.com> wrote:
>> As an aside, my primary motivation for this was that doing an
>> incremental backup of things like git bare repositories and database=
s
>> using btrfs subvolume snapshots is expensive w.r.t. disk space. Even
>> though rsync calculates a binary delta before transferring data, it
>> has to write everything out (except if just appending). So in that
>> case, each "incremental" backup is hardly so.
>
> Since btrfs is Copy-on-Write, have you experimented with --inplace on
> the rsync command-line? =C2=A0That way, rsync writes the changes "ove=
r-top"
> of the existing file, thus allowing btrfs to only write out the block=
s
> that have changed, via CoW?
>
> We do this with our ZFS rsync backups, and found disk usage to go way
> down over the default "write out new data to new file, rename overtop=
"
> method that rsync uses.
>
> There's also the --no-whole-file option which causes rsync to only
> send delta changes for existing files, another useful feature with Co=
W
> filesystems.
>

I had tried the --inplace option, but it didn't seem to do anything
for me, so I didn't explore that further. However, after following
your suggestion and retrying with --no-whole-file, I see that the
behaviour is quite different! It seems that --whole-file is enabled by
default for local file transfers, and so --inplace had no effect.

But the behaviour of --inplace is not entirely to write out *only* the
blocks that have changed. From what I could make out, it does the
following:

(1) Calculate a delta b/w the src and trg files
(2) Seek to the first difference in the target file
(3) Start writing data

I'm glossing over the final step because I didn't look deeper, but I
think you can safely assume that after the first difference, all data
is rewritten. So this is halfway between "rewrite the whole file" and
"write only the changed bits into the file". It doesn't actually use
any CoW features from what I can see. There is lots of room for btrfs
reflinking magic. :)

Note that I tested this behaviour on a btrfs partition with a vanilla
rsync-3.0.7 tarball; the copy you use with ZFS might be doing some CoW
magic.

Thanks for the tip!

--=20
~Nirbheek Chauhan

Gentoo GNOME+Mozilla Team
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
