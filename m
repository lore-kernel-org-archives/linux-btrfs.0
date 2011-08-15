From: Edward Ned Harvey <kernel@nedharvey.com>
Subject: RE: licenses (for apple OSX and others)?
Date: Sun, 14 Aug 2011 22:00:37 -0400
Message-ID: <003201cc5aef$23baccb0$6b306610$@nedharvey.com>
References: <CAPr7RtVfNtNno=7KTJvyvNFnkumHd3PiJSo8eoswBZT-0vwFQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
To: "'ivo welch'" <ivowel@gmail.com>, <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPr7RtVfNtNno=7KTJvyvNFnkumHd3PiJSo8eoswBZT-0vwFQA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of ivo welch
> 
> curiosity question---could btrfs be licensed in multiple ways to allow
> Apple and other vendors to adopt it?  

No.  The source code is copyrighted by many different entities, and the only
way to release it under any other license would require all of the
contributors to mutually agree.  It'll never happen.  Likewise, perhaps
Apple could release their code under a license that's compatible with GPL,
but I seriously doubt that would ever happen.


> as end users, having one good
> file system that works everywhere as a main root system would be
> heaven...

Agreed.  But the various producers of filesystems are generally commercial
entities interested in making a profit.  For various reasons, many of them
intentionally don't go this direction.  They're all trying to differentiate
themselves.

Generally speaking, the problem is the requirement to integrate some other
FS into a kernel or other component that requires license compatibility for
booting.  Generally speaking you can circumvent this problem by using things
like Fuse to mount a filesystem in user space, thus not requiring it to be
built into the kernel, thus eliminating any license compatibility problems.

