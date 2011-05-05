From: cwillu <cwillu@cwillu.com>
Subject: Re: Cannot Deinstall a Debian Package
Date: Thu, 5 May 2011 14:40:25 -0600
Message-ID: <BANLkTim3uMUXN7Q=zqXoopUeR8gphWHi_Q@mail.gmail.com>
References: <201105031227.43619.CACook@quantum-sci.com>
	<201105051250.03335.CACook@quantum-sci.com>
	<1304625253-sup-3665@think>
	<201105051332.20992.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105051332.20992.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 5, 2011 at 2:32 PM,  <CACook@quantum-sci.com> wrote:
> Here is the relevant section of strace:

> BTW, I fixed the 'no space left on device' on the other machine with =
a btrfs balance. =C2=A0No one seems to know this, but even though df re=
ports that 64% of the disk array is used, apparently one of the disks d=
id get full somehow and was preventing even a simple mkdir. =C2=A0But a=
 balance fixed it.
>
> I thought balancing was supposed to be automatic in BTRFS?
>
> Is defrag not automatic?

Could you include the information I asked for previously?  (Kernel
version, output of btrfs fi df and btrfs fi show)

Defrag is not the same as balancing, and neither is quite the same as
the balancing of the internal b-trees that make up the filesystem.
Either way, this sounds like a bug that was fixed a few releases ago,
but it's hard to say if that's the case without the requested
information.

Also, please place your replies below the original text, not above it.
 That's common practice on development mailing lists, and makes
following the conversation much easier for others.
http://www.catb.org/~esr/faqs/smart-questions.html may be a useful
read as well.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
