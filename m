From: Francis Galiegue <fgaliegue@gmail.com>
Subject: Re: "parent transid verify failed", continued
Date: Sat, 25 Sep 2010 22:26:20 +0200
Message-ID: <AANLkTinwM3j5VSARoEQ2Kc8GaH46RvWKP=2+sjVANhGs@mail.gmail.com>
References: <AANLkTinw8zLRo=RPdxHciwt-UtUZcwHBQxJBY8SBFk6G@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinw8zLRo=RPdxHciwt-UtUZcwHBQxJBY8SBFk6G@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 23, 2010 at 08:24, Francis Galiegue <fgaliegue@gmail.com> w=
rote:
> Hello list,
>
> I've been using btrfs for nearly 6 months now, on three machines, wit=
h
> no problems but for _one_ filesystem on one machine. The problem is
> the message in $subject.
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
>
> I just fear that I get [for my rootfs] into the situation of the hose=
d filesystem
> which I cannot mount anymore...
>

And I just did. Dang.

=46ortunately I have the sysreccd with which I _can_ mount the filesyst=
em! Phew.

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
