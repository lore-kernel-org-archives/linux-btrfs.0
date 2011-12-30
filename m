From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Re: Two way mirror in BRTFS
Date: Fri, 30 Dec 2011 21:33:38 +0700
Message-ID: <CAG1y0sf8D1Nfzz90Dn5yun6d9CYjvT6xoZGo5DE29OkguHVuAw@mail.gmail.com>
References: <CAG1y0sd2AvxucVJ5BKc4ysu08gS6SF7GJNX2DiP17co_NN6xLg@mail.gmail.com>
	<135535.24205.61145-582-206632053-1325253564@email.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: jaromir.zdrazil@email.cz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <135535.24205.61145-582-206632053-1325253564@email.cz>
List-ID: <linux-btrfs.vger.kernel.org>

2011/12/30 Jaromir Zdrazil <jaromir.zdrazil@email.cz>:
>> > Just to add, I would like to see a two way mirror solution, but if=
 it will not
>> work now/is not implemnted yet, I would propably choose between drbd=
 in
>> asynchronous mode or make a some kind if "incremental" snapshot to a=
 remote
>> mapped disk (I do not know yet, if brtfs support it) =A0- it means h=
ave one
>> shapshop and let's say have a daily incremental update of this snaps=
hot.
>>
>> You mean like "zfs send -i"? If yes, why not just use zfs? There's
>> zfsonlinux project, with easy-to-install ppa for ubuntu. Or you coul=
d
>> compile it manually.
>>
> Thank you for your suggestion. As I know, there is not everything por=
ted yet, and one of the missing important features I plan to use is to =
crypt fs.

correct. But btrfs doesn't do encryption as well.
And if you're thinking of using luks/dm-crupt to provide encryption
for btrfs, there's nothing preventing you to use the same thing with
zfs.

> And if I am not mistaken, current version does not yet support a moun=
table filesystem.

You're mistaken :) With some extra work, you can even use it as root:
- http://zfsonlinux.org/example-zpl.html
- https://github.com/dajhorn/pkg-zfs/wiki/HOWTO-install-Ubuntu-to-a-Nat=
ive-ZFS-Root-Filesystem

>> >
>> > How would you do it?
>>
>> If you DO mean zfs-send-like-functionality, then you should ask abou=
t
>> "btrfs send and receive", not "two way mirror" (which is not an
>> accurate way to describe what you want). Also, send/receive ability
>> does not mean it can act as two-way mirror. It CAN be an alternative
>> to drbd async though.
>
> If I understand it correctly, the diff between send and receive and t=
wo way mirror is that one is synchronous and the other is not (sends th=
e signal that the file have been succesfully written after all/one inst=
ance have been succesfully written).
> Maybe you can explain it a bit more.

Two way: A replicates changes to B, and B can replicate it's own change=
s to A
One way: A replicates changes to B, but B can not replicate it's own
changes to A

While drbd only supports synchronous mode for active-active setup, the
generic "two way replication" does not have to be so. Also, just
because something is synchronous does not automatically mean it
supports two-way replication.

Either way, neither zfs or the (planned) btrfs send/receive supports
two-way/active-active setup. Both should (or will) work just fine for
one-way replication.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
