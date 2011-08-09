From: C Anthony Risinger <anthony@xtfx.me>
Subject: Re: BTRFS partition won't mount
Date: Tue, 9 Aug 2011 16:10:17 -0500
Message-ID: <CAGAVQTEUUjDHpXqANUhdu_AaNWSZmfbxx9DQyWCnM60rBmfUYA@mail.gmail.com>
References: <1F6ED4EA7957EB4FADAE461E036D456A25D75644F9@exch01lex.ceradyne.com>
 <20110803205031.GA18558@carfax.org.uk> <CAGAVQTE08--VM_uw2t0dDxSdqSEgZYAk52NTqgzJaXNr+OFoRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo@carfax.org.uk>, Adam Newby <anewby@ceradyne.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAGAVQTE08--VM_uw2t0dDxSdqSEgZYAk52NTqgzJaXNr+OFoRA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 8, 2011 at 10:54 PM, C Anthony Risinger <anthony@xtfx.me> w=
rote:
> On Wed, Aug 3, 2011 at 3:50 PM, Hugo Mills <hugo@carfax.org.uk> wrote=
:
>>
>> =C2=A0 Try the instructions on the wiki at [1]. (And please feed bac=
k
>> and/or fix any issues you have with the instructions -- they're stil=
l
>> quite new and probably have awkward corners).
>>
>> [1] https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_can.27t_mo=
unt_my_filesystem.2C_and_I_get_a_kernel_oops.21
>
> this worked perfectly for me ... just saved my night from tedious
> restoration :-)
>
> im on kernel 3.0.1 -- hard poweroff led to that problem. =C2=A0i have=
n't
> had any issues for some time ... im not sure what the problem was
> exactly, but sometimes systemd gets a little twacky and takes a year
> to shutdown ... guess i got a little impatient :-)
>
> anyways, thanks for the integration work!

well i tried to shutdown again and had to force poweroff via `echo b >
/proc/sysrq-trigger` (but this time it was because dbus segfaulted and
i couldnt ask systemd to reboot ... `kill -INT 1` wasn't working
either, maybe all systemd related)

=2E.. the same thing happened again.  i'm wondering if btrfs is causing
the hang to begin with?  i will watch it after i fix it tonight by
making systemd more verbose and see what it has to say.  im wondering:

) what else i could try to determine if btrfs is contributing to the is=
sue
) any other more graceful options than `echo b > /proc/sysrq-trigger` e=
xist

thanks,

--=20

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
