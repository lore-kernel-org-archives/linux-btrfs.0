From: jlcenter@comcast.net
Subject: Re: btrfs open_ctree failed (after recent Ubuntu update)
Date: Sun, 19 Feb 2012 19:03:28 +0000 (UTC)
Message-ID: <1236042020.1069615.1329678208635.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
References: <201202191000.34819.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201202191000.34819.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I was curious, if one goes the route of upgrading the kernel, how does one upgrade the btrfs tools?

Thanks.

    -John

----- Original Message -----
From: "Chris Samuel" <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Cc: "Curtis Jones" <curtis.jones@gmail.com>
Sent: Saturday, February 18, 2012 6:00:27 PM
Subject: Re: btrfs open_ctree failed (after recent Ubuntu update)

On Sunday 19 February 2012 07:34:22 Curtis Jones wrote:

> Any help would be appreciated. Thank you. Please CC me on any
> replies.
>
> Linux veriton 3.0.0-16-generic-pae #28-Ubuntu SMP Fri Jan 27
> 19:24:01 UTC 2012 i686 i686 i386 GNU/Linux

That's a fairly old kernel in btrfs terms, you may want to try the 
latest 3.2.x kernel from the Ubuntu Mainline Kernel PPA here:

http://kernel.ubuntu.com/~kernel-ppa/mainline/

If that doesn't work out you can try the latest 3.3 RC there too.

I'm running the 64-bit 3.2.5 kernel from there on Kubuntu 11.10 and it 
is fine (modulo boot time complaints about the apparmour stuff).

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
For more info see: http://en.wikipedia.org/wiki/OpenPGP
