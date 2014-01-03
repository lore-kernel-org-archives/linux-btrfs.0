Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39900 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbaACVek (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 16:34:40 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VzCO4-0007v6-MA
	for linux-btrfs@vger.kernel.org; Fri, 03 Jan 2014 22:34:36 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 22:34:36 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jan 2014 22:34:36 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-transaction blocked for more than 120 seconds
Date: Fri, 3 Jan 2014 21:34:10 +0000 (UTC)
Message-ID: <pan$6ce5a$53830c0$382c1e0e$7169217c@cox.net>
References: <52C2AE7C.5020601@gmx.at>
	<pan$63cef$9a8ef2ee$a00edd59$ef37592e@cox.net>
	<20140103172506.GA10021@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Fri, 03 Jan 2014 09:25:06 -0800 as excerpted:

> First, a big thank you for taking the time to post this very informative
> message.
> 
> On Wed, Jan 01, 2014 at 12:37:42PM +0000, Duncan wrote:
>> Apparently the way some distribution installation scripts work results
>> in even a brand new installation being highly fragmented. =:^(  If in
>> addition they don't add autodefrag to the mount options used when
>> mounting the filesystem for the original installation, the problem is
>> made even worse, since the autodefrag mount option is designed to help
>> catch some of this sort of issue, and schedule the affected files for
>> auto-defrag by a separate thread.
>  
> Assuming you can stomach a bit of occasional performance loss due to
> autodefrag, is there a reason not to always have this on btrfs
> filesystems in newer kernels? (let's say 3.12+)?
> 
> Is there even a reason for this not to become a default mount option in
> newer kernels?

For big "internal write" files, autodefrag isn't yet well tuned, because 
it effectively write-magnifies too much, forcing rewrite of the entire 
file for just a small change.  If whatever app is more or less constantly 
writing those small changes, faster than the file can be rewritten...

I don't know where the break-over might be, but certainly, multi-gig 
sized IO-active VMs images or databases aren't something I'd want to use 
it with.  That's where the NOCOW thing will likely work better.

IIRC someone also mentioned problems with autodefrag and an about 3/4 gig 
systemd journal.  My gut feeling (IOW, *NOT* benchmarked!) is that double-
digit MiB files should /normally/ be fine, but somewhere in the lower 
triple digits, write-magnification could well become an issue, depending 
of course on exactly how much active writing the app is doing into the 
file.

As I said there's more work going into tuning autodefrag ATM, but as it 
is, I couldn't really recommend making it a global default... tho maybe a 
distro could enable it by default on a no-VM desktop system (as opposed 
to a server).  Certainly I'd recommend most desktop types enable it.

>> The NOCOW file attribute.
>> 
>> Simple command form:
>> 
>> chattr +C /path/to/file/or/directory
>  
> Thank you for that tip, I had been unaware of it 'till now.
> This will make my virtualbox image directory much happier :)

I think I said it, but it bears repeating.  Once you set that attribute 
on the dir, you may want to move the files out of the dir (to another 
partition would make sure the data is actually moved) and back in, so 
they're effectively new files in the dir.  Or use something like cat 
oldfile > newfile, so you know it's actually creating the new file, not 
reflinking.  That'll ensure the NOCOW takes effect.

> Unfortunately, on a 83GB vdi (virtualbox) file, with 3.12.5, it did a
> lot of writing and chewed up my 4 CPUs. Then, it started to be hard to
> move my mouse cursor and my procmeter graph was barely updating seconds.
> Next, nothing updated on my X server anymore, not even seconds in time
> widgets.
> 
> But, I could still sometimes move my mouse cursor, and I could sometimes
> see the HD light fliker a bit before going dead again. In other words,
> the system wasn't fully deadlocked, but btrfs sure got into a state
> where it was unable to to finish the job, and took the kernel down with
> it (64bit, 8GB of RAM).
> 
> I waited 2H and it never came out of it, I had to power down the system
> in the end.  Note that this was on a top of the line 500MB/s write
> Samsung Evo 840 SSD, not a slow HD.

That was defrag (the command) or autodefrag (the mount option)?  I'd 
guess defrag (the command).

That's fragmentation for you!  What did/does filefrag have to say about 
that file?  Were you the one that posted the 6-digit extents?

For something that bad, it might be faster to copy/move it off-device 
(expect it to take awhile) then move it back.  That way you're only 
trying to read OR write on the device, not both, and the move elsewhere 
should defrag it quite a bit, effectively sequential write, then read and 
write on the move back.

But even that might be prohibitive.  At some point, you may need to 
either simply give up on it (if you're lazy), or get down and dirty with 
the tracing/profiling, working with a dev to figure out where it's 
spending its time and hopefully get btrfs recoded to work a bit faster 
for that sort of thing.

> I think I had enough free space:
> Label: 'btrfs_pool1'  uuid: 4850ee22-bf32-4131-a841-02abdb4a5ba6
> 	Total devices 1 FS bytes used 732.14GB
> 	devid    1 size 865.01GB used 865.01GB path /dev/dm-0
> 
> Is it possible expected behaviour of defrag to lock up on big files?
> Should I have had more spare free space for it to work?
> Other?

>From my understanding it's not the file size, but the number of 
fragments.  I'm guessing you simply overwhelmed the system.  Ideally you 
never let it get that bad in the first place. =:^(

As I suggested above, you might try the old school method of defrag, move 
the file to a different device, then move it back.  And if possible do it 
when nothing else is using the system.  But it may simply be practically 
inaccessible with a current kernel, in which case you'd either have to 
work with the devs to optimize, or give it up as a lost cause. =:(


> On the plus side, the file I was trying to defragment and hung my
> system,
> was not corrupted by the process.
> 
> Any idea what I should try from here?

Beyond the above, it's let the devs hack on it time. =:^\

One other /narrow/ possibility if you're desperate.  You could try 
splitting the file into chunks (generic term not btrfs chunks) of some 
arbitrary shorter size, and copying them out.  If you spit into say 10 
parts, then each piece should take roughly a tenth of the time, altho 
more fragmented areas will likely take longer.  But by splitting into say 
100 parts (which would be ~830 MiB apiece), you could at least see the 
progress and if there was one particular area where it suddenly got a lot 
worse.

I know there's tools for that sort of thing, but I'm not enough into 
forensics to know much about them...

Then if the process completed successfully, you could cat the parts back 
together again... and the written parts would be basically sequential, so 
that should go MUCH faster! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

