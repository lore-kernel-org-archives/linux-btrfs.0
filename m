Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw8a-gabriella.wadns.net ([196.220.39.91]:7222 "EHLO
	fw8a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750890AbaCMVMC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Mar 2014 17:12:02 -0400
Message-ID: <53221E7A.8080706@swiftspirit.co.za>
Date: Thu, 13 Mar 2014 23:09:14 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Andrew Skretvedt <andrew.skretvedt@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Incremental backup for a raid1
References: <1564384.fRV1HUkfCq@fuchsia> <20140313192832.GE6151@carfax.org.uk> <53220BA7.1060702@gmail.com>
In-Reply-To: <53220BA7.1060702@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/03/13 09:48 PM, Andrew Skretvedt wrote:
> On 2014-Mar-13 14:28, Hugo Mills wrote:
>> On Thu, Mar 13, 2014 at 08:12:44PM +0100, Michael Schuerig wrote:
>>> I have a btrfs raid1 filesystem spread over two disks. I want to backup
>>> this filesystem regularly and efficiently to an external disk (same
>>> model as the ones in the raid) in such a way that
>>>
>>> * when one disk in the raid fails, I can substitute the backup and
>>> rebalancing from the surviving disk to the substitute only applies the
>>> missing changes.
>>     For point 1, not really. It's a different filesystem
>> [snip]
>>     Hugo.
> I'm new
We all start somewhere. ;)
> Could you, at the time you wanted to backup the filesystem:
> 1) in the filesystem, break RAID1: /dev/A /dev/B <-- remove /dev/B
> 2) reestablish RAID1 to the backup device: /dev/A /dev/C <-- added
Its this step that won't work "as is" and, from an outsider's 
perspective, it is not obvious why:
As Hugo mentioned, "It's a different filesystem". The two disks don't 
have any "co-ordinating" record of data and don't have any record 
indicating that the other disk even exists. The files they store might 
even be identical - but there's a lot of missing information that would 
be necessary to tell them they can work together. All this will do is 
reformat /dev/C and then it will be rewritten again by the balance 
operation in step 3) below.
> 3) balance to effect the backup (i.e. rebuilding the RAID1 onto /dev/C)
> 4) break/reconnect the original devices: remove /dev/C; re-add /dev/B 
> to the fs
Again, as with 2), /dev/A is now synchronised with (for all intents and 
purposes) a new disk. If you want to re-add /dev/B, you're going to lose 
any data on /dev/B (view this in the sense that, if you wiped the disk, 
the end-result would be the same) and then you would be re-balancing new 
data onto it from scratch.

Before removing /dev/B:
Disk A: abdeg__cf__
Disk B: abc_df_ge__ <- note that data is *not* necessarily stored in the 
exact same position on both disks
Disk C: gbfc_d__a_e

All data is available on all disks. Disk C has no record indicating that 
disks A and B exist.
Disk A and B have a record indicating that the other disk is part of the 
same FS. These two disks have no record indicating disk C exists.

1. Remove /dev/B:
Disk A: abdeg__cf__
Disk C: gbfc_d__a_e

2. Add /dev/C to /dev/A as RAID1:
Disk A: abdeg__cf__
Disk C: _########## <- system reformats /dev/C and treats the old data 
as garbage

3. Balance /dev/{A,C}:
Disk A: abdeg__cf__
Disk C: abcdefg____

Both disks now have a full record of where the data is supposed to be 
and have a record indicating that the other disk is part of the FS. 
Notice that, though Disk C has the exact same files as it did before 
step 1, the on-disk filesystem looks very different.

4. Follow steps 1, 2, and 3 above - but with different disks - similar 
end-result.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

