From: Yan Zheng <yanzheng@21cn.com>
Subject: Re: First impression (pure user)
Date: Tue, 28 Jul 2009 19:59:21 +0800
Message-ID: <3d0408630907280459n4a150c1bs8e5e4c50f3832a82@mail.gmail.com>
References: <200907241237.18071@fortytwo.ch> <20090728112218.GC3667@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Adrian von Bidder <avbidder@fortytwo.ch>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090728112218.GC3667@think>
List-ID: <linux-btrfs.vger.kernel.org>

2009/7/28 Chris Mason <chris.mason@oracle.com>:
> On Fri, Jul 24, 2009 at 12:37:13PM +0200, Adrian von Bidder wrote:
>> Heyho!
>>
>> Just a first impression report from a pure user. =A0I've started to =
play
>> around with btrfs a bit, without using any btrfs-specific features s=
o far,
>> though.
>
> Hi, thanks for sending this along.
>
>>
>> 700G, ca. 1/2 full, tons of small files, lots of hardlinks ("dirvish=
" backup
>> trees of my workstations at home.)
>>
>> The disk is currently attached to a very old machine that serves as =
home
>> server/router, so only 128M RAM and very slow CPU (350MHz PentiumII.=
) =A0And
>> only USB 1, no less, which I didn't realize when I bought the disk :=
-)
>> Since dirvish only writes new files, I can live with it for now.
>>
>> Software: Debian packages, btrfs-tools 0.19 and kernel 2.6.31-rc1 (s=
oon to
>> be rc3)
>>
>> btrfs-convert (using my desktop, which is more or less ok performanc=
e-wise,
>> not the old machine): still took ca. 10h.
>
> The btrfs-convert speeds are mostly limited by the speed that you can
> read the ext3 metadata and data. =A0If you do the conversion without =
doing
> csums, it is faster because it doesn't have to read the ext3 data.
>
>> =A0* some progress indication would be nice (needn't be very accurat=
e, but it
>> would be nice if it could tell me if I'm about to wait another hour =
or
>> another day...)
>
> Definitely.
>
>> =A0* documentation: what happens when I kill btrfs-convert? =A0Will =
I have an
>> ext3 with only free space having been written to, or will I have an
>> unfinished btrfs that I need to rollback with btrfs-convert? =A0Docu=
mentation
>> would be nice. =A0(I haven't tried what happens.)
>
> You'll have one or the other, but not something halfway between.
>>
>> Ok, now I have a btrfs, attached it to the old router.
>>
>> I'm now collecting data if the slow CPU or the slow USB is worse by
>> enabling/disabling -o compress on the mount (will metadata be compre=
ssed as
>> well?)
>
> Only data is compressed.
>
>>
>> Since it basically worked: now tried to delete the image file in the
>> ext2_saved subvolume, which exposed very unexpected behaviour: =A0it=
 takes
>> ages (ok, we're still on USB1 and the file is huge, after all) and t=
hen it
>> kicks the oom killer into action; the system then becomes unusable. =
=A0Plenty
>> of swapspace free, so I guess "rm" uses quite a bit kernel memory. =A0=
The
>> backtraces I've seen all are just about tasks the OOM killer got rid=
 of,
>> nothing into the btrfs code.
>
> Ouch, I haven't seen this but I'll try to reproduce it.
>

This isn't surprising me. Deleting the image involves almost all used
extents in the filesystem. It can create large number of delayed refs.
Besides, btrfs_delete_inode does its work in single transaction.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
