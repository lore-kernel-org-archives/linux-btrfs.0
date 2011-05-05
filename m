From: cwillu <cwillu@cwillu.com>
Subject: Re: Cannot Deinstall a Debian Package
Date: Thu, 5 May 2011 15:11:39 -0600
Message-ID: <BANLkTimskmBv_DTe-vDmVtf+sAWBEJxwHQ@mail.gmail.com>
References: <201105031227.43619.CACook@quantum-sci.com>
	<201105051250.03335.CACook@quantum-sci.com>
	<BANLkTinkhtYYFx+eKQzdrRDSvpgEiPHzpQ@mail.gmail.com>
	<201105051357.07209.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105051357.07209.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 5, 2011 at 2:57 PM,  <CACook@quantum-sci.com> wrote:
>
> On Thursday 5 May, 2011 13:31:17 cwillu wrote:
>> I took the liberty of asking #debian, and they've requested that you
>> file a bug in their bug tracker. =C2=A0They've also suggested that y=
ou
>> might be able to short-circuit the faulty script in their kernel
>> package via an "exit 0", or even replace the faulty grub-probe by
>> manually extracting the newer version of the package.
>
> I tried to install Debian's reportbug, but of course I can't. =C2=A0A=
nd assembling the info they need for email reporting will take me a hal=
f day of analysis. =C2=A0Part of the problem here is I am trying desper=
ately to make a living in another line of business, and I don't have ti=
me for any of these problems.
>
> I don't know how to manually extract a package. =C2=A0I guess it's do=
ne with dpkg, but that will take more time for me to figure out. =C2=A0=
I've lost half of today already on this problem.

Okay, but do you see how your reaction hasn't endeared yourself to the
people you're depending on to fix your problems for free?  I'll note
that this isn't the first time you've run into troubles with various
raid systems, and you were even warned last december not to switch to
btrfs as it wasn't mature enough for an end-user (even lacking a
recovering fsck tool, which is still under development).

In your position, you should be using ext4, with no raid, with a solid
system of backups that you can recover from quickly and easily.  Not
experimenting with the latest shiny developments:  that's something
you do if you can afford to spend a few days on a regular basis fixing
the latest exciting quirk.  And when you run into problems,
respectfully following the instructions given to you, including taking
the advice of those who do this for a living, as opposed to issuing
threats to besmirch a tool that wasn't ever marketed as being ready to
use for the average joe who doesn't want to spend hours dealing with
it.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
