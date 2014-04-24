Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:38515 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751138AbaDXTiB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 15:38:01 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:51202 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WdPT6-001oc0-7u
	for linux-btrfs@vger.kernel.org; Thu, 24 Apr 2014 13:38:00 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Cycle of send/receive for backup/restore is incomplete...
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <5358B877.4040204@pobox.com>
Date: Thu, 24 Apr 2014 13:37:58 -0600
Message-Id: <9ED78F1C-4DA4-48EE-A9B2-B3CF67536F34@colorremedies.com>
References: <53583F1E.7050603@pobox.com> <535892EE.6040301@swiftspirit.co.za> <5358B877.4040204@pobox.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 24, 2014, at 1:08 AM, Robert White <rwhite@pobox.com> wrote:


> So the systems are "the same" but they aren't really the same according to this clearly visible symptom.

I don't think of btrfs send/receive as sending/receiving whole subvolumes, but rather just their contents.

Try btrfs sub show <subvol> on the original rw subvolume, its ro snapshot, and the sent/received ro snapshot on the target drive. It looks like this:

Drive [a]

[a]# btrfs sub show pictures
/mnt/a/pictures
	Name: 			pictures
	uuid: 			f15ebd77-1151-1740-a7fb-7fd82a0de4aa
	Parent uuid: 		-
	Creation time: 		2014-04-24 08:39:53
	Object ID: 		257
	Generation (Gen): 	11
	Gen at creation: 	7
	
[a]# btrfs sub show pictures_1ro
/mnt/a/pictures_1ro
	Name: 			pictures_1ro
	uuid: 			7bfc06b2-dcc1-0346-a36f-a6305d45934b
	Parent uuid: 		f15ebd77-1151-1740-a7fb-7fd82a0de4aa
	Creation time: 		2014-04-24 08:45:58
	Object ID: 		260
	Generation (Gen): 	11
	Gen at creation: 	11
	
	
	[send from drive a to drive b]
	
[b]# btrfs sub show pictures_1ro/
/mnt/b/pictures_1ro
	Name: 			pictures_1ro
	uuid: 			a814808d-18f7-924b-ba11-68bd3e032bf6
	Parent uuid: 		-
	Creation time: 		2014-04-24 08:46:54
	Object ID: 		257
	Generation (Gen): 	8
	Gen at creation: 	7


Nothing except the name is the same between them. The subvolumes uuids, object ids, generation number, are all different.



> 
> It's _impossible_ to strip Base of it's subvolume status on /driveb. If you delete the Base_BACKUP element so that Base is the only thing on the drive, it's still a shapshot according to -s. What does this status even mean if it's as meaningless as it seems.
> 
> That seems like a second surprise.

I don't know what the first sentence means. A subvolume isn't a state, it's an object, and so it either exists or not. It isn't a flag that can be set and unset.

The snapshot state and parent uuid isn't exactly fool proof, it's easily spoofed. So I take it to mean "how it was created" - subvolume create vs subvolume snapshot. There is no actual difference between a subvolume and a snapshot.

For example. Subvolume A with some files in it. I subvolume create B, and I --reflink files from A to B. I've just functionally made B a snapshot of A, yet its metadata doesn't indicate this. It's a subvolume that doesn't proclaim being a snapshot, nor does it have a parent uuid.

Conversely, if I subvolume snapshot A C, and then rm -rf C/* and fill it with some new files, I have a subvolume claiming to be a snapshot with a parent uuid, but it has nothing at all in common with that parent.

So the snapshot flag and parent uuid are conveniences, they indicate a truth at the time of creation. It's not a dynamic status.


> 
> ---
> 
> Is this a common case? It could easily be if you use NAS or movable USB to do your backups and restore-or-media-migration operations.
> 
> Are we sure it doesn't matter? I find it problematic but fixable in concept. I've got no information whether the internal parentage relationship could be reversed so that the before and after of the subvolume list -s result are the same.
> 
> No I'm not looking for byte-level identical status, I know that's ridiculous.
> 
> I want semantically identical status.

I don't see how that's presently possible since subvolumes themselves aren't being sent. Instead their contents are, with an efficient incremental/clone stream feature. We can't use send on a rw subvolume, so from the outset we have a semantic disconnect between source and destination.

I really think what you're after is seed device. Or possibly some hybrid between seed and send.

> 

> ====
> 
> Why it matters...
> 
> If I am doing monthly and weekly archiving I don't want to interrupt the rolling archive(s) if I end up having to do a restore. I don't want to create a catastrophe point or an interrupting epoch in the archive history.
> 
> It sounds like it doesn't matter once you know not to use the -s status for anything…

I'd say it's not a status because the word status implies present state and thus is a dynamic indicator. Instead, -s indicates how the subvolume was created: empty or prefilled. And it's really mostly useful for ro snapshots because we're assured they haven't changed since they were created.



Chris Murphy

