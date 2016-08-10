Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:36205 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965226AbcHJS7J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 14:59:09 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bXMzQ-0006NE-Er
	for linux-btrfs@vger.kernel.org; Wed, 10 Aug 2016 08:27:44 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: checksum error in metadata node - best way to move root fs to
 new drive?
Date: Wed, 10 Aug 2016 06:27:38 +0000 (UTC)
Message-ID: <pan$d9b53$c31dc60$985cf806$b833643c@cox.net>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave T posted on Tue, 09 Aug 2016 23:27:56 -0400 as excerpted:

> btrfs scrub returned with uncorrectable errors. Searching in dmesg
> returns the following information:
> 
> BTRFS warning (device dm-0): checksum error at logical NNNNN on
> /dev/mapper/[crypto] sector: yyyyy metadata node (level 2) in tree 250
> 
> it also says:
> 
> unable to fixup (regular) error at logical NNNNNN on
> /dev/mapper/[crypto]
> 
> 
> I assume I have a bad block device. Does that seem correct? The
> important data is backed up.
> 
> However, it would save me a lot of time reinstalling the operating
> system and setting up my work environment if I can copy this root
> filesystem to another storage device.
> 
> Can I do that, considering the errors I have mentioned?? With the
> uncorrectable error being in a metadata node, what (if anything) does
> that imply about restoring from this drive?

Well, given that I don't see any other people more qualified than I, as a 
simple btrfs user and list regular, tho not a dmcrypt user and definitely 
not a btrfs dev, posting, I'll try to help, but...

Do you know what data and metadata replication modes you were using?  
Scrub detects checksum errors, and for raid1 mode on multi-device (but I 
guess you were single device) and dup mode on single device, it will try 
the other copy and use it if the checksum passes there, repairing the bad 
copy as well.

But until recently dup mode data on single device was impossible, so I 
doubt you were using that, and while dup mode metadata was the normal 
default, on ssd that changes to single mode as well.

Which means if you were using ssd defaults, you got single mode for both 
data and metadata, and scrub can detect but not correct checksum errors.

That doesn't directly answer your question, but it does explain why/that 
you couldn't /expect/ scrub to fix checksum problems, only detect them, 
if both data and metadata are single mode.

Meanwhile, in a different post you asked about btrfs on dmcrypt.  I'm not 
aware of any direct btrfs-on-dmcrypt specific bugs (tho I'm just a btrfs 
user and list regular, not a dev, so could have missed something), but 
certainly, the dmcrypt layer doesn't simplify things.  There was a guy 
here, Mark MERLIN, worked for google I believe and was on the road 
frequently, that was using btrfs on dmcrypt for his laptop and various 
btrfs on his servers as well -- he wrote some of the raid56 mode stuff on 
the wiki based on his own experiments with it.  But I haven't seen him 
around recently.  I'd suggest he'd be the guy to talk to about btrfs on 
dmcrypt if you can get in contact with him, as he seemed to have more 
experience with it than anyone else around here.  But like I said I 
haven't seen him around recently...

Put it this way.  If it were my data on the line, I'd either (1) use 
another filesystem on top of dmcrypt, if I really wanted/needed the 
crypted layer, or (2) do without the crypted layer, or (3) use btrfs but 
be extra vigilant with backups.  This since while I know of no specific 
bugs in btrfs-on-dmcrypt case, I don't particularly trust it either, and 
Marc MERLIN's posted troubles with the combo were enough to have me 
avoiding it if possible, and being extra careful with backups if not.

> If I can copy this entire root filesystem, what is the best way to do
> it? The btrfs restore tool? cp? rsync? Some cloning tool? Other options?

It depends on if the filesystem is mountable and if so, how much can be 
retrieved without error, the latter of which depends on the extent of 
that metadata damage, since damaged metadata will likely take out 
multiple files, and depending on what level of the tree the damage was 
on, it could take out only a few files, or most of the filesystem!

If you can mount and the damage appears to be limited, I'd try mounting 
read-only and copying what I could off, using conventional methods.  That 
way you get checksum protection, which should help assure that anything 
successfully copied isn't corrupted, because btrfs will error out if 
there's checksum errors and it won't copy successfully.

If it won't mount or it will but the damage appears to be extensive, I'd 
suggest using restore.  It's read-only in terms of the filesystem it's 
restoring from, so shouldn't cause further damage -- unless the device is 
actively decaying as you use it, in which case the first thing I'd try to 
do is image it to something else so the damage isn't getting worse as you 
work with it.

But AFAIK restore doesn't give you the checksum protection, so anything 
restored that way /could/ be corrupt (tho it's worth noting that ordinary 
filesystems don't do checksum protection anyway, so it's important not to 
consider the file any more damaged just because it wasn't checksum 
protected than it would be if you simply retrieved it from say an ext4 
filesystem and didn't have some other method to verify the file).

Altho... working on dmcrypt, I suppose it's likely that anything that's 
corrupted turns up entirely scrambled and useless anyway -- you may not 
be able to retrieve for example a video file with some dropouts as may be 
the case on unencrypted storage, but have a totally scrambled and useless 
file, or at least that file block (4K), instead.

> If I use the btrfs restore tool, should I use options x, m and S? In
> particular I wonder exactly what the S option does. If I leave S out,
> are all symlinks ignored?

Symlinks are not restored without -S, correct.  That and -m are both 
relatively new restore options -- back when I first used restore you 
simply didn't get that back.

If it's primarily just data files and you don't really care about 
ownership/permissions or date metadata, you can leave the -m off to 
simplify the process slightly.  In that case, the files will be written 
just as any other new file would be written, as the user (root) the app 
is running as, subject to the current umask.  Else use the -m and restore 
will try to restore ownership/permissions/dates metadata as well.

Similarly, you may or may not need -x for the extended attributes.  
Unless you're using selinux and its security attributes, or capacities to 
avoid running as superuser (and those both apply primarily to 
executables), chances are fairly good that unless you specifically know 
you need extended attributes restored, you don't, and can skip that 
option.

> I'm trying to save time and clone this so that I get the operating
> system and all my tweaks / configurations back. As I said, the really
> important data is separately backed up.

Good. =:^)

Sounds about like me.  I do periodic backups, but have run restore a 
couple times when a filesystem wouldn't mount, in ordered to get back as 
much of the delta between the last backup and current as possible.  Of 
course I know not doing more frequent backups is a calculated risk and I 
was prepared to have to redo anything changed since the backup if 
necessary, but it's nice to have a tool like btrfs restore that can make 
it unnecessary under certain conditions where it otherwise would be. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

