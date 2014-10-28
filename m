Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45511 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757076AbaJ1GPs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 02:15:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xj04I-0003zC-5j
	for linux-btrfs@vger.kernel.org; Tue, 28 Oct 2014 07:15:46 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 07:15:46 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 07:15:46 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Does btrfs-restore report missing/corrupt files?
Date: Tue, 28 Oct 2014 06:15:33 +0000 (UTC)
Message-ID: <pan$ef766$2edcf1bb$a32f25df$3780cebd@cox.net>
References: <trinity-716ca1fa-5a94-4624-9e01-8f4c4b500e46-1414310389248@3capp-gmx-bs26>
	<544EE5B1.5040704@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Mon, 27 Oct 2014 17:39:13 -0700 as excerpted:

> On 10/26/2014 12:59 AM, Christian Tschabuschnig wrote:
>>
>> Hello,
>>
>> currently I am trying to recover a btrfs filesystem which had a few
>> subvolumes. When running # btrfs restore -sx /dev/xxx .
>> one subvolume gets restored.
> 
> Important Aside: The one time I had to resort to btrfs restore I didn't
> get the contents of _many_ of the really small files. My _guess_ is that
> those where the files small enough to reside entirely within the
> original filesystem's metadata.
> 
> You should mount the filesystem read-only and recursively copy the
> hirearchy to another file system as well as doing a restore. The two
> results can then be folded together, or at least the former might help
> you find some of what the latter might miss.
> 
> I could be totally wrong, or restore could have been improved since
> then, but it was what seemed to be happening.

You don't mention how long ago that was, but FWIW, when I had to use 
btrfs restore during the 3.15 kernel cycle (with progs 3.14 or 3.14.1, 
I'd guess), the only thing I noticed missing was the symlinks.  I never 
thought about why, but metadata-only might indeed explain it.

It was only /var/log and /home (both independent filesystems, I prefer 
not to keep all my data eggs in a single filesystem basket) that I needed 
to restore, however.  / is mounted read-only by default, as it was that 
time, so it wasn't damaged, and /boot and /mnt/pkgs weren't mounted, so 
they weren't damaged either.  And of course the backup copies of all the 
above weren't mounted so weren't damaged, and my media partition is on 
spinning rust and still reiserfs (all my btrfs are on ssd).

The point being, the biggest set of small files that were on the 
filesystems I restored were the various user config files in /home.  I 
run kde and customize rather heavily, so I'd have tended to notice if 
they were missing, but they were restored just fine.  Like I said, it was 
just the symlinks that I noticed missing.  They were a bother to restore, 
but at least with missing symlinks, I knew what the "contents" was.

So presumably your restore experience was before the kernel 3.15 cycle, 
and presumably they fixed restore to deal with no-extent metadata-only 
files between your usage and mine.  But I've enough symlinks scattered 
around that having them go missing was a hassle.

As for mounting the filesystem read-only, that's definitely the best 
policy if it works.  But most of the time when people are resorting to 
restore, it's because the filesystem won't mount, even read-only, so 
that's unfortunately not an available option.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

