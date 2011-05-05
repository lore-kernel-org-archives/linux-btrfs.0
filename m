From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Cannot Deinstall a Debian Package
Date: Thu, 05 May 2011 15:55:44 -0400
Message-ID: <1304625253-sup-3665@think>
References: <201105031227.43619.CACook@quantum-sci.com> <201105050749.09690.CACook@quantum-sci.com> <BANLkTi=_mucea2-nPE54dgkuR3B9mU0o7g@mail.gmail.com> <201105051250.03335.CACook@quantum-sci.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook <cacook@quantum-sci.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <201105051250.03335.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from CACook's message of 2011-05-05 15:50:02 -0400:
> 
> I was afraid of this finger-pointing.

We're not finger pointing, but we also don't maintain the script that is
failing.  I'm happy to patch up bugs in the FS (or point you to newer
kernels that have them fixed) but at this point we don't have enough
info to say if it is an FS problem or a debian package problem.

Perhaps if you ran it under strace?

Other distros don't have problems with btrfs on /, so somehow this is
specific to debian's setup.

-chris
