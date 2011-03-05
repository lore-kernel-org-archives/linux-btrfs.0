From: David Nicol <davidnicol@gmail.com>
Subject: Re: [PATCH V2] btrfs: implement delayed inode items operation
Date: Fri, 4 Mar 2011 21:44:29 -0600
Message-ID: <AANLkTikr21czNX=OsWH3JKAFdYzcsAkE-eqQiGOzDosV@mail.gmail.com>
References: <4D5CB6B8.2060804@cn.fujitsu.com> <1297991261-sup-6831@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Miao Xie <miaox@cn.fujitsu.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297991261-sup-6831@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 17, 2011 at 7:09 PM, Chris Mason
>
> This work is really cool, thanks for doing it. =C2=A0I'm starting a r=
un on
> this tonight and if all goes well I'll review in detail and try to qu=
eue
> it along with the per-subvolume storage bits for .39.
>
> Thanks!
>
> -chris



This is the kind of thing -- another synchronous thing becomes
asynchronous -- why the ioctl#21 patch has a pluggable architecture
for adding a standard way to wait for completion of new dlayed items.
Please add it, so future submitted ways to asynchonify things can have
a standard way to tell when they're done.

dln
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
