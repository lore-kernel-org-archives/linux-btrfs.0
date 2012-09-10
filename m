Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:38719 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297Ab2IJTX6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Sep 2012 15:23:58 -0400
Received: by mail-ie0-f174.google.com with SMTP id e11so3917475iej.19
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2012 12:23:58 -0700 (PDT)
Message-ID: <1347305070.2360.20.camel@cwalton-XPS-8300>
Subject: Re: Seagate Momentus XT and btrfs corruption
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 10 Sep 2012 15:24:30 -0400
In-Reply-To: <5047DD0F.9040501@statystyka.net>
References: <5047DD0F.9040501@statystyka.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2012-09-06 at 01:15 +0200, Adam Ryczkowski wrote:
> Welcome,
> 
> I experience continuus degradation of btrfs system partition on hybrid 
> 750GB Seagate Momentus XT-2  (ATA ST750LX003-1AC15, rev. SM12). dmesg 
> fills with hundreds of errors like "btrfs csum failed ino 93608 off 
> 425984 csum 2316250426 private 3579463503".
> 
> I had simmilar problems with the older model, Seagate Momentus XT bought 
> two years ago, where firmware update didn't solve them (cf. 
> http://superuser.com/questions/313447/seagate-momentus-xt-corrupting-files-linux-and-mac 
> and 
> http://forums.seagate.com/t5/Momentus-XT-Momentus-Momentus/Momentus-XT-corrupting-large-files-Linux/m-p/109008). 
> 
> 
> Now I want to give Linux another try on this amazingly fast hardrive. 
> Yes - the drive perfectly well under default drivers on Windows XP. I 
> use it everyday and I never lost a single byte under Windows.

Hi,
I was seeing similar corruption issues with an older Linux version on my
Momentus XT 500gb, but with recent kernel versions (and the latest drive
firmware, I think I have SD28 right now) I haven't seen any issues at
all. It's been quite solid. Please make sure that you're running the
latest stable kernel, also... I'm currently using 3.5.3.
(I have no idea what the new revision XT-2 is like, I hope they haven't
duplicated the firmware issue! It's still so new there doesn't seem to
be much feedback.)

> What can I do on my part to help you troubleshoot the problem? I guess I 
> might do some sort of tripwiring files to see that their contents 
> actually degrades, but I think it the result is obvious and not very 
> helpful to you.

I still don't know the actual root cause of the problem; but from the
posts on the seagate forums it may have had something to do with the
Linux ram disk caching or possibly a drive NCQ bug. Is there any chance
you could attempt to reproduce the issue with the latest linux kernel
and a freshly formatted filesystem?

> If you can't help me, please advise me, how to heal the partition - the 
> offline btrfsck (from btrfs-tools 0.19 available on Mint 13) doesn't fix 
> anything here.

I'm not currently aware of any fix, other than deleting/rewriting the
offending files. Assuming you have backups of your personal data, it
might be fastest to just reformat and reinstall. It might be possible to
hack btrfs to ignore the checksum errors to allow you to read the
corrupted files? I'm not sure.

> Is there any way to tell which files are getting broken?

The kernel log message prints an inode number in the log:

> "btrfs csum failed ino 93608 off 425984 csum 2316250426 private 3579463503".

You can use the 'find' command to track this inode number to a file (or
files, if there are hardlinks involved:

find /btrfs/mountpoint -inum 93608

> I use Mint 13, 3.2.0-30-generic 64-bit kernel.

3.2 is old! Keep in mind that given the current state of btrfs
development, fixes for btrfs are usually not backported to old stable or
longterm kernel releases, although some distributions have done so.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

