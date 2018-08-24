Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:59270 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbeHXIzW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Aug 2018 04:55:22 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1ft4W3-0005pn-0x
        for linux-btrfs@vger.kernel.org; Fri, 24 Aug 2018 07:20:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-convert missing in btrfs-tools v4.15.1
Date: Fri, 24 Aug 2018 05:20:04 +0000 (UTC)
Message-ID: <pan$ec0d6$d2f0d34b$37d58ea8$67a6a800@cox.net>
References: <1438689914.6655.1532811050018@connect.xfinity.com>
        <20180728213448.GA16016@DigitalMercury.dynalias.net>
        <20180809115046.GX3218@twin.jikos.cz>
        <20180823181516.4oq4yu7xzzueligq@navis>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nicholas D Steeves posted on Thu, 23 Aug 2018 14:15:18 -0400 as excerpted:

>> It's in my interest to ship all tools in distros, but there's also only
>> that much what the upstream community can do. If you're going to
>> reconsider the status of btrfs-convert in Debian, please let me know.
> 
> Yes, I'd be happy to advocate for its reinclusion if the answer to 4/5
> of the following questions is "yes".  Does SUSE now recommend the use of
> btrfs-convert to its enterprise customers?  The following is a
> frustrating criteria, but: Can a random desktop user run btrfs-convert
> against their ext4 rootfs and expect the operation to succeed?  Is
> btrfs-convert now sufficiently trusted that it can be recommended with
> the same degree of confidence as a backup, mkfs.btrfs, then restore to
> new filesystem approach?  Does the user of a btrfs volume created with
> btrfs-convert have an equal or lesser probability of encountering bugs
> compared to a one who used mkfs.btrfs?

Just a user and list regular here, and gentoo not debian, but for what it 
counts...

I'd personally never consider or recommend a filesystem converter over 
the backup, mkfs-to-new-fs, restore-to-new-fs, method, for three reasons.

1) Regardless of how stable a filesystem converter is and what two 
filesystems the conversion is between, "things" /do/ occasionally happen, 
thus making it irresponsible to use or recommend use of such a converter 
without a suitably current and tested backup, "just in case."

(This is of course a special case of the sysadmin's first rule of 
backups, that the true value of data is defined not by any arbitrary 
claims, but by the number of backups of that data it's considered worth 
the time/trouble/resources to make/have.  If the data value is trivial 
enough, sure, don't bother with the backup, but if it's of /that/ low a 
value, so low it's not worth a backup even when doing something as 
theoretically risky as a filesystem conversion, why is it worth the time 
and trouble to bother converting it in the first place, instead of just 
blowing it away and starting clean?)

2) Once a backup is considered "strongly recommended", as we've just 
established that it should be in 1 regardless of the stability of the 
converter, just using the existing filesystem as that backup and starting 
fresh with a mkfs for the new filesystem and copying things over is 
simply put the easiest, simplest and cleanest method to change 
filesystems.

3) (Pretty much)[1] Regardless of the filesystems in question, a fresh 
mkfs and clean sequential transfer of files from the old-fs/backup to the 
new one is pretty well guaranteed to be better optimized than conversion 
from an existing filesystem of a different type, particularly one that 
has been in normal operation for awhile and thus has operational 
fragmentation of both data and free-space.  That's in addition to being 
less bug-prone, even for a "stable" converter.


Restating: So(1) doing a conversion without a backup is irresponsible, 
(2) the easiest backup and conversion method is directly using the old fs 
as the backup, and copying over to the freshly mkfs-ed new filesystem, 
and (3) a freshly mkfs-ed filesystem and sequential copy of files to it 
from backup, whether that be the old filesystem or not, is going to be 
more efficient and less bug-prone than an in-place conversion.

Given the above, why would /anyone/ /sane/ consider using a converter?  
It simply doesn't make sense, even if the converter were as stable as the 
most stable filesystems we have.


So as a distro btrfs package maintainer, do what you wish in terms of the 
converter, but were it me, I might actually consider replacing it with an 
executable that simply printed out some form of the above argument, with 
a pointer to the sources should they still be interested after having 
read that argument.[2] Then, if people really are determined to 
unnecessarily waste their time to get a less efficient filesystem, 
possibly risking their data in the process of getting it, they can always 
build the converter from sources themselves.

---
[1] I debated omitting the qualifier as I know of no exceptions, but I'm 
not a filesystem expert and while I'm a bit skeptical, I suppose it's 
possible that they might exist.

[2] There's actually btrfs precedent for this in the form of the 
executable built as fsck.btrfs, which does nothing (successfully) but 
possibly print a message referring people to btrfs check, if run in 
interactive mode.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
