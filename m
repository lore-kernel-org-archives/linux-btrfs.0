From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Broken btrfs?
Date: Mon, 18 Jul 2011 10:29:07 +0200
Message-ID: <4E23EED3.8000301@jan-o-sch.net>
References: <20110716214404.50480@gmx.net> <loom.20110717T160020-81@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Jan Schubert <Jan.Schubert@GMX.li>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20110717T160020-81@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 17.07.2011 16:01, Jan Schubert wrote:
> Jan Schubert <jan.schubert <at> gmx.li> writes:
>> Please find some data and log below. Is there any chance to fix this?
>
> After playing around (incl. deleting the log) I get the strong feeling
> it has something todo with compression=lzo. Dunno why it started suddenly
> but I disabled compression and did reinstall everything which helped a
lot.
> I still have some broken configuration and other (non reinstalable) files
> which causes crashing the box when I try to access them. I detect them
> manually, is there any way to do this automagically?

If you are on a 3.0 kernel, get the most current version of btrfs tools
from Hugo's integration-20110705 branch at
http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ and do a scrub.

-Jan
