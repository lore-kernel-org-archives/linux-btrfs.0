From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Btrfs system won't start on Ubuntu (relationship problems...)
Date: Mon, 14 Mar 2011 06:34:11 +0700
Message-ID: <AANLkTin=F0+_cjkw2oXDxcZDLdqBWUzQKbCkrMDr9yFo@mail.gmail.com>
References: <AANLkTi=4VaXSZgeN-DeohPduQ_8FiuEroNpKCD3bTSPK@mail.gmail.com>
	<20110313114616.8860.qmail@stuge.se>
	<AANLkTimtN0FWG95dzjwzOzZoQaHEzL7t5ffZchR=BZAu@mail.gmail.com>
	<20110313163048.5321.qmail@stuge.se>
	<AANLkTin9FG5npgKS_Hj16mXFb17ixmM6XddWw45zEW62@mail.gmail.com>
	<AANLkTikTpT8QYiU8MMA=d1Wwr-2g-QCqmJWtc1sq+wiE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikTpT8QYiU8MMA=d1Wwr-2g-QCqmJWtc1sq+wiE@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 13, 2011 at 11:46 PM, J=E9r=F4me Poulin <jeromepoulin@gmail=
=2Ecom> wrote:
> As a sidenote USB converters don't have low level access to the disk
> so it also makes smartctl and stuff not working at all.

That depends on the disk and controller.
I had an old USB controller with PATA disk, smartctl was unusable on it=
=2E
Smartctl was perfectly usable on another one with SATA disk in it.

> I was not able to find any USB converter which was working correctly
> using ddrescue and a defective disk yet.

That would also depend on kernel version. My disk was having some bad
sectors, and with an old version of Ubuntu (forgot which one exactly)
running e2fsck -c (to check the badblocks) failed because USB resets
keep happening and the disk was finally undetected, while on Ubuntu
maverick (kernel 2.6.35) the check was completed and badblocks marked
correctly. dd_rescue should also work, and you might want to use a
bigger value for "-B" so it would be faster.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
