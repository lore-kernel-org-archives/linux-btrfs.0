Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47966 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755207AbbJ1FVe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Oct 2015 01:21:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZrJAy-0002Ed-PM
	for linux-btrfs@vger.kernel.org; Wed, 28 Oct 2015 06:21:32 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 06:21:32 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2015 06:21:32 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: random i/o error without error in dmesg
Date: Wed, 28 Oct 2015 05:21:13 +0000 (UTC)
Message-ID: <pan$31224$86839f8e$da37e2a5$124e475b@cox.net>
References: <562E0D31.2080003@dblaci.hu> <5339076.FcC2BAjqs5@thetick>
	<pan$69543$b4766f34$8286648d$3871cb8f@cox.net>
	<1844690.p2LsPbdn9l@thetick>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Joliet posted on Tue, 27 Oct 2015 21:54:40 +0100 as excerpted:

>>IOW, does it take a full reboot to clear the problem, or is a simple
>>ro/rw mount cycle enough, or an unmount/remount?
> 
> Seems that a full reboot is needed, but I would expect that it would
> have the same effect if I were to pivot back into the initramfs, unmount
> / from there,
> then boot back into the system.  Because quite frankly, I can't think of
> any reason why a power cycle to the SSD should make a difference here. 
> I vaguely remember that systemd can do that, so I'll see if I can find
> out how.

Agree with both the systemd returning to the initr* point (which I 
actually had in mind while writing the above but don't remember the 
details either, so chose to omit in the interest of limiting the size of 
the reply and research necessary to generate it), and the ssd power-cycle 
point.

>>Finally, assuming root itself isn't btrfs, if you have btrfs configured
>>as a module, you could try unmounting all btrfs and then unloading the
>>module, then reloading and remounting.  That should entirely clear all
>>in-memory btrfs state, so if that doesn't solve the problem, while
>>rebooting does, then the problem's very possibly outside of btrfs scope.
>> Of course if root is btrfs, you can't really check that.
> 
> Nope, btrfs is built-in (though it doesn't have to be, what with me
> using an initramfs).

Same here, also gentoo as I guess you know from previous exchanges.  But 
unfortunately, if your initr* is anything like mine, and your kernel 
monolithic as mine, making btrfs a module with a btrfs root isn't the 
easy thing it might seem to those who run ordinary distro supplied binary 
kernels with pretty much everything modularized, as doing so involves a 
whole new set of research on how to get that module properly included in 
the initr* and loaded there, as well as installing and building the whole 
module-handling infrastructure (modprobe and friends) again, as it's not 
actually installed on the system at all at this point, because with the 
kernel entirely monolithic, module-handling tools are unnecessary and 
thus just another unnecessary package to have to keep building updates 
for, if they remain installed.

So I definitely sympathize with the feeling that such a stone is better 
left unturned, if overturning it is at all a possibility that can be 
avoided, as it is here, this whole exercise being simply one of better 
pinning the bug down, not yet actually trying to solve it.  And given 
that unturned stone, there are certainly easier ways.

And one of those easier ways is investigating that whole systemd return 
to initr* idea, since we both remember reading something about it, but 
aren't familiar with the details.  In addition to addressing the problem 
headon if anyone offers a way to do so, that's the path I'd be looking at 
right now.


Meanwhile, addressing something in the snipped content, if a mount 
refuses to remount read-only, it's normally due to deleted but still open 
files.  Often, in many cases the overwhelming majority of the time, 
that's due to updates that have been done, removing for instance old 
library files that are still loaded into running executables.  The 
generalized solution is to quit or restart the affected executables, thus 
releasing the last open references to the otherwise already deleted 
library and other files, so the filesystem can finish deleting them.  
Once this is done, the filesystem can normally be remounted ro (tho bugs 
like the one of this thread may prevent that).

The problem lies in actually figuring out what still running executables 
are still holding open file references to otherwise deleted files.  /proc/ 
actually makes this sort of data available in its collection of files for 
a running process, as there's one (as the saying goes, finding which one 
is an exercise left for the reader, as I could look it up or check, but 
so can you if you're /that/ interested) that tells which files the 
process has open, and deleted files are clearly marked.

But it's still a hassle to go thru the appropriate /proc/ files for each 
process, at least if it's done manually, so various helper tools have 
been developed to automate the process.  The one I use here is a python-
based script, packaged on gentoo as...

app-admin/lib_users

Run as root, it'll tell you which executables are running that still hold 
references to deleted files, so you can restart them.  Of course when a 
library was updated for security reasons doing this restart is a good 
idea from that perspective as well.  Some tools actually have a table of 
executables and the services they belong to, and will automate the 
restart, but of course these sorts of tools tend to be somewhat complex 
and distro specific, while lib_users simply tells you the executables and 
lets you decide what to do with that information, that being both simpler 
and without the distro-specifics of the lists that the fully automated 
tools must use.

If you do your updates while an X-based session is running and run 
lib_users before shutting it down, you'll often find a whole slew of x-
based executables listed, so much so that I don't even bother until I've 
shut down X, these days.  That leaves only services and longer running CLI 
executables, perhaps including the shell itself, in the list.

If it's only a couple higher-level services listed, it's generally 
simplest to just restart them.  If it's many services or lower level 
services such that restarting them will disturb the services depending on 
them[1], from my experience, it's often easier to simply do a systemctl 
emergency, perhaps even hitting ctrl-D straight from the resulting root 
password prompt, to go immediately back to multi-user mode, as even 
without entering the password, the drop to emergency mode will have 
restarted all normal services.

What's left in the lib_user list after a dip to emergency mode, whether 
you've returned to multi-user mode or not, is often only systemd and 
perhaps its journald service, itself.  Journald can be restarted manually 
in the usual way (systemctl restart journald.service or whatever, I 
usually use tab completion so don't pay all that much attention to the 
specific name), if necessary, while systemd itself can be "reexecuted" 
using the systemctl daemon-reexec (tab-completion again) command.

With a drop out of X mode, a dip to emergency mode and reexecing systemd 
itself, at least in my experience with what I'm running here, lib_users 
normally reports nothing further, and a remount read-only succeeds.

Of course, if lib_users reports nothing further still holding references 
to deleted files, and a remount read-only STILL fails, that's a major 
note of trouble and an important finding in itself.


Meanwhile, as explained in the systemd docs (specifically the systemd for 
administrators series, IIRC), systemd dropping back to the initr* is 
actually its way of automatically doing effectively the same thing we 
were using lib_users and all those restarts to do, getting rid of all 
possible still running on root executables, including systemd itself, by 
reexecing systemd itself back in the initr*, as a way to help eliminate 
*everything* running on root, so it can not only be remounted read-only, 
but actually unmounted the same as any other filesystem, as userspace is 
now actually running from the initr* once again.  That's a far *FAR* 
safer reboot after upgrade than traditional sysvinit solutions were able 
to do. =:^)

So the whole systemd switchroot back to initr* thing happens to be 
actually linked in here too.  Tho in this case we'd be using it for more, 
and indeed, there are systemd docs on how to get the reboot process to 
stop in in the initr*[1].  While I don't recall actually seeing anything 
about short-circuiting the reboot and restarting from the initr*, it 
should certainly be possible to configure systemd and the initr* to allow 
it.

And I might have it configured that way here too, to short-circuit the 
reboot, were it not for the two facts that I (1) often use a dip to 
emergency mode (and reexec of systemd if necessary) for many of the 
reasons one might otherwise dip to initr*, and (2) generally track pre-
release kernels, so a lot of the time when I reboot, it's to start a 
freshly built kernel, and the dip to initr* wouldn't help with that.

---
[1] Low-level services:  Low-level services aren't so much a problem with 
systemd, since it generally keeps thinks like sockets available and hooks 
them back up to the restarted service, without disturbing the higher 
level services that would otherwise need a restart too, at all.  But the 
shear number of otherwise manual restarts necessary can still make it 
easier to simply dip to emergency mode temporarily, before going normal 
multi-user again.

[2] Stopping the reboot process back in the initr*, before final 
restart:  I did actually try to get this working at one point, but due to 
some particulars specific to my own rather strange layout, certain initr* 
related systemd service file symlinks were orphaned at the time, and it 
didn't work as it was designed and documented to work.  I've since fixed 
those symlink issues, but I've not tried again to stop in the initr* on 
the way down, so I've never actually seen it do that, tho if I'm fast 
enough and the reboot slow enough, I can at least see the return to initr* 
stuff scrolling by now before it blinks out, and it wasn't doing that 
before, so I expect I could actually get it to stop in in the initr* on 
the way down, now, if I tried, by following the documentation.  Anyway, 
that's why I'm not offering specific help on that aspect, because it was 
broken for me when I tried it, and while I believe it fixed now, I've not 
tried it since the fix, so I don't have the actual benefit of experience 
to offer.
-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

