From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v7 0/8] Btrfs scrub: print path to corrupted files and
 trigger nodatasum fixup
Date: Mon, 25 Jul 2011 10:34:23 +0200
Message-ID: <4E2D2A8F.1050206@jan-o-sch.net>
References: <cover.1311333004.git.list.btrfs@jan-o-sch.net> <loom.20110724T002821-609@post.gmane.org> <4E2C03CD.1000004@jan-o-sch.net> <4E2C0E2C.4070606@GMX.li> <4E2C1E9D.1090403@jan-o-sch.net> <4E2C8425.9090601@GMX.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Jan Schubert <Jan.Schubert@GMX.li>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E2C8425.9090601@GMX.li>
List-ID: <linux-btrfs.vger.kernel.org>

On 24.07.2011 22:44, Jan Schubert wrote:
> On 07/24/2011 03:31 PM, Jan Schmidt wrote:
>>
>> Yes, please check if that error solely depends on the state of your file
>> system (which is what I expect). Please try another scrub while the
>> system is as idle as you get it (also consider daemon processes, cron
>> jobs etc.).
> 
> 
> Jan, doing a new scrub using a clean kernel (without your patchset) the
> system did not crash. I'm back to my 2211 uncorrectable errors now and
> dmesg shows also the (some?) corresponding inodes:
> 
> btrfs: use lzo compression
> btrfs: enabling disk space caching
> btrfs: use ssd allocation scheme
> Adding 4194300k swap on /dev/sda3.  Priority:-1 extents:1 across:4194300k SS
> btrfs: unable to fixup at 182245502976
> btrfs: unable to fixup at 182245507072
> btrfs: unable to fixup at 182245511168
> btrfs: unable to fixup at 182245515264
> btrfs: unable to fixup at 182245519360
> btrfs: unable to fixup at 182245523456
> btrfs: unable to fixup at 182245527552
> btrfs: unable to fixup at 182245531648
> btrfs: unable to fixup at 182245535744
> btrfs: unable to fixup at 182245539840
> 
> scrub status for 03201fc0-7695-4468-9a10-f61ad79f23ca
>         scrub started at Sun Jul 24 22:13:09 2011 and finished after 787
> seconds
>         total bytes scrubbed: 173.92GB with 2211 errors
>         error details: csum=2211
>         corrected errors: 0, uncorrectable errors: 2211

Okay, it's good that it's persistent.

> So there might be an issue with your patch concerning the kernel oops?

Yes, that seems quite likely.

> Any chance to resolve the inodes to affected files manualy?

That's cumbersome, but you can do it using the information contained in
the debug-tree output. But I'd rather find the bug I must have
introduced :-)

> Did I mention that I just did apply your patches 1 to 3 from your patch
> set as suggested by you in the mailing list?

You did. And yes, that hasn't been tested as much as applying the whole
patch set. I just double checked it's working for me, though. I don't
expect it makes a difference if you apply all the patches.

> Are you interested in btrfs-debug-tree anyway?

Absolutely, yes.

Alternatively, if you have a lot of bandwidth and no private data in
your file system, it would be even more helpful if you put the whole
file system somewhere. But the btrfs-debug-tree output would help a lot,
too.

-Jan
