Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:32898 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbbGKRwG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jul 2015 13:52:06 -0400
From: Ed Tomlinson <edt@aei.ca>
To: <linux-btrfs@vger.kernel.org>
Subject: What am I doing =?iso-8859-1?Q?wrong=3F?=
Date: Sat, 11 Jul 2015 13:52:03 -0400
MIME-Version: 1.0
Message-ID: <5fb98586-af47-4c5e-803a-5c2d7bebc6bc@aei.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

This process used to work.  I am not sure what is going wrong now and/or 
what requirements have changed.  I'd really appriecate another set of eyes 
looking at this.

The sending volume has:
# btrfs subvol list -pqu /snap 
ID 258 gen 416417 parent 5 top level 5 parent_uuid - uuid 
6447cef2-9b1a-c146-8dc3-b759ed2dd694 path homevol
ID 749 gen 399865 parent 258 top level 258 parent_uuid 
6447cef2-9b1a-c146-8dc3-b759ed2dd694 uuid 
c309c50a-8558-a242-86bd-d64b7f6ca0cd path homevol/backup
ID 750 gen 401012 parent 258 top level 258 parent_uuid 
6447cef2-9b1a-c146-8dc3-b759ed2dd694 uuid 
d29ffd19-8ca1-e248-ace0-fc174902f1f3 path 
homevol/backup.2015-27-6_07-04_22:00

The recieving volume has:
# btrfs subvol list -pquR /backup | grep 
c309c50a-8558-a242-86bd-d64b7f6ca0cd
ID 3698 gen 3116 parent 5 top level 5 parent_uuid - received_uuid 
c309c50a-8558-a242-86bd-d64b7f6ca0cd uuid 
18a46efa-3cc3-4742-925e-ea0681709592 path home/backup

But send/recieve is not working:
#  btrfs send -ve -p homevol/backup homevol/backup.2015-27-6_07-04_22:00 | 
btrfs receive -v /backup/home
At subvol homevol/backup.2015-27-6_07-04_22:00
At snapshot backup.2015-27-6_07-04_22:00
receiving snapshot backup.2015-27-6_07-04_22:00 
uuid=d29ffd19-8ca1-e248-ace0-fc174902f1f3, ctransid=401012 
parent_uuid=cb3ad856-ca0f-f744-b7c3-b33f2d5bc8d3, parent_ctransid=399865
ERROR: could not find parent subvolume

Yet the subvol homevol/backup has been sent (full) to and exists on /backup 
filesystem as can be seen in the two subvol lists, yet send/recieve cannot 
seem to find it for an incremental backup.  

Why?

TIA
Ed Tomlinson
