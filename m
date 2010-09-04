From: Calvin Walton <calvin.walton@gmail.com>
Subject: Re: [PATCH 2/3] lib: improve the performance of memcpy and memmove
 of the general version
Date: Sat, 04 Sep 2010 08:59:02 -0400
Message-ID: <1283605142.9039.4.camel@ayu>
References: <4C7E2CAC.6080102@cn.fujitsu.com>  <82mxrzrsvq.fsf@mid.bfk.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: miaox@cn.fujitsu.com, Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Florian Weimer <fweimer@bfk.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <82mxrzrsvq.fsf@mid.bfk.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2010-09-03 at 11:03 +0000, Florian Weimer wrote:
> * Miao Xie:
> 
> >  EXPORT_SYMBOL(memcpy);
> 
> I think you need to change that to EXPORT_SYMBOL_GPL, because the code
> is now licensed under the GPL, and not the GPL plus kernel exceptions
> (whatever they are, but they undoubtly exist), unlike the original
> implementation.

I wouldn't think so - the intent of EXPORT_SYMBOL_GPL is to mark symbols
that make it obvious that a module was derived from the Linux kernel, as
opposed to some sort of generic driver that was just ported to a new
interface. (It's not foolproof, it's more of a warning to developers.)

If you think of it this way, memcpy is a function defined in the C
standard, there's absolutely nothing Linux-specific about using it.

Of course, IANAL; and you should probably grab some more opinions on the
matter.

-- 
Calvin Walton <calvin.walton@gmail.com>

