Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56925 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751864AbaBDAeF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 19:34:05 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Receive on same subvolume
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52F01DE1.7030102@matthewlai.ca>
Date: Mon, 3 Feb 2014 17:34:02 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <1696955D-7E67-4976-9933-43210C892262@colorremedies.com>
References: <52E9721D.6000908@matthewlai.ca> <4D0416BE-42D6-4458-9519-9836CC979005@colorremedies.com> <52EFDDA6.2060907@matthewlai.ca> <8BD36B4A-F9AF-40C6-81B8-85FD14CD5EA1@colorremedies.com> <52F01DE1.7030102@matthewlai.ca>
To: Matthew Lai <m@matthewlai.ca>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 3, 2014, at 3:53 PM, Matthew Lai <m@matthewlai.ca> wrote:

> On 03/02/2014 11:26 AM, Chris Murphy wrote:
>> On Feb 3, 2014, at 11:19 AM, Matthew Lai <m@matthewlai.ca> wrote:
>> 
>>> Thanks. I should clarify what I'm trying to do.
>>> 
>>> I'm trying to use btrfs send for backup, without having another btrfs volume.
>>> 
>>> So the initial backup is a complete send, piped to Amazon Glacier (so my machine never has the whole file, and doesn't have space for one).
>> OK so you've use btrfs send piped to Glacier which creates a *file*, I'll call it "initial", not a navigable directory of files? Right?
> That is correct.
>>> It looks like the problem now is the sent file can't be applied to the original volume (for restore).
>> I'm counting two sent files: initial, increment1. I'm not sure which one you're applying. If you have the exact same read-only snapshot that the btrfs send file "initial" is based on, then you'd apply the increment1 to that read-only snapshot which will cause a new read-only snapshot to be created with the incremental data applied to it. The error you're getting sounds like the parent read-only snapshot isn't available?
>> 
> That is also correct. There are 2 sent files. I am trying to apply increment1, on a snapshot of the parent (that was used to create increment1).

I don't understand how you can apply increment1 to the snapshot of increment1; and also I don't understand how the parent is also increment1.




> 
> I added -vv. Here is the test script for reproducing this entire setup.
> 
> -----------------------------------------------------------------------
> #!/bin/sh
> 
> btrfs subvolume create data
> btrfs subvolume snapshot -r data first_backup
> touch data/a
> btrfs subvolume snapshot -r data second_backup
> btrfs send -p first_backup second_backup > increment
> btrfs subvolume snapshot first_backup first_backup_rw
> btrfs receive -vv first_backup_rw < increment
> -----------------------------------------------------------------------
> 
> Output:
> -----------------------------------------------------------------------
> Create subvolume './data'
> Create a readonly snapshot of 'data' in './first_backup'
> Create a readonly snapshot of 'data' in './second_backup'
> At subvol second_backup
> Create a snapshot of 'first_backup' in './first_backup_rw'
> At snapshot second_backup
> receiving snapshot second_backup uuid=e6159a2a-3430-344a-a23d-b9bb83851a63, ctransid=28 parent_uuid=20c4ff66-a9ec-fc44-93c6-2c12637e95e6, parent_ctransid=26
> ERROR: could not find parent subvolume
> -----------------------------------------------------------------------
> 
> I would think applying the "patch" to first_backup_rw should succeed, because it's exactly the same as first_backup, which is the parent for the send, but it doesn't.

btrfs sub snap -r subvol.1 subvol
btrfs send subvol.1 -f <toglacier>/subvol.1.btrfs
#write some more files to subvol
btrfs sub snap -r subvol.2 subvol
btrfs send -p subvol.1 subvol.2 -f <toglacier>/subvol.2.btrfs

#To make subvol.1 into subvol.2 by applying subvol.2.btrfs to subvol.1, the actual original subvol.1 must be present first or you need to "receive" it from subvol.1.btrfs first. And also, I'm pretty sure you can't have subvol.2 already present because receive must create it.

Again, I haven't tried > and < so I don't know they work. Have you tried -f to point to the files?



Chris Murphy

