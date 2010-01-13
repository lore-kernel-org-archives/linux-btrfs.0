From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: snapshots of directories
Date: Wed, 13 Jan 2010 22:04:47 +0300
Message-ID: <2a31deca1001131104s1181bc89nbcc719d0b9e4b0ab@mail.gmail.com>
References: <20100112031243.09e072b0@simplux> <4B4BDC36.4000304@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: mniederle@gmx.at, linux-btrfs@vger.kernel.org
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B4BDC36.4000304@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Did I get you right in that btrfs does not support snapshots of an
arbitrary directory?

Regards,
Andrey




On Tue, Jan 12, 2010 at 5:19 AM, TARUISI Hiroaki
<taruishi.hiroak@jp.fujitsu.com> wrote:
> In btrfs, snapshot is a clone of subvolume, not arbitrary
> directory.
> You specified '/root' directory and it is not subvolume,
> snapshot is created for parent subvolume, root of filesystem.
>
> Regards,
> taruisi
>
> (2010/01/12 11:12), Michael Niederle wrote:
>> I try to take a snapshot of a single directory, e.g. root:
>>
>>> btrfsctl -s root.2010-01-12 /root
>> operation complete
>> Btrfs v0.19-4-gab8fb4c-dirty
>>
>> Then I take look what's inside the newly created snapshot:
>>
>>> ls -l /root.2010-01-12/
>> total 0
>> drwxr-xr-x 1 root root 1192 2010-01-03 20:32:12 bin
>> drwxr-xr-x 1 root root =A0 76 2009-06-25 =A00:40:35 boot
>> drwxr-xr-x 1 root root 1756 2010-01-12 =A02:33:07 cmds
>> drwxr-xr-x 1 root root =A0 =A00 2010-01-06 12:21:46 data
>> drwxr-xr-x 1 root root 4356 2010-01-12 =A02:07:00 dev
>> drwxr-xr-x 1 root root =A0 42 2010-01-04 12:29:45 downloads
>> drwxr-xr-x 1 root root 4528 2010-01-12 =A02:12:12 etc
>> drwxr-xr-x 1 root root =A0 52 2010-01-11 12:57:47 home
>> drwxr-xr-x 1 root root =A0 =A00 2007-11-10 =A04:44:07 initrd
>> drwxr-xr-x 1 root root 4490 2010-01-05 20:15:53 lib
>> drwxr-xr-x 1 root root =A0124 2008-04-27 14:53:39 mnt
>> drwxr-xr-x 1 root root =A0 62 2008-01-08 =A00:21:58 net
>> drwxr-xr-x 1 root root =A0 =A00 2008-04-09 =A03:19:16 objects
>> drwxr-xr-x 1 root root =A0316 2009-12-28 23:23:13 opt
>> dr-xr-xr-x 1 root root =A0 =A00 2007-11-10 =A03:35:28 proc
>> drwxr-xr-x 1 root root 7676 2010-01-11 =A00:35:41 root
>> drwxr-xr-x 1 root root =A0 =A00 2010-01-12 =A01:56:17 save
>> drwxr-xr-x 1 root root =A0 =A00 2010-01-12 =A01:55:58 save2
>> drwxr-xr-x 1 root root 3804 2010-01-06 =A02:36:08 sbin
>> drwxr-xr-x 1 root root =A0 =A00 2007-11-10 =A03:35:28 sys
>> drwxr-xr-x 1 root root =A0358 2010-01-11 18:44:29 tmp
>> drwxr-xr-x 1 root root =A0176 2009-12-29 17:08:37 usr
>> drwxr-xr-x 1 root root =A0 72 2010-01-05 20:03:00 var
>>
>> It seems that always a snapshot of the root is taken instead one of =
the
>> specified directory? Is this by design?
>>
>> Snapshotting the root works fine, but if you take several snapshots =
it's a bit
>> "recursive", because every new snapshot contains all previous snapsh=
ots.
>>
>> Greetings, Michael
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrf=
s" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
