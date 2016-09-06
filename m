Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50200 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751993AbcIFCOB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Sep 2016 22:14:01 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bh5tZ-00056a-R5
        for linux-btrfs@vger.kernel.org; Tue, 06 Sep 2016 04:13:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send extremely slow (almost stuck)
Date: Tue, 6 Sep 2016 02:13:45 +0000 (UTC)
Message-ID: <pan$8ec2c$ff524e2$2c7a6f41$1fe67610@cox.net>
References: <03b9d0b0-7001-7dd9-75cd-69d58b94d553@googlemail.com>
        <6bebd709-8fdd-5e88-650d-f1c551946505@cn.fujitsu.com>
        <2926d118-6a2f-2066-529d-1dd8335200dc@googlemail.com>
        <a7ead62b-38f5-2ed6-c24b-1960a8fc6ba8@cn.fujitsu.com>
        <5e6e606d-e75c-b7f1-0a9f-4e36090659eb@googlemail.com>
        <2ae7659b-ebb2-200b-174e-9ca186cb22cd@cn.fujitsu.com>
        <22d296fa-7673-780a-0171-d87f2d7bbce6@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oliver Freyermuth posted on Mon, 05 Sep 2016 23:29:08 +0200 as excerpted:

> However, you gave me an idea. I had a look at the output of running the
> file created by "btrfs send --no-data" piping that through "strings".
> This revealed the last files which btrfs send was able to treat before
> running into the ioctl failure.
> Indeed, this is my thunderbird profile directory, always a place with a
> lot of activity.
> 
> Now the interesting part begins: Since of course I have a backup of this
> directory, I decided to move that profile to another FS and back.
> Turns out I can not run rm -rf ~/.thunderbird since it claims "directory
> not empty". Kernel log does no bug-on or OOPS or anything like that.
> 
> That's reproducible not only in the snapshots, but also in my "home"
> subvolume for this folder.
> 
> "stat -c %s" of the supposed-to-be-empty profile directory reveals
> indeed:
> 2482
> 
> So I guess I should refresh my backups soon and either run "btrfs check
> --repair" or, if that fails, redo the FS...
> Likely btrfs check --repair will fail for me since (due to duperemove
> usage) I'll for sure also be hit by
> https://bugzilla.kernel.org/show_bug.cgi?id=155791 since I'm still using
> 4.7.1 so I'd like to update to 4.7.2 before trying out that repair
> strategy.
> 
> I sadly can't do that in the next few days since I actively need the
> machine in question, so I'll rename that folder and restore just that
> from backup for now.
> 
> Is the debug-information still of interest? If so, I can share it (but
> would not post it publicly to the list since many filenames are in
> there...).
> It weighs in at about 2 x 80 MiB after xz compression.
> 
> Or is there anything else I can try safely?

I had something very similar happen here a few weeks ago, except with my 
firefox profile dir (I don't run thunderbird, preferring claws-mail, but 
I do run firefox as my browser).

My use-case does neither snapshots nor send/receive, however, so it was 
just the single root subvolume (5).  But there was supposedly a file in 
that dir according to bash's tab-completion, that would neither list, nor 
rm, which meant the dir couldn't rm -r either.  (Interestingly enough, rm 
-i asked if I wanted to rm "weird file" whatever, and weird it indeed was!
)

So I immediately copied all the normal files to a new dir, and deleted 
the normal files from the problem dir, leaving only the weird one.

Then I renamed the problem dir in ordered to be able to rename the new 
dir (with the good files) back to the name firefox expected.

Then I decided to see what I could do with the renamed dir.  I believe I 
rebooted (or umount/mount cycled the filesystem) as well.  I think I had 
to use the magic-sysrq m/remount-ro key as it refused to umount even from 
systemd emergency mode.  But here's the interesting part.  At least after 
the rename and a reboot, it *DID* let me delete (using mc) the dir!  I 
honestly didn't expect it'd let me, but it did.

So I'd try that.  After copying all the good files out and renaming the 
dir out of the way, so you can rename the dir you copied the good files 
into back into place, reboot (or umount and mount again if possible), 
possibly by going to single-user or emergency mode first and using magic 
srq remount-ro to force it, if necessary, before rebooting.

Then try to delete the dir again, and see if it will.

The difference, however, is that I didn't have any snapshots/subvolumes 
or other reflinks to the "weird" file, only the one normal hardlink.  So 
even if it's the same thing, I'm not sure if it'll work for you given the 
multiple snapshot reflinks to the file, as it did for me with just the 
one.

So it might not work at all for you, or might work but you have to delete 
it in each snapshot, or deleting it in one might delete it in all (which 
would be weird, but it's already a weird file we're dealing with, so who 
knows...), I don't know which.  And that of course assumes it's even the 
same basic bug and would behave as it did for me if you had no snapshots.

That was with kernel 4.7.0 (which I'm still running, I'll be upgrading to 
4.8 rcs pretty soon now) I believe.  If not, then it was late in the 4.7 
rc cycle or possibly 4.6.0, but it was definitely not older than that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

