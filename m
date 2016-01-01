Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53389 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718AbcAAQjy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jan 2016 11:39:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aF2k3-0005oG-B2
	for linux-btrfs@vger.kernel.org; Fri, 01 Jan 2016 17:39:51 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 17:39:51 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Jan 2016 17:39:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Add big device, remove small device, read-only
Date: Fri, 1 Jan 2016 16:39:43 +0000 (UTC)
Message-ID: <pan$51253$1b26078$ad4e025c$582077b6@cox.net>
References: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rasmus Abrahamsen posted on Fri, 01 Jan 2016 12:47:08 +0100 as excerpted:

> Happy New Year!
> 
> I have a raid with a 1TB, .5TB, 1.5TB and recently added a 4TB and want
> to remove the 1.5TB. When saying btrfs dev delete it turned into
> readonly. I am on 4.2.5-1-ARCH and btrfs-progs v4.3.1 what can I do?

This isn't going to help with the specific problem, and doesn't apply to 
your case now anyway as the 4 TB device has already been added so all 
you're doing now is deleting the old one, but FWIW...

There's a fairly new command, btrfs replace, that can be used to directly 
replace an old device with a new one, instead of doing btrfs device add, 
followed by btrfs device delete/remove.

> On top of that, my linux is on this same raid, so perhaps btrfs is
> writing some temp files in the filesystem but cannot?
> . /dev/sdc1 on / type btrfs
> (ro,relatime,space_cache,subvolid=1187,subvol=/linux)

Your wording leaves me somewhat confused.  You say your Linux, presumably 
your root filesystem, is on the same raid as the filesystem that is 
having problems.  That would imply that it's a different filesystem, 
which in turn would apply that the raid is below the filesystem level, 
say mdraid, dmraid, or hardware raid, with both your btrfs root 
filesystem, and the separate btrfs with the problems, on the same raid-
based device, presumably partitioned so you can put multiple filesystems 
on the same device.

Which of course would generally mean the two btrfs themselves aren't 
raid, unless of course you are using at least one non-btrfs raid as one 
device under a btrfs raid.  But while implied, that's not really 
supported by what you said, which suggests a single btrfs raid 
filesystem, instead.  In which case, perhaps you meant that this 
filesystem contains your root filesystem as well, not just that the raid 
contains it.

Of course, if your post had included the usual btrfs fi show and btrfs fi 
df (and btrfs fi usage would be good as well) that the wiki recommends be 
posted with such reports, that might make things clearer, but it doesn't, 
so we're left guessing...

But I'm assuming you meant a single multi-device btrfs, not multiple 
btrfs that happen to be on the same non-btrfs raid.

Another question the show and df would answer is what btrfs raid mode 
you're running.  The default for multiple device btrfs is of course raid1 
metadata and single mode data, but you might well have set it up with 
data and metadata in the same mode, and/or with raid0/5/6/10 for one or 
both data and metadata.  You didn't say and didn't provide the btrfs 
command output that would show it, so...

> <zetok> Ralle: did you do balance before removing?
> 
> I did not, but I have experience with it balancing itself upon doing so.
> Upon removing a device, that is.
> I am just not sure how to proceed now that everything is read-only.

You were correct in that regard.  btrfs device remove (or btrfs replace) 
trigger balance as part of the process, and balancing after adding a 
device, only to have balance trigger again with a delete/remove, is 
needless.

Actually, I suspect the remove-triggered balance ran across a problem it 
didn't know how to handle when attempting to move one of the chunks from 
the existing device, and that's what put the filesystem in read-only 
mode.  That's usually what happens when btrfs device remove triggers 
problems and people report it, anyway.  A balance before the remove would 
have simply triggered it then, anyway.

But what the specific problem is, and what to do about it, remains to be 
seen.  Having that btrfs fi show and btrfs fi df would be a good start, 
letting us know at least what raid type we're dealing with, etc.

> <zetok> I hope that you have backups?
> 
> I do have backups, but it's on Crashplan, so I would prefer not to have
> to go there.

That's wise, both him asking and you replying you already have them, but 
just want to avoid using them if possible.  Waaayyy too many folks 
posting here find out the hard way about the admin's first rule of 
backups, in simplified form, that if you don't have backups, you are 
declaring by your actions that the data not backed up is worth less to 
you than the time, resources and hassle required to do those backups, 
despite any after-the-fact protests to the contrary.  Not being in that 
group already puts you well ahead of the game! =:^)

> <zetok> and do you have any logs?
> 
> Where would those be?
> I never understood journalctl
> 
> <zetok> journalctl --since=today
> 
> Hmm, it was actually yesterday that I started the remove, so I did
> --since=yesterday I am looking at the log now, please stnad by.
> This is my log http://pastebin.com/mCPi3y9r But I fear that it became
> read-only before actually writing the error to the filesystem

Hmm...  Looks like my strategy of having both systemd's journald, and 
syslog-ng, might pay off.  I have journald configured to only do 
temporary files, which it keeps in /run/log/journal, with /run of course 
tmpfs.  That way I get systemd's journal enhancements like the ability to 
do systemctl status <some-service> and have it give me the latest few log 
entries associated with that service as well.  But it doesn't journal to 
anything but tmpfs so it's current boot only.  Meanwhile, syslog-ng is 
configured to take messages from journald and to sort and filter them as 
it normally would, before saving them to various text-based logs.  That 
way I get only the text-based and easily grepped, etc, logs in permanent 
storage.  That lets me filter out "log noise" before it even hits storage 
(journald can apparently only filter on the output side, it writes 
everything it sees to the journal).  Also, because text-based logs are 
append-only, they don't heavily fragment like journald's binary logs do 
on btrfs due to the more random write-pattern of the journal files and 
btrfs being cow-based so rewrites to existing parts of the file copy them 
elsewhere, triggering heavy fragmentation.  I figure that's the best of 
both worlds. =:^)

But a benefit I hadn't considered until now is that when storage goes 
read-only, the journal, being tmpfs-only in my case, continues to 
journal, even when syslog-ng can no longer log to permanent storage 
because it's now read-only. =:^)


Back to your situation, however.  These will be kernel messages and thus 
appear in dmesg.  While that's size-restricted and old messages are 
thrown away once the ring-buffer fills up, with luck your buffer is large 
enough that the trigger for that read-only is still in dmesg.

And while waiting to see if dmesg returns anything interesting, another 
set of questions.  How old is your btrfs and with what kernel and btrfs-
progs version was it created, if you know, and was it originally created 
with mkfs.btrfs, or converted from ext* using btrfs-convert?  I'll guess 
it was created with mkfs.btrfs, but I'm asking, since ext* conversions 
have their own set of problems that are rare or don't happen at all on 
native-created btrfs, and it's often balance that exposes these 
problems.  If you created with mkfs.btrfs, at least we don't have to 
worry about the whole set of conversion-related problems.

Meanwhile, depending on the problem, a reboot will likely get you back to 
read-write mode, assuming the filesystem still mounts, but there's a risk 
you won't be able to mount again, as well, again depending on the problem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

