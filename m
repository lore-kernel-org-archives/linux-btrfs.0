Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39489 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651AbaBSUaR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 15:30:17 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WGDmY-0001Ai-Of
	for linux-btrfs@vger.kernel.org; Wed, 19 Feb 2014 21:30:14 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Feb 2014 21:30:14 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Feb 2014 21:30:14 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Incremental backup over writable snapshot
Date: Wed, 19 Feb 2014 21:20:23 +0100
Message-ID: <99gfta-695.ln1@hurikhan77.spdns.de>
References: <17860756.QfG9CfNMqv@linuxpc> <2285169.jbztTl7OC0@linuxpc> <880EBF41-577C-4791-B022-DECE2960748F@colorremedies.com> <16991840.tqyQc6bZHr@linuxpc> <1985F36E-E720-415C-8BCD-9D7D2847C5DF@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists@colorremedies.com> schrieb:

>>> Snapshotting, deleting a bunch of directories in that snapshot, then
>>> backing up the snapshot, then deleting the snapshot will work. But it
>>> sounds more involved. But if you're scripting it, probably doesn't
>>> matter either way.
>> 
>> Will it work as good?
>> I am scripting things, so it does not matter. If it makes no difference
>> in the end result it should be just a matter of taste.
>> The question for me is whether both lead to the same result. If I did not
>> understand things the wrong way they should, shouldn't they?
> 
> Please also reply to the list directly.
> 
> It sounds like it's the same outcome but actually I don't know that
> send/receive will see it that way. It's necessary for the receive
> destination to be identical to the source parent, or the increment will
> not work. And I don't know that the way you're doing this means the source
> and destination are really identical even though you're deleting the same
> folders every time. So you'll just have to test it and see if it works. I
> wouldn't rely on this as a sole backup strategy.

I don't understand anyway why one wouldn't want to backup the dotfile-
directories... It contains important configuration stuff or even very 
valuable user data like mail storages. Most of these directories aren't 
changing anyways most of the time and thus won't occupy disk space only once 
in the backup.

In a restore scenario it is as simple as copying this stuff back and your 
complete profile with all configuration is restored - no more hassle. You 
could delete stuff you don't want at this stage then.

The only directory in question would be ".cache" - and that's simple to 
create a subvolume from. And even then, some software may rely on their 
cache contents still existing or having a specific state in time (imagine 
you restore an older copy and leave a current .cache in place) - I'd prefer 
to simply keep them. It may be a better approach to maybe "find .cache -
ctime +90 -delete" (or more exactly specific subdirectories there known to 
grow unconditionally). For me, even that's not worth the hassle. It's better 
to have and don't need something.

I suggest not to try to micro-optimize backups and instead grow your backup 
storage if space is such a problem. Storage is inexpensive these days.

Incomplete backups are by my experience no good backups. In case of disaster 
you almost certainly will learn the hard way that you should not have 
excluded that or the other directory from the backup.

I only exclude files from backup that are known to change often and as a 
whole file and are easily recoverable from internet. That often hardly 
applies to any directory you have. Another candidate are vm images which 
often require different backup strategies. In the end, such examples are so 
rare that it is more easy to create subvolumes for a few special directories 
so they become excluded, then set a specialized backup strategy for some of 
these subvolumes. The only "management" requirement of this is keeping track 
which subvolumes need this extra treatment for different backup strategies. 
You don't need to manage mount points or anything else. Duncan had a nice 
example in this list how to migrate directories to subvolumes by using 
shallow copies: "mv dir dir.old && btrfs sub create dir && cp -a --
reflink=always dir.old/. dir/. && rm -Rf dir.old".

As a general rule of thumb: Follow the KISS principle for your backup, or 
live with a lot of headaches - at least for the case of recovery. Deleting 
stuff from a backup snapshot before sending it sounds silly, insane, and 
error-prone to me (please do not take that personally, it's not meant that 
way).

-- 
Replies to list only preferred.

