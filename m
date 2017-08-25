Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:33548 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754535AbdHYTSb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 15:18:31 -0400
Received: by mail-io0-f179.google.com with SMTP id s101so2476891ioe.0
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Aug 2017 12:18:30 -0700 (PDT)
Subject: Re: number of subvolumes
To: Ferry Toth <ftoth@telfort.nl>, linux-btrfs@vger.kernel.org
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
 <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
 <20170822142451.GI14804@rus.uni-stuttgart.de> <20170822214531.44538589@natsu>
 <20170822165725.GL14804@rus.uni-stuttgart.de>
 <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
 <20170822180155.GM14804@rus.uni-stuttgart.de>
 <22940.31139.194399.982315@tree.ty.sabi.co.uk>
 <20170822204811.GO14804@rus.uni-stuttgart.de>
 <20170823071821.GA28319@rus.uni-stuttgart.de>
 <f75e66d.7ade2c40.15e0e3ced5c@gmail.com> <onkbkk$qs1$1@blaine.gmane.org>
 <BD7091A7-DE7F-4A86-9BDE-8BA63060CBAF@rqc.ru> <onni1n$bic$2@blaine.gmane.org>
 <2828ac64-8b68-8b1c-554c-489bda3b70d1@gmail.com>
 <onp6n7$oi6$1@blaine.gmane.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <dd8b6053-94eb-a260-e812-2db96598a423@gmail.com>
Date: Fri, 25 Aug 2017 15:18:27 -0400
MIME-Version: 1.0
In-Reply-To: <onp6n7$oi6$1@blaine.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-25 08:55, Ferry Toth wrote:
> Op Fri, 25 Aug 2017 07:45:44 -0400, schreef Austin S. Hemmelgarn:
> 
>> On 2017-08-24 17:56, Ferry Toth wrote:
>>> Op Thu, 24 Aug 2017 22:40:54 +0300, schreef Marat Khalili:
>>>
>>>>> We find that typically apt is very slow on a machine with 50 or so
>>>>> snapshots and raid10. Slow as in probably 10x slower as doing the
>>>>> same update on a machine with 'single' and no snapshots.
>>>>>
>>>>> Other operations seem to be the same speed, especially disk
>>>>> benchmarks do not seem to indicate any performance degradation.
>>>>
>>>> For meaningful discussion it is important to take into account the
>>>> fact
>>>
>>> Doing daily updates on a desktop is not uncommon and when 3 minutes
>>> become 30 then many would call that meaningful.
>> I think the more meaningful aspect here is that it's 30 minutes where
>> persistent storage is liable to be unusable, not necessarily that it's
>> 30 minutes.
> 
> Unusable - probably less (depending on your definition)
And depending on both your hardware and how many updates you're handling 
(if things are stalling with dpkg calling fsync, it's probably going to 
be bad for other stuff too, even if it's still 'usable').

> Irritating - yes
Still nothing compared to Windows 10 deciding to download updates right 
after you start a round in an FPS or RTS game...

In all seriousness though, I'm kind of used to half-hour daily updates 
(or 2 plus hour ones if GCC, LLVM, or glibc are being updated), I run 
Gentoo on most of my systems, so everything gets built locally.
> 
>>> Similar for a single office server, which is upgraded twice a year,
>>> where an upgrade normally would take an hour or 2, but now more than a
>>> working day. In the meantime, take samba and postgresql offline,
>>> preventing people to work for a few hours.
>> That should only be the case if:
>> 1. You don't have your data set properly segregated from the rest of
>> your system (it should not be part of the upgrade snapshot, but an
>> independent snapshot taken separately).
>> 2. You are updating the main system, instead of updating the snapshot
>> you took.
>>
>> The ideal method of handling an upgrade in this case is:
>> 1. Snapshot the system, but not the data set.
>> 2. Run your updates on the snapshot of the system.
>> 3. Rename the snapshot and the root subvolume so that you boot into the
>> snapshot.
>> 4. During the next maintenance window (or overnight), shutdown the
>> system services, snapshot the data set (so you can roll back if the
>> update screws up the database).
>> 5. Reboot.
>>
>> That provides minimal downtime, and removes the need to roll-back if the
>> upgrade fails part way through (you just nuke the snapshot and start
>> over, instead of having to manually switch to the snapshot and reboot).
> 
> Wow, yes that does sound ideal. Is that how you do it?
It's what I've been trying to get working on my Gentoo systems for 
months now with varying degrees of success.  We do some similar trickery 
with updates for our embedded systems where I work (albeit a bit 
differently), but we're also directly calling RPM for package installs 
instead of using higher level tools like Yum or DNF, so it's easy to 
point things somewhere else for the install target.  I'm pretty sure 
this is essentially what NixOS does for updates too, but I don't think 
it has BTRFS snapshot support (they use LVM2), and it's a pain to get 
used to the declarative system configuration it uses.

FWIW, it would be even easier if BTRFS supported operation as a lower 
layer for OverlayFS, then you could put /etc and similar stuff on 
OverlayFS, and the package manager never needs to ask if you want to 
update config files because it just puts them on the lower layer.
> 
> Now I just need Cananonical to update there installer to take of this.
> (that is: tell it to update the system on another partition (subvolume)
> than the one mounted on /, and not stop any running system services).
Yeah, that's one of the things I kind of hate about many mainstream 
distros.  Gentoo is nice in this respect, you can just run the update 
command with ROOT=/whatever in the environment, and it will use that for 
installing packages, and it expects the admin to handle restarting 
services.  RPM actually has an option to handle this too these days, but 
not Yum or DNF (don't know about Zypper or YaST2, but I think they do 
have such an option).  dkpg itself probably does, but last I checked, 
apt-get, aptitude, and most of the graphical frontends don't.

It's technically possible to work around this using containers (that is, 
you spawn a container with the snapshot as it's root filesystem, and run 
the update from there), it's just not easy to do right now.
> 
> Or run a virtual machine on the server that boots from the snapshot and
> that update. Oh no, the virtual machine would slow down my running server
> to much.
Depends on how you put it together.  This also has issues because of 
starting a new instance of init.
> 
> Eh, share the snapshot via cifs or nfs to another machine that does a
> netboot and let that do the update.
This won't work reliably for other reasons, and will probably kill your 
network performance.
> 
> O wait, I forgot, I installed btrfs to make our system maintenance easier
> than with ext. Maybe that was a mistake, at least until distros take
> advantage of the aadvantage and start avoiding the pitfalls?
It really depends on your particular use case.
> 
>>> My point is: fsync is not targeted specifically in many common disk
>>> bench marks (phoronix?), it might be posible that there is no trigger
>>> to spend much time on optimizations in that area. That doesn't make it
>>> meaningless.
>>>
>>>> that dpkg infamously calls fsync after changing every bit of
>>>> information, so basically you're measuring fsync speed. Which is slow
>>>> on btrfs (compared to simpler filesystems), but unrelated to normal
>>>> work.
>>>
>>> OTOH it would be nice if dpkg would at last start making use btrfs
>>> snapshot features and abandon these unnecssary fsyncs completely,
>>> instead restoring a failed install from a snapshot. This would probably
>>> result in a performance improve compared to ext4.
>> Not dpkg, apt-get and wherever other frontedd you use (although all the
>> other dpkg frontends I know of are actually apt-get frontends).  Take a
>> look at how SUSE actually does this integration, it's done through
>> Zypper/YaST2, not RPM.  If you do it through dpkg, or RPM, or whatever
>> other low-level package tool, you need to do a snapshot per package so
>> that it works reliably, while what you really need is a snapshot per
>> high-level transaction.
>>
>> FWIW, if you can guarantee that the system won't crash during an update
>> (or are actually able to roll back by hand easily if it won't boot), you
>> can install libeatmydata and LD_PRELOAD it for the apt-get (or aptitude,
>> or synaptic, or whatever else) call, then call sync afterwards and
>> probably see a significant perofrmance improvement.  The library itself
>> overloads *sync() calls to be no-ops, so it's not safe to use when you
>> don't have good fallback options, but it tends to severely improve
>> performance for stuff like dpkg.
> 
> Yeah I can guarantee that it can crash... All you need to do is start the
> upgrade from a remote terminal, forget to use screen and then close the
> terminal. And if not the installer will run until the first 'do you want
> to replace the conf file Y/n' in the background, at which point you have
> no choice than to nuke it.
I meant the system itself, not the update.  What matters is that the 
filesystem isn't shut down unexpectedly, not that the update fails part 
way through (if you're using snapshots to give restore points, you've 
already got the case of the update failing covered).
> 
> But probably if you take a snapshot before eating the data you should be
> able to recover.
Indeed.
