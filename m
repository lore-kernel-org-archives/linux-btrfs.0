Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from x1-6-a4-2b-8c-8c-bd-da.cpe.webspeed.dk ([2.104.2.239]:56190
	"EHLO mail.musikcheck.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbcECSbf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 14:31:35 -0400
Subject: Re: Subvolumes cannot be mounted after raid1 conversion
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <983F0471-51E8-47EC-B5A0-FBA9040F634B@hagenjohansen.dk>
 <20160503095515.GM7228@carfax.org.uk>
 <B66776EA-68EA-490F-862E-C49A1D51FCE5@hagenjohansen.dk>
 <20160503102746.GN7228@carfax.org.uk>
 <pan$53532$8cf28e4d$10d40c2$bb30f4bb@cox.net>
From: hasse@hagenjohansen.dk
Message-ID: <2a657997-6da8-a190-6057-7b5dcb5d70b1@hagenjohansen.dk>
Date: Tue, 3 May 2016 20:31:29 +0200
MIME-Version: 1.0
In-Reply-To: <pan$53532$8cf28e4d$10d40c2$bb30f4bb@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Den 03/05/16 kl. 18:30 skrev Duncan:
> Hugo Mills posted on Tue, 03 May 2016 10:27:46 +0000 as excerpted:
> 
>> Given those symptoms (mount doesn't report errors, but no mount
>> happens), I would guess that your problem is with systemd. It has a bug
>> where it sometimes unmounts things immediately after you've mounted
>> them.
> 
> FWIW, I have some personal experience with that "bug" myself.  But I 
> suspect the systemd devs might call it a "feature", not a bug.  Based on 
> my own experience and understanding...
> 
> The mount does actually happen.  It's just that, as Hugo says, systemd 
> immediately unmounts it, because...
> 
> While mount (the command) itself is not a systemd command, and it works 
> by making the appropriate kernel calls to accomplish the mount with the 
> specified options, so systemd can't directly stop the actual mount...
> 
> The systemd perspective looks rather different...
> 
> Systemd actually uses its own mount units (*.mount files) to track 
> mounts, generating them dynamically from fstab for entries found there.  
> As with all systemd unit files, there's documentation; start with 
> systemd.mount.  If you're not familiar with systemd units, systemd.unit,  
> systemd-fstab-generator and systemd.device manpages, among others listed 
> in systemd.mount's SEE ALSO section, will certainly help.
> 
> If you look in /run/systemd/generator/ (where /run is a tmpfs mounted by 
> systemd itself, so these files are actually in memory only), you will see 
> the mount units the systemd generator creates dynamically.  These files 
> follow the format documented in the manpages discussed above, and it can 
> be quite educational to read a few of these files and compare them to the 
> fstab entries they were generated from to get some insights on how it all 
> fits together.
> 
> So far so good.  But where things get interesting is in the device units 
> (*.device files) and how they interact with mounts and with udev.
> 
> The problem turns out to be that between udev and systemd, sometimes 
> systemd doesn't see the required devices available that it believes are 
> required by a particular mount unit.  The kernel of course has its own 
> idea of what devices are available, and will mount or fail to mount the 
> filesystem based on that, which is why the mount actually succeeds.  But 
> if systemd thinks those devices aren't there, it will immediately unmount 
> the filesystem on its own, fast enough that the only way you can 
> generally tell it was mounted is by noting that mount didn't return an 
> error and by dmesg output such as the skinny extents notation that will 
> normally be printed if the filesystem was created with half-current btrfs-
> progs on a half-current kernel.  Otherwise, it looks as if the filesystem 
> was never mounted at all, because systemd umounts it so fast.
> 
> So the trick is to convince systemd (via udev) that all the devices are 
> actually there, after which it will leave the filesystem mounted.
> 
> Here's where my experience breaks down a bit, as in my case, I was trying 
> to boot to systemd rescue mode, to work on these filesystems, and found 
> out that in rescue mode (the rescue target) systemd hadn't started some 
> of the udev services, etc, and thus thought devices were missing, so it 
> wouldn't mount the filesystems.  However, by booting to emergency mode 
> (the emergency target), systemd would run the necessary pre-filesystem 
> udev, etc services and do the mounts in fstab, and then I could umount 
> and mount just fine, because udev was running and tracking the devices, 
> so systemd knew they were there and would let manual mounts and umounts 
> work properly.
> 
> What I have /not/ specifically figured out, however, is which specific 
> services that emergency mode runs that rescue mode doesn't, are involved, 
> other than I'm quite sure that udev's involved, and of course from there 
> I've only a vague idea how the specific device dependencies are worked 
> out.
> 
> It's this last bit that will likely need tweaked a bit to get systemd 
> aware of what device units need to be available for that mount unit, and 
> aware that they /are/ actually available.
> 
> So yeah, as I said, from systemd's perspective, it's arguably a feature, 
> not a bug.  You "just" need to adjust the udev, mount unit and device 
> unit configuration, so that systemd via udev knows what devices are 
> required and actually knows they're available, and all _should_ be well.
> 
> But the trick is in that "just"... which isn't likely to be quite so 
> simple, especially if you have little existing knowledge and experience 
> of systemd unit basics and how they work on for example the service and 
> target unit levels.  As I already have some experience at that level, 
> once I figured out that the mounts were actually happening and systemd 
> was immediately umounting, I already had a reasonable idea as to why, and 
> what sort of thing I needed to do to fix it.  In my case, it was simply 
> that I needed to boot to emergency instead of rescue mode for my 
> "singleuser mode", and I haven't bothered looking into it further, but 
> I'd have a head-start on it if I did as I'm already used to doing custom 
> service, target and timer units.  Without that information, it'd 
> definitely take awhile longer to figure it all out, and I expect many 
> people will simply give up and find some other solution that works for 
> them, instead of trying to figure out why this one isn't, and fixing it 
> so it does.
> 

Thanks for the very extensive explanation. I did find out systemd did
the umount by looking in /var/log/syslog. Now I wil try to fixup systemd
unit files and I will try not boot in either rescue or emergency mode. I
believe it is fixable without it. It seems systemd thinks it is my old
LVM setup(which now are moved to btrfs) which should be used and
immediately unmounts the filesystem again because it cannot find the
"LVM device". But I must say I find it a little bit stupid that systemd
doesn't monitor /etc/fstab now that it behind the users back are
generating its own unit files (I have actually seen the mount.xxx units
etc when looking at running units...but have never looked into how it
works...so I would now have to study that)

Best Regards
Hasse
