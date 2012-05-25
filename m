Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47389 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2EYQsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 May 2012 12:48:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAOjFWZ6qgAkVF-Ep5FYf7ty+AiJQjistY=Fr7ALNrWS=-RT_5w@mail.gmail.com>
References: <CAB9VWqAUkHH2xBXZ+edTSCffiLtEXamfugKrPZ6T0Py92kyZdA@mail.gmail.com>
	<20120525154249.GC2082@localhost.localdomain>
	<CAB9VWqDGgWE8S4dS5izkzUGEWkUbFSanWCV5trm7VWB0=r-tXQ@mail.gmail.com>
	<CAOjFWZ6qgAkVF-Ep5FYf7ty+AiJQjistY=Fr7ALNrWS=-RT_5w@mail.gmail.com>
Date: Fri, 25 May 2012 18:48:30 +0200
Message-ID: <CAB9VWqAkvKHc3fPCHPw51Kg4HF5uz6Bpfj=7eo0RJXbENXb5CA@mail.gmail.com>
Subject: Re: atime and filesystems with snapshots (especially Btrfs)
From: Alexander Block <ablock84@googlemail.com>
To: Freddie Cash <fjwcash@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 25, 2012 at 6:32 PM, Freddie Cash <fjwcash@gmail.com> wrote:
>
> On May 25, 2012 9:00 AM, "Alexander Block" <ablock84@googlemail.com> wrote:
>>
>> On Fri, May 25, 2012 at 5:42 PM, Josef Bacik <josef@redhat.com> wrote:
>> > On Fri, May 25, 2012 at 05:35:37PM +0200, Alexander Block wrote:
>> >> Hello,
>> >>
>> >> (this is a resend with proper CC for linux-fsdevel and linux-kernel)
>> >>
>> >> I would like to start a discussion on atime in Btrfs (and other
>> >> filesystems with snapshot support).
>> >>
>> >> As atime is updated on every access of a file or directory, we get
>> >> many changes to the trees in btrfs that as always trigger cow
>> >> operations. This is no problem as long as the changed tree blocks are
>> >> not shared by other subvolumes. Performance is also not a problem, no
>> >> matter if shared or not (thanks to relatime which is the default).
>> >> The problems start when someone starts to use snapshots. If you for
>> >> example snapshot your root and continue working on your root, after
>> >> some time big parts of the tree will be cowed and unshared. In the
>> >> worst case, the whole tree gets unshared and thus takes up the double
>> >> space. Normally, a user would expect to only use extra space for a
>> >> tree if he changes something.
>> >> A worst case scenario would be if someone took regular snapshots for
>> >> backup purposes and later greps the contents of all snapshots to find
>> >> a specific file. This would touch all inodes in all trees and thus
>> >> make big parts of the trees unshared.
>> >>
>> >> relatime (which is the default) reduces this problem a little bit, as
>> >> it by default only updates atime once a day. This means, if anyone
>> >> wants to test this problem, mount with relatime disabled or change the
>> >> system date before you try to update atime (that's the way i tested
>> >> it).
>> >>
>> >> As a solution, I would suggest to make noatime the default for btrfs.
>> >> I'm however not sure if it is allowed in linux to have different
>> >> default mount options for different filesystem types. I know this
>> >> discussion pops up every few years (last time it resulted in making
>> >> relatime the default). But this is a special case for btrfs. atime is
>> >> already bad on other filesystems, but it's much much worse in btrfs.
>> >>
>> >
>> > Just mount with -o noatime, there's no chance of turning something like
>> > that on
>> > by default since it will break some applications (notably mutt).
>> >  Thanks,
>> >
>> > Josef
>>
>> I know about the discussions regarding compatibility with existing
>> applications. The problem here is, that it is not only a compatibility
>> problem. Having atime enabled by default, may give you ENOSPC
>> for reasons that a normal user does not understand or expect.
>> As a normal user, I would think: If I never change something, why
>> does it then take up more space just by reading it?
>
> Atime is metadata. Thus, by reading a file, only the metadata block for that
> file is CoW'd...not the actual file data blocks. IOW, your snapshots won't
> change and suddenly balloon in size from reading files (metadata blocks are
> tiny).
>
> And, if they do, then something is horribly wrong with the snapshot system.
> Fixing that would be more important than changing the default mount options.
> :)

That's true, metadata blocks are tiny. But they still cost space, and
if you run through the whole tree and access all files/directories
(e.g. with grep, rsync, diff, or whatever) a lot (probably all)
metadata blocks are affected, which can be megabytes or even
gigabytes. All those metadata blocks get cowed and unshared, and thus
use up more and more space. If you use snapshots and get to a point
where nearly no space is left, a simple search for files that one
could delete may already result in no space left. If you use hundreds
(or millions...there is no limit on snapshot counts) of snapshots, the
problem gets worse and worse.
