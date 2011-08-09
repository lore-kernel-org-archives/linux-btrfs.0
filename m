From: C Anthony Risinger <anthony@xtfx.me>
Subject: Re: BTRFS partition won't mount
Date: Mon, 8 Aug 2011 22:54:04 -0500
Message-ID: <CAGAVQTE08--VM_uw2t0dDxSdqSEgZYAk52NTqgzJaXNr+OFoRA@mail.gmail.com>
References: <1F6ED4EA7957EB4FADAE461E036D456A25D75644F9@exch01lex.ceradyne.com>
 <20110803205031.GA18558@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo@carfax.org.uk>, Adam Newby <anewby@ceradyne.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110803205031.GA18558@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 3, 2011 at 3:50 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>
> =C2=A0 Try the instructions on the wiki at [1]. (And please feed back
> and/or fix any issues you have with the instructions -- they're still
> quite new and probably have awkward corners).
>
> [1] https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#I_can.27t_mou=
nt_my_filesystem.2C_and_I_get_a_kernel_oops.21

this worked perfectly for me ... just saved my night from tedious
restoration :-)

im on kernel 3.0.1 -- hard poweroff led to that problem.  i haven't
had any issues for some time ... im not sure what the problem was
exactly, but sometimes systemd gets a little twacky and takes a year
to shutdown ... guess i got a little impatient :-)

anyways, thanks for the integration work!

--=20

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
