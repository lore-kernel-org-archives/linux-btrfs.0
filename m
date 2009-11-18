From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Somewhat borked filesystem in need of fixing
Date: Wed, 18 Nov 2009 10:40:57 +0800
Message-ID: <3d0408630911171840w3ee97037xa9fd5a1ee89f7253@mail.gmail.com>
References: <87r5rw3mj3.fsf@kiiro.naked.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Nuutti Kotivuori <naked@iki.fi>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87r5rw3mj3.fsf@kiiro.naked.iki.fi>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 18, 2009 at 4:48 AM, Nuutti Kotivuori <naked@iki.fi> wrote:
> Hello,
>
> I recently told here about a broken filesystem after btrfs-convert &
> friends and I was informed that this was a known bug and fixed in lat=
er
> releases. I should've reformatted the partition and copied in the fil=
es
> anew, but I didn't, since this isn't a crucial production system for =
me.
>
> So, after a day or two, I got in a case where I had done a hibernate,
> several suspend/resume cycles and exhausted the swap space so OOM kil=
ler
> was running wild and stuff.
>
> And I managed to get an endless stream of errors to the system log th=
at
> looked more or less like this:
>
> =A0parent transid verify failed on 39620608 wanted 5946 found 5944
>
> I don't know if I'd be able to reproduce the problem, if spending a l=
ot
> of time on it, but atleast for now, this was just a one time off case=
=2E
>
> So I rebooted the machine, and got the same stream of errors upon
> mounting the filesystem. 500 per second. So I tried fsck, and it gave
> the same error and promptly segmentation faulted. btrfs-image did the
> same I think (though I'm not sure about this one).
>
> Anyhow, I'd love to have a more reliable btrfsck, that is able to fix
> all kinds of corruptions, even then ones that are "never supposed to
> happen". So, personally, I'd like to work on this issue until btrfsck=
 is
> able to fix the filesystem in to perfect working order - or atleast i=
n
> such a good state, that files can be copied off from it.
>
> However, if you'd rather debug the mount problems, that can be done a=
s
> well - though that's more of a problem since I will have to do it in =
a
> virtual machine as to not mess up my server.
>
> Anyhow, long story short, here's the error reported by btrfsck:
>
> ---------------------------------------------------------------------=
------
> $ sudo ./btrfsck /dev/mapper/perspire-root
> parent transid verify failed on 39620608 wanted 5946 found 5944
> Segmentation fault
> ---------------------------------------------------------------------=
------
>
> And here's valgrind telling what goes awry:
>
> ---------------------------------------------------------------------=
------
> parent transid verify failed on 39620608 wanted 5946 found 5944
> =3D=3D17536=3D=3D Invalid read of size 4
> =3D=3D17536=3D=3D =A0 =A0at 0x40F9AB: btrfs_print_leaf (ctree.h:1411)
> =3D=3D17536=3D=3D =A0 =A0by 0x40C066: btrfs_lookup_extent_info (exten=
t-tree.c:1450)
> =3D=3D17536=3D=3D =A0 =A0by 0x4023F2: check_extents (btrfsck.c:2509)
> =3D=3D17536=3D=3D =A0 =A0by 0x405004: main (btrfsck.c:2829)
> =3D=3D17536=3D=3D =A0Address 0xc4 is not stack'd, malloc'd or (recent=
ly) free'd
> ---------------------------------------------------------------------=
------
>
> This is with the current head of btrfs-progs-unstable.
>

You can try mounting the FS in read only mode and copying files out.
If you still get that error, try making verify_parent_transid() in disk=
-io.c
always return 0. These are all we can do now.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
