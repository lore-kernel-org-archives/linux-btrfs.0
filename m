Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59187 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaAEIfb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jan 2014 03:35:31 -0500
Date: Sat, 4 Jan 2014 22:39:57 -0800
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-transaction blocked for more than 120 seconds
Message-ID: <20140105063957.GF11749@merlins.org>
References: <52C2AE7C.5020601@gmx.at>
 <pan$63cef$9a8ef2ee$a00edd59$ef37592e@cox.net>
 <20140103172506.GA10021@merlins.org>
 <pan$6ce5a$53830c0$382c1e0e$7169217c@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$6ce5a$53830c0$382c1e0e$7169217c@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 03, 2014 at 09:34:10PM +0000, Duncan wrote:
> > Thank you for that tip, I had been unaware of it 'till now.
> > This will make my virtualbox image directory much happier :)
> 
> I think I said it, but it bears repeating.  Once you set that attribute 
> on the dir, you may want to move the files out of the dir (to another 
> partition would make sure the data is actually moved) and back in, so 
> they're effectively new files in the dir.  Or use something like cat 
> oldfile > newfile, so you know it's actually creating the new file, not 
> reflinking.  That'll ensure the NOCOW takes effect.

Yes, I got that. That why I ran btrfs defrag on the files after that (I
explained why, copy would waste lots of snapshot space by replacing all
the block needlessly).
 
> > Unfortunately, on a 83GB vdi (virtualbox) file, with 3.12.5, it did a
> > lot of writing and chewed up my 4 CPUs. Then, it started to be hard to
> > move my mouse cursor and my procmeter graph was barely updating seconds.
> > Next, nothing updated on my X server anymore, not even seconds in time
> > widgets.
> > 
> > But, I could still sometimes move my mouse cursor, and I could sometimes
> > see the HD light fliker a bit before going dead again. In other words,
> > the system wasn't fully deadlocked, but btrfs sure got into a state
> > where it was unable to to finish the job, and took the kernel down with
> > it (64bit, 8GB of RAM).
> > 
> > I waited 2H and it never came out of it, I had to power down the system
> > in the end.  Note that this was on a top of the line 500MB/s write
> > Samsung Evo 840 SSD, not a slow HD.
> 
> That was defrag (the command) or autodefrag (the mount option)?  I'd 
> guess defrag (the command).

defrag, the btrfs subcommand.

> That's fragmentation for you!  What did/does filefrag have to say about 
> that file?  Were you the one that posted the 6-digit extents?

Nope, I never posted anything until now. Hopefully you agree that it's
not ok for btrfs/kernel to just kill my system for over 2H until I power
it off before of defragging one file. I did hit a severe performance but
if it's not a never ending loop.

gandalfthegreat:/var/local/nobck/VirtualBox VMs/Win7# filefrag Win7.vdi 
Win7.vdi: 156222 extents found

Considering how virtualbox works, that's hardly surprising.

> For something that bad, it might be faster to copy/move it off-device 
> (expect it to take awhile) then move it back.  That way you're only 
> trying to read OR write on the device, not both, and the move elsewhere 
> should defrag it quite a bit, effectively sequential write, then read and 
> write on the move back.

Yes, I know how I can work around the problem (although I'll likely have
to delete all my historical snapshots to delete the old blocks, which I
don't love to do).
But doesn't it make sense to see why the kernel is near deadlocking on a
single file defrag first?

> But even that might be prohibitive.  At some point, you may need to 
> either simply give up on it (if you're lazy), or get down and dirty with 
> the tracing/profiling, working with a dev to figure out where it's 
> spending its time and hopefully get btrfs recoded to work a bit faster 
> for that sort of thing.

I'm on my way to a linux conf where I'm speaking, so I have limited time
and can't crash my laptop, but I'm happy to type some commands and give
output.

> As I suggested above, you might try the old school method of defrag, move 
> the file to a different device, then move it back.  And if possible do it 
> when nothing else is using the system.  But it may simply be practically 
> inaccessible with a current kernel, in which case you'd either have to 
> work with the devs to optimize, or give it up as a lost cause. =:(
 
I can fix my problem, actually virtualbox works fine with the fragmented
file, without even feeling slow, so really I don't need to fix it
urgently, I was just trying it out after your post.
 
> Then if the process completed successfully, you could cat the parts back 
> together again... and the written parts would be basically sequential, so 
> that should go MUCH faster! =:^)

All that noted, but I'm not desperate, just trying commands I hadn't
tried yet :)

Thanks for your replies,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
