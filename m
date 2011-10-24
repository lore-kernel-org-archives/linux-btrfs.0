From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: Kernel BUG unable to handle kernel NULL pointer dereference
Date: Mon, 24 Oct 2011 12:33:05 +0100
Message-ID: <CAAeznTpSsKSMe7udHH1kZmFNg6ROf4czxriNpPh_Trb_PHbtzg@mail.gmail.com>
References: <CAAeznTqh1W0W743WxTO+iUfajgsMw-A6abwr1fAZ6hWOJOnw2Q@mail.gmail.com>
	<CAKcLGm-+g9xy_aL2Z_F2VYG8qFsXonB7nutM1VSs5sqLZz2PGA@mail.gmail.com>
	<CAAeznTpDmT7NgZdAHh7uVPBnKtitr=SmLRvfFKrd_exG6XLE9w@mail.gmail.com>
	<20111024112259.GE26547@ds.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs@vger.kernel.org
To: dsterba@suse.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111024112259.GE26547@ds.suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 24, 2011 at 12:22 PM, David Sterba <dsterba@suse.cz> wrote:
> On Sun, Oct 23, 2011 at 07:24:42PM +0100, Leonidas Spyropoulos wrote:
>> On Sun, Oct 23, 2011 at 4:37 PM, Mitch Harder
>> <mitch.harder@sabayonlinux.org> wrote:
>> > A patch was submitted by Sergei Trofimovich to address the issue w=
ith
>> > handling a NULL pointer in btrfs_print_leaf.
>> >
>> > http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg12021.h=
tml
>
> afaik the patch should be enqueued for 3.2
>
>> How can I track down the real problem? Any suggestions?
>
> The preceding function in the stack was __btrfs_free_extent, there ar=
e 3
> instances of btrfs_print_leaf() in that function, 2 of them relevant:
>
> 4470 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
printk(KERN_ERR "umm, got %d back from search"
> 4471 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0", was looking for %llu\n", ret,
> 4472 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0(unsigned long long)bytenr);
>
>
> 4494 #ifdef BTRFS_COMPAT_EXTENT_TREE_V0
> ...
> 4511 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR =
"umm, got %d back from search"
> 4512 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"=
, was looking for %llu\n", ret,
> 4513 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(=
unsigned long long)bytenr);
> 4514 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_print_leaf=
(extent_root, path->nodes[0]);
> ...
> =A0 =A0 #endif
>
> and the third one without a pre-message
>
> 4481 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 btrfs_print_leaf(extent_root, pa=
th->nodes[0]);
> 4482 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 WARN_ON(1);
> 4483 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk(KERN_ERR "btrfs unable to=
 find ref byte nr %llu "
> 4484 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"parent %llu root=
 %llu =A0owner %llu offset %llu\n",
> 4485 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long lo=
ng)bytenr,
> 4486 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long lo=
ng)parent,
> 4487 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long lo=
ng)root_objectid,
> 4488 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long lo=
ng)owner_objectid,
> 4489 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(unsigned long lo=
ng)owner_offset);
>
>
> your original report does not contain any messages before the BUG
> listing, so I'm not sure which one it is.

I got the whole log somwehre lying arround, let me find it and give a
pastbin link

Here is it, it's big and contains usless information..

http://paste.pocoo.org/show/497299/

>
> Supposed it's the 3rd, it's resulting from an error returned by
>
> 4429 =A0 =A0 =A0 =A0 ret =3D lookup_extent_backref(trans, extent_root=
, path, &iref,
> 4430 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 bytenr, num_bytes, parent,
> 4431 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 root_objectid, owner_objectid,
> 4432 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 owner_offset);
>
> ret !=3D 0 -> print leaf etc, a missing backref could be the problem =
here.
>
> Are you able to trigger the BUG() repeatedly?

No I cannot reproduce it intentionally, it was quite random, while
playing something in the SMPlayer - think it was a movie. The movie
kept playing, and I can start programs (that was on the memory I
assume), couldn't access the FS at all. ls failed for example.
So I just hard-reboot and hoped all was alright.

So far I didn't see any problems after that.



>
>
> david
>


Thanks for checking it

Regards
Leonidas


--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
