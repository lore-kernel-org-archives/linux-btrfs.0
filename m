Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53718 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbaAORUf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 12:20:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W3U8g-00086i-VD
	for linux-btrfs@vger.kernel.org; Wed, 15 Jan 2014 18:20:27 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 18:20:26 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 18:20:26 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Hitting error after failed balance
Date: Wed, 15 Jan 2014 17:19:59 +0000 (UTC)
Message-ID: <pan$531be$2152e31a$a613778b$5a9c372f@cox.net>
References: <vnkwfvoq73cp.fsf@mitchelh-linux.qualcomm.com>
	<vnkwvbxm9mkw.fsf@mitchelh-linux.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mitchel Humpherys posted on Tue, 14 Jan 2014 15:21:19 -0800 as excerpted:

> On Tue, Jan 14 2014 at 11:47:18 AM, Mitchel Humpherys
> <mitch.special@gmail.com> wrote:

>>     
>>     Btrfs v3.12
>>
>>     $ uname -a
>>     Linux mitchelh-linux 3.12.6-1-ARCH #1 SMP PREEMPT Fri
>>     Dec 20 19:39:00 CET 2013 x86_64 GNU/Linux
>>
> Well I tried btrfsck --repair and now it appears to be unmountable...

[If you wish to continue being direct-mailed as well, please keep that 
request in every reply, as I read/reply-to this list as a newsgroup via 
gmane.org, and in my news client replying via email is an extra step, so 
I don't do it by default but do try to honor requests when I see 'em.]

You're aware that btrfsck --repair is considered a last-ditch option, 
right?

In some cases it makes the problems worse, not better.  There are other 
things to be tried first, and when it comes down to btrfsck --repair, if 
the filesystem is mountable as yours was, the recommendation is to update 
your backups if you need to (since btrfs is considered testing and still 
under development, you should have routine/tested backups any time you're 
testing it anyway, thus it's update an existing backup, not make your 
FIRST one =:^), test that you can recover from the backup in case the 
btrfsck --repair makes things worse, and /then/ try the repair.

>     $ sudo mount -a
>     mount: wrong fs type, bad option, bad superblock on
>     /dev/sda6, missing codepage or helper program, or other error

> and here's the kernel log from the mount -a:
> 
>     [13479.995191] btrfs: failed to read log tree
>     [13480.051334]
>     btrfs: open_ctree failed

There's the btrfs-zero-log tool.  When it's saying the log can't be read, 
that's the thing to try.  You will lose the last few seconds of 
transactions from the log since the last commit, but btrfs is designed to 
maintain a consistent commit-state, so in theory, anyway, when the log is 
corrupt and can't be used anyway, zeroing it should at least get you back 
to a consistent filesystem state.

Tho I'm not sure what further damage btrfsck --repair might have done or 
what further damage you may have had from the failed balance and 
previous.  But hopefully without the log, the filesystem is at least 
mountable.

> So close! :)
> 
> Am I completely hosed?

If zero-log doesn't work, there's still hope.  You can try btrfs-find-
root and btrfs restore, using the instructions here:

https://btrfs.wiki.kernel.org/index.php/Restore

In general, if you haven't already, I'd suggest spending some time 
reading the documentation on the wiki.  You can also read some of the 
back-list posts right here, say from gmane.org, since not all the common 
wisdom on the list may be on the wiki just yet.  I use the nntp/news 
interface, but there's also a web interface (actually multiple web 
interfaces, take your pick =:^), if you're not familiar with nntp or 
simply don't want to bother setting up a proper nntp client.

If that doesn't work either, well, it may be time to mkfs.btrfs and fall 
back to the backups.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

