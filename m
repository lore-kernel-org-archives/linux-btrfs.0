From: Jan Schubert <Jan.Schubert@GMX.li>
Subject: Re: Broken btrfs?
Date: Thu, 21 Jul 2011 23:13:03 +0200
Message-ID: <4E28965F.1010508@GMX.li>
References: <20110716214404.50480@gmx.net> <loom.20110717T160020-81@post.gmane.org> <4E23EED3.8000301@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E23EED3.8000301@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/18/2011 10:29 AM, Jan Schmidt wrote:
> If you are on a 3.0 kernel, get the most current version of btrfs
> tools from Hugo's integration-20110705 branch at
> http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ and do a
> scrub. -Jan 

Thx Jan, I did. This is the result:

scrub status for 03201fc0-7695-4468-9a10-f61ad79f23ca
        scrub started at Thu Jul 21 22:27:31 2011 and finished after 787
seconds
        total bytes scrubbed: 173.91GB with 2211 errors
        error details: csum=2211
        corrected errors: 0, uncorrectable errors: 2211

Any help what to do now? Should I stick with this filesystem or create a
new one?

The good thing is, running 3.0 does not crash the system anymore while
accessing corrupt data but just printing an I/O error.

TiA,
Jan

