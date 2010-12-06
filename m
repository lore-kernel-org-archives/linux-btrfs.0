From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: "Appending" data to the middle of a file using btrfs-specific features
Date: Mon, 6 Dec 2010 12:42:30 -0800
Message-ID: <AANLkTin2RxN_Jw8aCgAX3GzdHtb=WBf+_LTD99T5My12@mail.gmail.com>
References: <AANLkTinXfbKmXYy52JF-QuJr0WTzgvbMXHAw-tYK4i5X@mail.gmail.com>
	<1291651254-sup-4263@think>
	<AANLkTi=1z3kPVyYxW1njwMfXyxoBPqHSZ2NQUG4X8uXN@mail.gmail.com>
	<AANLkTinxioDVnbSB1p8wg2z1WP4Hhk0oMqqFJg6DGAgR@mail.gmail.com>
	<AANLkTikst-_dbPT7GLaEq8R7X7xjAgVGezpQEisEhFNp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Nirbheek Chauhan <nirbheek.chauhan@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikst-_dbPT7GLaEq8R7X7xjAgVGezpQEisEhFNp@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 6, 2010 at 12:30 PM, Nirbheek Chauhan
<nirbheek.chauhan@gmail.com> wrote:
> On Tue, Dec 7, 2010 at 1:05 AM, Freddie Cash <fjwcash@gmail.com> wrot=
e:
>> On Mon, Dec 6, 2010 at 11:14 AM, Nirbheek Chauhan
>> <nirbheek.chauhan@gmail.com> wrote:
>>> As an aside, my primary motivation for this was that doing an
>>> incremental backup of things like git bare repositories and databas=
es
>>> using btrfs subvolume snapshots is expensive w.r.t. disk space. Eve=
n
>>> though rsync calculates a binary delta before transferring data, it
>>> has to write everything out (except if just appending). So in that
>>> case, each "incremental" backup is hardly so.
>>
>> Since btrfs is Copy-on-Write, have you experimented with --inplace o=
n
>> the rsync command-line? =C2=A0That way, rsync writes the changes "ov=
er-top"
>> of the existing file, thus allowing btrfs to only write out the bloc=
ks
>> that have changed, via CoW?
>>
>> We do this with our ZFS rsync backups, and found disk usage to go wa=
y
>> down over the default "write out new data to new file, rename overto=
p"
>> method that rsync uses.
>>
>> There's also the --no-whole-file option which causes rsync to only
>> send delta changes for existing files, another useful feature with C=
oW
>> filesystems.
>>
> I had tried the --inplace option, but it didn't seem to do anything
> for me, so I didn't explore that further. However, after following
> your suggestion and retrying with --no-whole-file, I see that the
> behaviour is quite different! It seems that --whole-file is enabled b=
y
> default for local file transfers, and so --inplace had no effect.

Yes, correct, --whole-file is used for local transfers since it's
assumed you have all the disk I/O in the world, so why try to limit
the amount of data transferred.  :)

> But the behaviour of --inplace is not entirely to write out *only* th=
e
> blocks that have changed. From what I could make out, it does the
> following:
>
> (1) Calculate a delta b/w the src and trg files
> (2) Seek to the first difference in the target file
> (3) Start writing data

That may be true, I've never looked into the actual algorithm(s) that
rsync uses.  Just played around with CLI options until we found the
set that works best in our situation (--inplace --delete-during
--no-whole-file --numeric-ids --hard-links --archive, over SSH with
HPN patches).

> I'm glossing over the final step because I didn't look deeper, but I
> think you can safely assume that after the first difference, all data
> is rewritten. So this is halfway between "rewrite the whole file" and
> "write only the changed bits into the file". It doesn't actually use
> any CoW features from what I can see. There is lots of room for btrfs
> reflinking magic. :)
>
> Note that I tested this behaviour on a btrfs partition with a vanilla
> rsync-3.0.7 tarball; the copy you use with ZFS might be doing some Co=
W
> magic.

All the CoW "magic" is handled by the filesystem, and not the tools on
top.  If the tool only updates X bytes, which fit into 1 block on the
fs, then only that 1 block gets updated via CoW.

Personally, I don't think the tools need to be updated to understand
CoW or to integrate with the underlying FS.  Instead, they should just
operate on blocks of X size, and let the FS figure out what to do.

Otherwise, you end up with "rsync for ZFS", "rsync for ZFS", "rsync
for BtrFS", "rsync for FAT32", etc.

But, I'm just a lowly sysadmin, what do I know about filesystem interna=
ls?  ;)


--=20
=46reddie Cash
fjwcash@gmail.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
