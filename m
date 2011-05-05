From: CACook@quantum-sci.com
Subject: Re: Cannot Deinstall a Debian Package
Date: Thu, 5 May 2011 12:50:02 -0700
Message-ID: <201105051250.03335.CACook@quantum-sci.com>
References: <201105031227.43619.CACook@quantum-sci.com> <201105050749.09690.CACook@quantum-sci.com> <BANLkTi=_mucea2-nPE54dgkuR3B9mU0o7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=_mucea2-nPE54dgkuR3B9mU0o7g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


I was afraid of this finger-pointing.

Of course no one at Debian is going to know how to fix BTRFS jamming the package management system.  That's ridiculous.

It's starting to look like BTRFS is just busted in Debian, and I'll have to reinstall everything over a different filesystem.  I hate to give up btrfs raid and snapshotting, but these failures are just unlivable.  Is Oracle aware of this?  I'll have to warn others in the various forums that BTRFS breaks Debian, because no one warned me.  This is unlivable, not to mention unbelievable.


On Thursday 5 May, 2011 12:28:19 cwillu wrote:
> You'll need to contact somebody more familiar with debian, as this
> isn't really a btrfs issue.
> 
> Yes, btrfs is the obvious cause, but it's grub's handling of it that
> is the problem, and dpkg's handling of grub's failure that is really
> blocking you.
> 
> This is what it meant by "does debian support btrfs?".  It's not a
> question of whether btrfs is in debian's kernel, but whether all the
> pieces of debian which are directly or indirectly affected by btrfs
> are known to work right, and whether they're currently willing to
> spend effort on these issues.
> 
> If they're not currently providing that level of support, then it's
> completely up to you to have a good understanding of how the rest of
> debian is put together so that you yourself can make things works.
> 
> As was mentioned previously, there is an updated grub package, so your
> main objective is to find out from debian how to disable or override
> the failing package long enough to install the replacement.
> 
> 
