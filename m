From: jim owens <jowens@hp.com>
Subject: Re: UI issues around RAID1
Date: Tue, 17 Nov 2009 10:25:24 -0500
Message-ID: <4B02C064.50404@hp.com>
References: <adapr7ib96f.fsf@roland-alpha.cisco.com> <20091116202043.GA9779@localhost.localdomain> 	<4B01C8AF.5040308@hp.com> <2a31deca0911170244m74478cefy2a3f5f7bc1daf476@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <2a31deca0911170244m74478cefy2a3f5f7bc1daf476@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Andrey Kuzmin wrote:
> On Tue, Nov 17, 2009 at 12:48 AM, jim owens <jowens@hp.com> wrote:
>> But as we have said many times... if we have different
>> raid types active on different files, any attempt to make
> 
> Late question, but could you please explain it a bit further (or point
> me to respective discussion archive)? Did I get it correct that btrfs
> supports per-file raid topology? Or is it per-(sub)volume?

The design of btrfs actually allows each extent inside a file
to have a different raid type.  This probably will never happen
unless a file is written, we add disks and mount with a new
raid type, and then modify part of the file. (this may not
behave how I think but I plan to test it someday soon).

There is a flag on the file to allow per-file raid setting
via ioctl/fcntl.  The typical use for this would be to
make a file DUPlicate type on a simple disk.  DUPlicate acts
like a raid 1 mirror on a single drive and is the default raid
type for metadata extents.

[disclaimer] btrfs is still in development and Chris might
say it does not (or will not in the future) work like I think.

>> df report "raid adjusted numbers" instead of the current raw
>> total storage numbers is going to sometimes give wrong answers.
> 
> I have always thought that space (both physical and logical) used by
> file-system could be accounted for correctly whatever topology or a
> mixture thereof is in effect, the only point worth discussion being
> accounting overhead. Free space, under variable topology, of course
> can only be reliably reported as raw (or as an 'if you use this
> topology,-then you have this logical capacity left' list).

So we know the "raw free blocks", but can not guarantee
"how many raw blocks per new user write-block" will be
consumed because we do not know what topology will be
in effect for a new write.

We could cheat and use "worst-case topology" numbers
if all writes are the current default raid.  Of course
this ignores DUP unless it is set on the whole filesystem.

And we also have the problem of metadata - which is dynamic
and allocated in large chunks and has a DUP type, how do we
account for that in worst-case calculations.

The worst-case is probably wrong but may be more useful to
people to know when they will run out of space. Or at least
it might make some of our ENOSPC complaints go away :)

Only "raw" and "worst-case" can be explained to users and
which we report is up to Chris.  Today we report "raw".

After spending 10 years on a multi-volume filesystem that
had (unsolvable) confusing df output, I'm just of the
opinion that nothing we do will make everyone happy.

But feel free to run a patch proposal by Chris.

jim
