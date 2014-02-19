Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47278 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754034AbaBSR0F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Feb 2014 12:26:05 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Incremental backup over writable snapshot
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <2285169.jbztTl7OC0@linuxpc>
Date: Wed, 19 Feb 2014 10:26:02 -0700
Message-Id: <880EBF41-577C-4791-B022-DECE2960748F@colorremedies.com>
References: <17860756.QfG9CfNMqv@linuxpc> <EEA604EA-983B-4F5F-88B5-4FD229FEC61F@colorremedies.com> <2285169.jbztTl7OC0@linuxpc>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, GEO <1g2e3o4@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 19, 2014, at 10:07 AM, GEO <1g2e3o4@gmail.com> wrote:

> On Wednesday 19 February 2014 10:00:49 you wrote:
>> Why? It addresses your use case.
>> 
>> Chris Murphy
> 
> First of all: I am mainly looking for a way to exclude almost all hidden 
> directories. I do not want to manage all those subvolumes.

What's there to manage?


> If I would like to 
> make a system backup, all those subvolumes would not be included etc. 
> Somehow it seems inelegant to me: What would the purpose of simply directories 
> still be? That way everything could be a subvolume to allow selective backup. 
> I do not like the idea of changing so many things on the file system just 
> because of a backup. 

If you subvolume everything you don't want to backup, when you take a snapshot of the parent subvolume, none of the child subvolumes are included in the snapshot. So you end up with a snapshot that contains exactly what you want to backup. So create a read-only snapshot, back it up, delete the snapshot (if you want), done.

> If my approach is also effective I would very much prefer that. 

Snapshotting, deleting a bunch of directories in that snapshot, then backing up the snapshot, then deleting the snapshot will work. But it sounds more involved. But if you're scripting it, probably doesn't matter either way.


Chris Murphy