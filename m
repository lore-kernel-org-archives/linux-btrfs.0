From: Francis Galiegue <fgaliegue@gmail.com>
Subject: Any btrfsck to try out? [was: "parent transid verify failed", continued]
Date: Thu, 23 Sep 2010 22:17:08 +0200
Message-ID: <AANLkTikNVUXdCXz7bquPV=wYHBN-y1Pbhvv1hb9hzNpu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 23, 2010 at 08:24, Francis Galiegue <fgaliegue@gmail.com> w=
rote:
[...]
>
> For this particular filesystem, which contains qemu-kvm disk images i=
n
> raw mode with caching mode set to "writeback", the symptoms is that:
>
> * in 2.6.34 and lower, I could mount the filesystem, with the "parent
> transid verify failed" message appearing once;
> * with 2.6.35+ and upper, however, not anymore: I mount it and the
> same "parent transid very failed" message now floods dmesg, and I
> cannot kill -9 any program trying to access that filesystem.
>
[...]

Another thing: as I can afford to recreate the hosed filesystem if
need be, I'm also ready to try any offline (of course) repairing
btrfsck on this filesystem and see if I can mount it again safely.

Any btrfs-progs tree that I might try out? I have the possibility to
boot from a USB key with a sufficiently recent kernel and test that,
and attempt to mount the fs again...

--=20
=46rancis Galiegue, fgaliegue@gmail.com
"It seems obvious [...] that at least some 'business intelligence'
tools invest so much intelligence on the business side that they have
nothing left for generating SQL queries" (St=C3=A9phane Faroult, in "Th=
e
Art of SQL", ISBN 0-596-00894-5)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
