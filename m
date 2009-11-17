From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: UI issues around RAID1
Date: Tue, 17 Nov 2009 23:23:37 +0300
Message-ID: <2a31deca0911171223l51c7e2f9oa8ff2b044e52dc5b@mail.gmail.com>
References: <adapr7ib96f.fsf@roland-alpha.cisco.com> <20091116202043.GA9779@localhost.localdomain>
	<4B01C8AF.5040308@hp.com> <2a31deca0911170244m74478cefy2a3f5f7bc1daf476@mail.gmail.com>
	<4B02C064.50404@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B02C064.50404@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 17, 2009 at 6:25 PM, jim owens <jowens@hp.com> wrote:
> <snip>
> So we know the "raw free blocks", but can not guarantee
> "how many raw blocks per new user write-block" will be
> consumed because we do not know what topology will be
> in effect for a new write.
>
> We could cheat and use "worst-case topology" numbers
> if all writes are the current default raid. =A0Of course
> this ignores DUP unless it is set on the whole filesystem.
>
> And we also have the problem of metadata - which is dynamic
> and allocated in large chunks and has a DUP type, how do we
> account for that in worst-case calculations.
>
> The worst-case is probably wrong but may be more useful to
> people to know when they will run out of space. Or at least
> it might make some of our ENOSPC complaints go away :)
>
> Only "raw" and "worst-case" can be explained to users and
> which we report is up to Chris. =A0Today we report "raw".
>
> After spending 10 years on a multi-volume filesystem that
> had (unsolvable) confusing df output, I'm just of the
> opinion that nothing we do will make everyone happy.

df is user-centric, and therefore is naturally expected to return
used/available _logical_ capacity (how this translates to used
physical space is up to file-system-specific tools to find
out/report). Returning raw is counter-intuitive and causes surprise
similar to that of Roland.

With so flexible, down to per-file, topology configuration the only
option I see for df to return logical capacity available is to compute
the  latter off the file-system object for which df is invoked. For
instance, 'df /path/to/some/file' could return logical capacity for
the mountpoint where some-file resides, computed from underlying
physical capacity available _and_ topology for this file. 'df
/mount-point' would under this implementation return  available
logical capacity assuming default topology for the referenced
file-system.

As to used logical space accounting, this is file-system-specific and
I'm not yet familiar enough with btrfs code-base to argument for any
approach.

Regards,
Andrey
>
> But feel free to run a patch proposal by Chris.
>
> jim
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
