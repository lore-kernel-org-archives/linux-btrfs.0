From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Broken btrfs?
Date: Fri, 22 Jul 2011 09:24:08 +0200
Message-ID: <4E292598.2090308@jan-o-sch.net>
References: <20110716214404.50480@gmx.net> <loom.20110717T160020-81@post.gmane.org> <4E23EED3.8000301@jan-o-sch.net> <4E28965F.1010508@GMX.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Jan Schubert <Jan.Schubert@GMX.li>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E28965F.1010508@GMX.li>
List-ID: <linux-btrfs.vger.kernel.org>

On 21.07.2011 23:13, Jan Schubert wrote:
> On 07/18/2011 10:29 AM, Jan Schmidt wrote:
>> If you are on a 3.0 kernel, get the most current version of btrfs
>> tools from Hugo's integration-20110705 branch at
>> http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ and do a
>> scrub. -Jan 
> 
> Thx Jan, I did. This is the result:
> 
> scrub status for 03201fc0-7695-4468-9a10-f61ad79f23ca
>         scrub started at Thu Jul 21 22:27:31 2011 and finished after 787
> seconds
>         total bytes scrubbed: 173.91GB with 2211 errors
>         error details: csum=2211
>         corrected errors: 0, uncorrectable errors: 2211
> 
> Any help what to do now? Should I stick with this filesystem or create a
> new one?

Well, you won't be able to repair the broken files. You can create a new
filesystem. It is not guaranteed that this won't result in similar
problems, though. You might have a built on a sandy hard drive.

> The good thing is, running 3.0 does not crash the system anymore while
> accessing corrupt data but just printing an I/O error.

Scrub should be printing inode numbers to your system log while
detecting those errors. If you want to know the exact files corrupted,
you can grab my patch set with subject "Btrfs scrub: print path to
corrupted files and trigger nodatasum fixup" from the list and give it a
try.

-Jan
