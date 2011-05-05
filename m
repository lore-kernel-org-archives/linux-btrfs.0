From: cwillu <cwillu@cwillu.com>
Subject: Re: Cannot Deinstall a Debian Package
Date: Thu, 5 May 2011 14:31:17 -0600
Message-ID: <BANLkTinkhtYYFx+eKQzdrRDSvpgEiPHzpQ@mail.gmail.com>
References: <201105031227.43619.CACook@quantum-sci.com>
	<201105050749.09690.CACook@quantum-sci.com>
	<BANLkTi=_mucea2-nPE54dgkuR3B9mU0o7g@mail.gmail.com>
	<201105051250.03335.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105051250.03335.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 5, 2011 at 1:50 PM,  <CACook@quantum-sci.com> wrote:
>
> I was afraid of this finger-pointing.
>
> Of course no one at Debian is going to know how to fix BTRFS jamming =
the package management system. =C2=A0That's ridiculous.

I took the liberty of asking #debian, and they've requested that you
file a bug in their bug tracker.  They've also suggested that you
might be able to short-circuit the faulty script in their kernel
package via an "exit 0", or even replace the faulty grub-probe by
manually extracting the newer version of the package.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
