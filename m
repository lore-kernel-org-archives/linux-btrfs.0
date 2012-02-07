From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Several unhappy btrfs's after RAID meltdown
Date: Tue, 7 Feb 2012 09:53:59 +0000 (UTC)
Message-ID: <pan.2012.02.07.09.53.58@cox.net>
References: <20120205184128.GC18806@localhost.localdomain>
	<20120207033945.GA5639@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Ryan C. Underwood posted on Mon, 06 Feb 2012 21:39:45 -0600 as excerpted:

> Does anyone have any idea how I should proceed with the below quoted
> situation?  Unfortunately, I am going to have to give up on btrfs if it
> is really so fragile.  I am using kernel 3.2.2 and btrfs-tools from
> November.

Regardless of the technical details of your situation, keep in mind that 
btrfs is still experimental at this time, and remains under heavy 
development, as you'll have noticed if you read the kernel's changelogs 
or this list at all.  Kernel 3.2.2 is relatively recent altho you could 
try the latest 3.3 rc or git kernel as well, but I'd suggest a btrfs-
tools rebuild as November really isn't particularly current there.

However, complaining about the fragility of a still in development and 
marked experimental filesystem would seem disingenuous at best.  
Particularly when it's used on top of a dmcrypt layer that btrfs was 
known to have issues with (see the wiki), **AND** when you were using 
raid-5 and had not just a single spindle failure, but a double-spindle 
failure, a situation that's well outside anything raid-5 claims to handle 
(raid-6 OTOH... or triple-redundant raid-1 or raid-10...).

OK, so given you're running an experimental filesystem on a block-device 
stack it's known to have problems with, you surely had backups if the 
data was at all important to you.  Simply restore from those backups.  If 
you didn't care to make backups, when running in such a known unstable 
situation, well, obviously the data couldn't have been so important to 
you after all, as you obviously didn't care about it enough to do those 
backups, and by the sound of things, not even enough to be informed about 
the development and stability status of the filesystem and block-device 
stack you were using.

IOW, yes, btrfs is to be considered fragile at this point.  It's still in 
development, there's not even an error-correcting btrfsck yet, and you 
were using it on a block-device stack that the wiki specifically mentions 
is problematic.  Both the btrfs kernel option and the wiki have big 
warnings about the stability at this point, specifically stating that 
it's not to be trusted to safely hold data yet.  If you were using it 
contrary to those warnings and lost data due to lack of backups, there's 
no one to blame but yourself.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

