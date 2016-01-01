Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54150 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752131AbcAAUUO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jan 2016 15:20:14 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
	by mailout.nyi.internal (Postfix) with ESMTP id 31263204CD
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Jan 2016 15:20:14 -0500 (EST)
Message-Id: <1451679613.2761176.480641362.3ADA17DB@webmail.messagingengine.com>
From: Rasmus Abrahamsen <me@rasmusa.net>
To: Chris Murphy <lists@colorremedies.com>,
        Rasmus Abrahamsen <btrfs@rasmusa.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <CAJCQCtSCJ91FaJ20g-+TKMwGkXeQdEkn1yDf6w+H3=V_8_xshA@mail.gmail.com>
References: <9E462AAE-481A-4A0D-9918-FF56A73D6F6D@rasmusa.net>
 <CAJCQCtSCJ91FaJ20g-+TKMwGkXeQdEkn1yDf6w+H3=V_8_xshA@mail.gmail.com>
Subject: Re: Add big device, remove small device, read-only
Date: Fri, 01 Jan 2016 21:20:13 +0100
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I accidentically sent my messages directly to Duncan, I am copying them
in here.

Hello Duncan,

Thank you for the amazing response. Wow, you are awesome.

Here is the output of fi show, fi df and mount, sorry for not providing
them to begin with:

http://pastebin.com/DpiuDvRy


> On 01 Jan 2016, at 17:39, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> Rasmus Abrahamsen posted on Fri, 01 Jan 2016 12:47:08 +0100 as excerpted:
> 
>> Happy New Year!
>> 
>> I have a raid with a 1TB, .5TB, 1.5TB and recently added a 4TB and want
>> to remove the 1.5TB. When saying btrfs dev delete it turned into
>> readonly. I am on 4.2.5-1-ARCH and btrfs-progs v4.3.1 what can I do?
> 
> This isn't going to help with the specific problem, and doesn't apply to 
> your case now anyway as the 4 TB device has already been added so all 
> you're doing now is deleting the old one, but FWIW...
> 
> There's a fairly new command, btrfs replace, that can be used to directly 
> replace an old device with a new one, instead of doing btrfs device add, 
> followed by btrfs device delete/remove.
> 
>> On top of that, my linux is on this same raid, so perhaps btrfs is
>> writing some temp files in the filesystem but cannot?
>> . /dev/sdc1 on / type btrfs
>> (ro,relatime,space_cache,subvolid=1187,subvol=/linux)
> 
> Your wording leaves me somewhat confused.  You say your Linux, presumably 
> your root filesystem, is on the same raid as the filesystem that is 
> having problems.  That would imply that it's a different filesystem, 
> which in turn would apply that the raid is below the filesystem level, 
> say mdraid, dmraid, or hardware raid, with both your btrfs root 
> filesystem, and the separate btrfs with the problems, on the same raid-
> based device, presumably partitioned so you can put multiple filesystems 
> on the same device.
> 
> Which of course would generally mean the two btrfs themselves aren't 
> raid, unless of course you are using at least one non-btrfs raid as one 
> device under a btrfs raid.  But while implied, that's not really 
> supported by what you said, which suggests a single btrfs raid 
> filesystem, instead.  In which case, perhaps you meant that this 
> filesystem contains your root filesystem as well, not just that the raid 
> contains it.
> 
> Of course, if your post had included the usual btrfs fi show and btrfs fi 
> df (and btrfs fi usage would be good as well) that the wiki recommends be 
> posted with such reports, that might make things clearer, but it doesn't, 
> so we're left guessing...
> 
> But I'm assuming you meant a single multi-device btrfs, not multiple 
> btrfs that happen to be on the same non-btrfs raid.

My root / is a sub volume of my filesystem. I will only be talking about
the filesystem named “Fortune”, the one named “Glassbox” is not relevant
to this problem.

> 
> Another question the show and df would answer is what btrfs raid mode 
> you're running.  The default for multiple device btrfs is of course raid1 
> metadata and single mode data, but you might well have set it up with 
> data and metadata in the same mode, and/or with raid0/5/6/10 for one or 
> both data and metadata.  You didn't say and didn't provide the btrfs 
> command output that would show it, so...
> 
>> <zetok> Ralle: did you do balance before removing?
>> 
>> I did not, but I have experience with it balancing itself upon doing so.
>> Upon removing a device, that is.
>> I am just not sure how to proceed now that everything is read-only.
> 
> You were correct in that regard.  btrfs device remove (or btrfs replace) 
> trigger balance as part of the process, and balancing after adding a 
> device, only to have balance trigger again with a delete/remove, is 
> needless.
> 
> Actually, I suspect the remove-triggered balance ran across a problem it 
> didn't know how to handle when attempting to move one of the chunks from 
> the existing device, and that's what put the filesystem in read-only 
> mode.  That's usually what happens when btrfs device remove triggers 
> problems and people report it, anyway.  A balance before the remove would 
> have simply triggered it then, anyway.
> 
> But what the specific problem is, and what to do about it, remains to be 
> seen.  Having that btrfs fi show and btrfs fi df would be a good start, 
> letting us know at least what raid type we're dealing with, etc.
> 
>> <zetok> I hope that you have backups?
>> 
>> I do have backups, but it's on Crashplan, so I would prefer not to have
>> to go there.
> 
> That's wise, both him asking and you replying you already have them, but 
> just want to avoid using them if possible.  Waaayyy too many folks 
> posting here find out the hard way about the admin's first rule of 
> backups, in simplified form, that if you don't have backups, you are 
> declaring by your actions that the data not backed up is worth less to 
> you than the time, resources and hassle required to do those backups, 
> despite any after-the-fact protests to the contrary.  Not being in that 
> group already puts you well ahead of the game! =:^)
> 
>> <zetok> and do you have any logs?
>> 
>> Where would those be?
>> I never understood journalctl
>> 
>> <zetok> journalctl --since=today
>> 
>> Hmm, it was actually yesterday that I started the remove, so I did
>> --since=yesterday I am looking at the log now, please stnad by.
>> This is my log http://pastebin.com/mCPi3y9r But I fear that it became
>> read-only before actually writing the error to the filesystem
> 
> Hmm...  Looks like my strategy of having both systemd's journald, and 
> syslog-ng, might pay off.  I have journald configured to only do 
> temporary files, which it keeps in /run/log/journal, with /run of course 
> tmpfs.  That way I get systemd's journal enhancements like the ability to 
> do systemctl status <some-service> and have it give me the latest few log 
> entries associated with that service as well.  But it doesn't journal to 
> anything but tmpfs so it's current boot only.  Meanwhile, syslog-ng is 
> configured to take messages from journald and to sort and filter them as 
> it normally would, before saving them to various text-based logs.  That 
> way I get only the text-based and easily grepped, etc, logs in permanent 
> storage.  That lets me filter out "log noise" before it even hits storage 
> (journald can apparently only filter on the output side, it writes 
> everything it sees to the journal).  Also, because text-based logs are 
> append-only, they don't heavily fragment like journald's binary logs do 
> on btrfs due to the more random write-pattern of the journal files and 
> btrfs being cow-based so rewrites to existing parts of the file copy them 
> elsewhere, triggering heavy fragmentation.  I figure that's the best of 
> both worlds. =:^)
> 
> But a benefit I hadn't considered until now is that when storage goes 
> read-only, the journal, being tmpfs-only in my case, continues to 
> journal, even when syslog-ng can no longer log to permanent storage 
> because it's now read-only. =:^)
> 
> 
> Back to your situation, however.  These will be kernel messages and thus 
> appear in dmesg.  While that's size-restricted and old messages are 
> thrown away once the ring-buffer fills up, with luck your buffer is large 
> enough that the trigger for that read-only is still in dmesg.

Dmesg contains nothing interesting unfortunately. About 12 hours passed
and lots of cronjobs have attempted to run since then. I cannot disable
these because it is read-only. I can however stop the service. I will do
that now… Failed:

Failed to add /run/systemd/ask-password to directory watch: No space
left on device

> 
> And while waiting to see if dmesg returns anything interesting, another 
> set of questions.  How old is your btrfs and with what kernel and btrfs-
> progs version was it created, if you know, and was it originally created 
> with mkfs.btrfs, or converted from ext* using btrfs-convert?  I'll guess 
> it was created with mkfs.btrfs, but I'm asking, since ext* conversions 
> have their own set of problems that are rare or don't happen at all on 
> native-created btrfs, and it's often balance that exposes these 
> problems.  If you created with mkfs.btrfs, at least we don't have to 
> worry about the whole set of conversion-related problems.

I cannot remember how this filesystem was created, I believe it was
mkfs.btrfs. I created it last year (actually 2014) on the latest Arch
Linux. I created it as a btrfs from the beginning.

> 
> Meanwhile, depending on the problem, a reboot will likely get you back to 
> read-write mode, assuming the filesystem still mounts, but there's a risk 
> you won't be able to mount again, as well, again depending on the problem.

I am not physically next to my machine right now, so I was afraid of
rebooting in case I could do something remotely. I will be close to my
machine in a few hours. I will try rebooting it now, however.

> 
> -- 
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Thank you very much for your extremely thorough response despite my lack
of providing information.

Rasmus


UPDATE:

The reboot succeeded and it is not read-only anymore. I tried the
command:

btrfs dev delete /dev/sdb1 /mnt/fortune

again and it's running again. This time I am keeping a window with:

cat /proc/kmsg | grep BTRFS

running. We'll see how it goes.

Rasmus

On Fri, Jan 1, 2016, at 09:07 PM, Chris Murphy wrote:
> On Fri, Jan 1, 2016 at 4:47 AM, Rasmus Abrahamsen <btrfs@rasmusa.net>
> wrote:
> > Happy New Year!
> >
> > I have a raid with a 1TB, .5TB, 1.5TB and recently added a 4TB and want to remove the 1.5TB. When saying btrfs dev delete it turned into readonly. I am on 4.2.5-1-ARCH and btrfs-progs v4.3.1 what can I do?
> 
> btrfs fi show
> lsblk -f
> btrfs fi usage <pathtomountpointforbtrfsvolumeunderdiscussion>
> 
> 
> he remove, so I did --since=yesterday
> > I am looking at the log now, please stnad by.
> > This is my log
> > http://pastebin.com/mCPi3y9r
> 
> What's this?
> 
> Dec 31 15:03:56 rasmusahome systemd-udevd[6340]: inotify_add_watch(9,
> /dev/sdd1, 10) failed: No space left on device
> Dec 31 15:04:01 rasmusahome kernel:  sdd: sdd1
> Dec 31 15:04:01 rasmusahome systemd-udevd[6341]: inotify_add_watch(9,
> /dev/sdd1, 10) failed: No space left on device
> Dec 31 15:05:43 rasmusahome kernel: BTRFS info (device sdb1): disk
> added /dev/sdd1
> 
> Why is udev first complaining about no space left on sdd1, but then
> it's being added to the btrfs volume?
> 
> 
> 
> -- 
> Chris Murphy

I have no idea.

I am adding the commands you asked for:

[ralle@rasmusahome ~]$ sudo lsblk -f
NAME   FSTYPE LABEL    UUID                                 MOUNTPOINT
sda
`-sda1 btrfs  Fortune  f87c173c-c873-424f-9c79-3be2c4d37d88
sdb
|-sdb1 btrfs  Fortune  f87c173c-c873-424f-9c79-3be2c4d37d88
`-sdb2 btrfs  Glassbox ca44c8e4-1a26-4b4a-ba52-38a4b0d3f104
/mnt/glassbox
sdc
`-sdc1 btrfs  Fortune  f87c173c-c873-424f-9c79-3be2c4d37d88 /mnt/fortune
sdd
`-sdd1 btrfs  Fortune  f87c173c-c873-424f-9c79-3be2c4d37d88
sde
`-sde1

[ralle@rasmusahome ~]$ sudo btrfs fi usage /mnt/fortune/
Overall:
    Device size:                   5.00TiB
    Device allocated:              2.20TiB
    Device unallocated:            2.81TiB
    Device missing:                  0.00B
    Used:                          2.19TiB
    Free (estimated):              1.41TiB      (min: 1.41TiB)
    Data ratio:                       2.00
    Metadata ratio:                   2.00
    Global reserve:              512.00MiB      (used: 114.56MiB)

Data,RAID1: Size:1.09TiB, Used:1.08TiB
   /dev/sda1     787.00GiB
   /dev/sdb1     613.00GiB
   /dev/sdc1     326.00GiB
   /dev/sdd1     500.00GiB

Metadata,RAID1: Size:11.00GiB, Used:9.12GiB
   /dev/sda1       7.00GiB
   /dev/sdb1       4.00GiB
   /dev/sdc1       4.00GiB
   /dev/sdd1       7.00GiB

System,RAID1: Size:32.00MiB, Used:208.00KiB
   /dev/sda1      32.00MiB
   /dev/sdb1      32.00MiB

Unallocated:
   /dev/sda1     137.48GiB
   /dev/sdb1      16.00EiB
   /dev/sdc1     135.76GiB
   /dev/sdd1       3.14TiB

I am sorry if this message is very confusing...

Rasmus
