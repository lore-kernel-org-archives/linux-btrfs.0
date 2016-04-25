Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35669 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbcDYCFW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Apr 2016 22:05:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1auVto-0000Y8-AA
	for linux-btrfs@vger.kernel.org; Mon, 25 Apr 2016 04:05:20 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Apr 2016 04:05:20 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Apr 2016 04:05:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: restore is failing
Date: Mon, 25 Apr 2016 02:05:15 +0000 (UTC)
Message-ID: <pan$c13b$d4667668$908acc72$d65d05ec@cox.net>
References: <CAAcrkY+i1QW0dW5y3=szq9vJh8946shAvCehefbRKW4xqv_zBA@mail.gmail.com>
	<CAAcrkYKn=Eeb2z0axH7qNs-k7J_rMAgbxM9Bzn+T=FOmNkw2rQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

lenovomi posted on Sun, 24 Apr 2016 14:24:02 +0200 as excerpted:

> also can i use these attributes:
> 
> -x , -m , -S
> 
> to restore uid/gid/ perrmissions?

Please don't top-post.  Quote the part you're replying to and reply in 
context below it, as I do in the post.  Top posting adds just enough 
difficulty to reply properly that some people will simply skip it and you 
may not get the answer that would otherwise be the most helpful. [Here, 
I'm copying the above into context below, and will reply to the question 
there.]

> On Sun, Apr 24, 2016 at 2:11 PM, lenovomi <lenovomi@gmail.com> wrote:
>> hi,
>>
>> i run restore command and it restored around 300GB of data from 11TB
>> but failed here
>>
>> Skipping existing file
>> /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/hosts Restoring
>> /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
>> Error creating
>> /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/
>> idmapd.conf�.bkp: 22
>> Error searching
>> /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
>> Error searching
>> /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
[repeated...]

>> extent buffer leak: start 17802812047360 len 16384
>>
>>
>> Any idea why? is it because of the <?> character?
>>
>> my target directory /mnt/restore is nfs mount point.

Could be.

General boilerplate:

I'm a btrfs user and list regular, not a dev.

You don't mention what version of btrfs-progs you're trying to restore 
with.  That can be critical as some versions have known bugs, and also 
just in case you found a new bug, as that can help pin down whether it's 
a recent regression or something older.

(In most cases kernel version is useful as well, but in the case of 
restore it's all userspace code so the kernel version doesn't matter.)

Also, btrfs filesystem show can be helpful even if the filesystem won't 
mount, and if it will mount, btrfs filesystem usage or on older btrfs-
progs before usage worked well, btrfs filesystem df.

Back to the question:

I take it that ? is a replacement for an undisplayable character.  Do you 
know what character it's /supposed/ to be?  Is it possibly damage to the 
name entry itself?  It's not possible from this output to tell directly, 
but did that extent buffer leak output print out at the same time, such 
that it's likely the same error, or later than the stuff above it, so 
it's likely to be unrelated?

The repeated searching errors suggest that it may be a directory rather 
than a file, in which case it might be one error for each file that 
directory contains.  Also, without knowing your filesystem layout I can't 
say for sure, but it looks like it might have actually merged multiple 
separate entries together as if they're part of the same path.

What I'd do in a case like this is try using the --path-regex option (see 
the btrfs-restore manpage for an example, you may have to play around 
with it a bit) to restore just that file or directory to a local 
filesystem (maybe a thumb drive or some such if necessary, you can try 
the -D|--dry-run option first to see if it looks like it's going to 
work), getting any possible problem with unexpected characters over nfs 
out of the picture.

Regardless of whether that works, if the restore stops at that point but 
there's more that hasn't been restored, perhaps you can use the
--path-regex option on further restore attempts, grabbing one directory 
tree at a time beyond the problematic one.

[Requoted from above, now in context...]

> also can i use these attributes:
> 
> -x , -m , -S
> 
> to restore uid/gid/ perrmissions?

-m|--metadata restores owner/group/perms and times.  That wasn't an 
option originally, and btrfs restore would simply write everything out as 
the user (normally root) it was run as, using umask for permissions.  
I've had to do two restores, once before, once after, that option was 
added, and I definitely appreciate the guy that submitted that patch as 
the second one was a whole lot easier to get back into operation! =:^)  
(Fortunately in the first case I had a backup I could take most of the 
ownership and permissions from, I didn't worry about times, creating a 
script to automate the process. The restore was newer than my backup, 
however, so I preferred it for the actual file data.)

So I've used this option and it does what it says on the label. =:^)

-S|--symlinks:  When I saw the patch submitted to restore metadata, I 
immediately asked about symlinks as well, because that was something else 
I was missing on the first restore -- I had to recreate them manually.  
The metadata restoration patch didn't include that, but the guy who 
created that patch was happy to create a second one to deal with 
symlinks, once I asked. =:^)

So whether you want to use -S depends on whether you have symlinks and 
want to restore them or not.  Again, I've used this option and found it 
very helpful indeed, having had to work without it in the past.

Note that the symlink option had an off-by-one error as originally 
implemented.  This is an example of where knowing your version would be 
helpful.  It was fixed in 4.2.3, so assuming you're running something 
reasonably current it won't affect you, but if it's before 4.2.3 and you 
want to use the option, consider upgrading your btrfs-progs first.

-x|--xattr:  This option has been there longer than the other two, but 
I've never had to use it as I don't use extended attributes on anything 
on the filesystems I needed to recover.  So I have no experience with it, 
but you shouldn't need it unless you /have/ extended attributes to 
restore.  It's definitely not necessary for the uid/gid/perms you 
mentioned.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

