From: Francis Galiegue <fgaliegue@gmail.com>
Subject: "parent transid verify failed", continued
Date: Thu, 23 Sep 2010 08:24:42 +0200
Message-ID: <AANLkTinw8zLRo=RPdxHciwt-UtUZcwHBQxJBY8SBFk6G@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

I've been using btrfs for nearly 6 months now, on three machines, with
no problems but for _one_ filesystem on one machine. The problem is
the message in $subject.

=46or this particular filesystem, which contains qemu-kvm disk images i=
n
raw mode with caching mode set to "writeback", the symptoms is that:

* in 2.6.34 and lower, I could mount the filesystem, with the "parent
transid verify failed" message appearing once;
* with 2.6.35+ and upper, however, not anymore: I mount it and the
same "parent transid very failed" message now floods dmesg, and I
cannot kill -9 any program trying to access that filesystem.

I sent a mail to the list at the time: I bisected that to
5bdd3536cbbe2ecd94ecc14410c6b1b31da16381. The problem is still there.

And this morning, while doing a btrfs filesystem defragment on the /
of one of my machines (the one I'm writing this mail from, in fact), I
saw this message four times again (kernel 2.6.36-rc5):

----
Sep 23 07:42:11 erwin kernel: [  148.689191] parent transid verify
failed on 14077947904 wanted 316581 found 316247
Sep 23 07:42:11 erwin kernel: [  148.689529] parent transid verify
failed on 14077947904 wanted 316581 found 316247
Sep 23 07:42:13 erwin kernel: [  151.059728] parent transid verify
failed on 14084829184 wanted 316581 found 316247
Sep 23 07:42:13 erwin kernel: [  151.060036] parent transid verify
failed on 14084829184 wanted 316581 found 316247
----

Does that mean that there is corruption on the filesystem, somewhere?
I just fear that I get into the situation of the hosed filesystem
which I cannot mount anymore...

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
