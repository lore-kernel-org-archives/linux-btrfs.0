Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f179.google.com ([209.85.213.179]:33043 "EHLO
        mail-yb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbcLCW4r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Dec 2016 17:56:47 -0500
Received: by mail-yb0-f179.google.com with SMTP id v132so48484919yba.0
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Dec 2016 14:56:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4615776.dvopQOigxY@thetick>
References: <1776088.42rHLKPlSp@thetick> <CAJCQCtRxhjKAcZy7wuXCFM1=70eG+TJPwEoyD7zq0iEw8f2urQ@mail.gmail.com>
 <4615776.dvopQOigxY@thetick>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 3 Dec 2016 15:56:45 -0700
Message-ID: <CAJCQCtRUO1pByA3HXjbKRNVFmC9zcFvbLi22hAJS8VLafXnoew@mail.gmail.com>
Subject: Re: system hangs due to qgroups
To: Marc Joliet <marcec@gmx.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 3, 2016 at 2:46 PM, Marc Joliet <marcec@gmx.de> wrote:
> On Saturday 03 December 2016 13:42:42 Chris Murphy wrote:
>> On Sat, Dec 3, 2016 at 11:40 AM, Marc Joliet <marcec@gmx.de> wrote:
>> > Hello all,
>> >
>> > I'm having some trouble with btrfs on a laptop, possibly due to qgroups.
>> > Specifically, some file system activities (e.g., snapshot creation,
>> > baloo_file_extractor from KDE Plasma) cause the system to hang for up to
>> > about 40 minutes, maybe more.
>>
>> Do you get any blocked tasks kernel messages? If so, issue sysrq+w
>> during the hang, and then check the system log (dmesg may not contain
>> everything if the command fills the message buffer). If it's a hang
>> without any kernel messages, then issue sysrq+t.
>>
>> https://www.kernel.org/doc/Documentation/sysrq.txt
>
> As it's a rescue shell, I have only the one shell AFAIK, and it's occupied by
> mount.  So I can't tell if there are dmesg entries, however, when this happens
> during a normal running system, I never saw any dmesg entries.  Anyway, I ran
> both.

OK so this is root fs? I would try to work on it from another volume.
An advantage of openSUSE Tumbleweed is they claim to fully support
qgroups, where upstream uses much more guarded language about its
stability.

Whereas last night's Fedora Rawhide has kernel 4.9-rc7 and btrfs-progs 4.8.5.
https://kojipkgs.fedoraproject.org/compose/rawhide/Fedora-Rawhide-20161203.n.0/compose/Workstation/x86_64/iso/Fedora-Workstation-netinst-x86_64-Rawhide-20161203.n.0.iso

You can use dd to write the ISO to a USB stick, it supports BIOS and
UEFI and Secure Boot.

Troubleshooting > Rescue a Fedora system > option 3 to get to a shell
The sysrq+t and sysrq+w can be written out in their entirety with
monotonic time using 'journalctl -b -k -o short-monotonic >
kernelmessages.log'

Unfortunately this is not a live system, so you can't (as far as I
know) install script to more easily capture everything to a single
file; 'btrfs check <dev> > btrfscheck.log' should capture most of the
output, but it misses a few early lines for some reason.

And then scp those files to another system, or mount another stick and
copy locally.

>
> Should I take photos?  That'll be annoying to do with all the scrolling, but I
> can do that if need be.

I can't decipher it anyway, it's mainly for a dev who wanders across
this thread or if you file a bug report. But you can get the complete
output using the method above.

>
>> > After I next turned on the laptop, the balance resumed, causing bootup to
>> > fail, after which I remembered about the skip_balance mount option, which
>> > I
>> > tried in a rescue shell from an initramfs.
>>
>> The file system is the root filesystem? If so, skip_balance may not be
>> happening soon enough. Use kernel parameter rootflags=skip_balance
>> which will apply this mount option at the very first moment the file
>> system is mounted during boot.
>
> Yes, it's the root file system (there's that plus a swap partition).  I
> believe I tried rootflags, but I think it also failed, which is why I'm using
> a rescue shell now.  I can try it again, though, if anybody thinks that
> there's no point in waiting, especially if btrfs_scrub_pause in the btrfs-
> transaction call trace is significant.

It sounds like it's resuming a scrub. That won't happen if you boot
from an alternate volume. There's a scrub file found at
/var/lib/btrfs/ that tracks the progress of scrubs for each btrfs
volume - that directory with an inprogress scrub for your file system
is actually in the directory on that file system. If you haven't had
luck with btrfs scrub cancel, you can just remove the files in that
directory when you get a chance to rw mount the volume.



>
>> > Since I couldn't use skip_balance, and logically can't destroy qgroups on
>> > a
>> > read-only file system, I decided to wait for a regular mount to finish.
>> > That has been running since Tuesday, and I am slowly growing impatient.
>> Haha, no kidding! I think that's very patient.
>
> Heh :) . I've still got my main desktop (as ancient as it may be), so I'm
> content with waiting for now, but I don't want to wait forever, especially if
> there might not even be a point.

How big is the file system? Sounds like it's a single device volume on
a laptop so I'm guessing at most 1TB, and that'd mean at most 100GiB
of metadata, which should mean around 15 minutes max to completely
read and process all the metadata, and maybe a few hours to do a
scrub. I'd bail after a few hours for sure.



>
>> > Thus I arrive at my question(s): is there anything else I can try, short
>> > of
>> > reformatting and restoring from backup?  Can I use btrfs-check here, or
>> > any
>> > other tool?  Or...?
>>
>> Yes, btrfs-progs 4.8.5 has the latest qgroup checks, so if there's
>> something wrong it should find it and if not that's a bug of its own.
>
> The initramfs has 4.8.4, but it looks like 4.8.5 was "only" an urgent bug fix,
> with no changes to qgroups handling, so I can use that, too.  Can it repair
> qgroups problems, too?

Yes, 4.8.4 is fine.


>
>> > Also, should I be able to avoid reformatting: how do I properly disable
>> > quota support?
>>
>> 'btrfs quota disable' is the only command that applies to this and it
>> requires rw mount; there's no 'noquota' mount option.
>
> OK, thanks.
>
> So what should I try next?  I'm sick at home, so I can spend more time on this
> than usual.

Well if it were me I'd use btrfs check to see what state it thinks the
file system is in. And then I'd do btrfs image to make a copy of the
filesystem metadata both for the devs and also in case the next things
make the problem worse, in theory the fs can be restored (or you can
setup an overlay  if you prefer).

And then I'd mount normally, possibly with skip_balance. Capture
sysrq+t or +w or both. And then see if things get more sane if you
disable quotas. If not, then I'd see if it'll tolerate 'btrfs qgroup
destroy' on a few subvolumes. I'd basically use destroy and remove to
wipe away all the quotas - I don't know off hand if quotas needs to be
enabled for qgroup remove/destroy to work so you'll have to figure
that out. And it might take a while for the command to complete, but
I'd like to believe as you wipe away the qgroups, whatever qgroup
related kernel accounting is happening will eventually stop.

It sounds to me like there may be some legacy qgroup confusion going
on, but I haven't tested this much at all, so you're kinda on the
bleeding edge.



-- 
Chris Murphy
