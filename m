From: Nirbheek Chauhan <nirbheek.chauhan@gmail.com>
Subject: Re: "Appending" data to the middle of a file using btrfs-specific features
Date: Tue, 7 Dec 2010 13:08:42 +0530
Message-ID: <AANLkTin52snLRzh3fcnk6v1BYn1h=Lc6Aa=T+np0b8As@mail.gmail.com>
References: <AANLkTinXfbKmXYy52JF-QuJr0WTzgvbMXHAw-tYK4i5X@mail.gmail.com>
 <1291651254-sup-4263@think> <AANLkTi=1z3kPVyYxW1njwMfXyxoBPqHSZ2NQUG4X8uXN@mail.gmail.com>
 <AANLkTinxioDVnbSB1p8wg2z1WP4Hhk0oMqqFJg6DGAgR@mail.gmail.com>
 <AANLkTikst-_dbPT7GLaEq8R7X7xjAgVGezpQEisEhFNp@mail.gmail.com> <AANLkTin2RxN_Jw8aCgAX3GzdHtb=WBf+_LTD99T5My12@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Freddie Cash <fjwcash@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin2RxN_Jw8aCgAX3GzdHtb=WBf+_LTD99T5My12@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 7, 2010 at 2:12 AM, Freddie Cash <fjwcash@gmail.com> wrote:
> On Mon, Dec 6, 2010 at 12:30 PM, Nirbheek Chauhan
> <nirbheek.chauhan@gmail.com> wrote:
>> But the behaviour of --inplace is not entirely to write out *only* t=
he
>> blocks that have changed. From what I could make out, it does the
>> following:
>>
>> (1) Calculate a delta b/w the src and trg files
>> (2) Seek to the first difference in the target file
>> (3) Start writing data
>
> That may be true, I've never looked into the actual algorithm(s) that
> rsync uses. =C2=A0Just played around with CLI options until we found =
the
> set that works best in our situation (--inplace --delete-during
> --no-whole-file --numeric-ids --hard-links --archive, over SSH with
> HPN patches).
>
>> I'm glossing over the final step because I didn't look deeper, but I
>> think you can safely assume that after the first difference, all dat=
a
>> is rewritten. So this is halfway between "rewrite the whole file" an=
d
>> "write only the changed bits into the file". It doesn't actually use
>> any CoW features from what I can see. There is lots of room for btrf=
s
>> reflinking magic. :)
>>
>> Note that I tested this behaviour on a btrfs partition with a vanill=
a
>> rsync-3.0.7 tarball; the copy you use with ZFS might be doing some C=
oW
>> magic.
>
> All the CoW "magic" is handled by the filesystem, and not the tools o=
n
> top. =C2=A0If the tool only updates X bytes, which fit into 1 block o=
n the
> fs, then only that 1 block gets updated via CoW.
>

I'm quite sure that's what happens in btrfs too, but the thing about
updating in-place is that if you have

ABCDXXXEFGH

which needs to change to

ABCDZZZEFGH

You're all good. Only the blocks corresponding to XXX will be updated.
But if the change is

ABCDZZZZEFGH

You'll need to start rewriting EFGH since there's no way to insert
data in the middle (afaik) of a file with standard syscalls. Maybe
later you get a set of changes which sync you up with the file's
contents again, but the chances of that happening in a large file are
quite remote. That's why I said that it can be safely assumed that
after the first difference, all data is rewritten.

The only way to get around this on the filesystem level that I can
think of is data de-duplication; the filesystem doesn't let go of the
blocks for a while, and does reflinking if the same data is written
again. Perhaps that's what ZFS is doing, I have no idea :)

--=20
~Nirbheek Chauhan

Gentoo GNOME+Mozilla Team
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
