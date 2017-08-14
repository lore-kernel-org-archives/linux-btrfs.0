Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:52199 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752318AbdHNM6M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 08:58:12 -0400
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
 <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net> <20170812074248.GA3352@infradead.org>
 <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <MEXPR01MB2168FD458234B54167D9674F9E8C0@MEXPR01MB2168.ausprd01.prod.outlook.com>
 <d06d02ec-93b7-078b-55f5-4cc94787a480@gmx.com>
 <1502713969.3608.3.camel@scientia.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <d58da378-f558-5ff9-21d5-354bdf6a7283@gmx.com>
Date: Mon, 14 Aug 2017 20:58:05 +0800
MIME-Version: 1.0
In-Reply-To: <1502713969.3608.3.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月14日 20:32, Christoph Anton Mitterer wrote:
> On Mon, 2017-08-14 at 15:46 +0800, Qu Wenruo wrote:
>> The problem here is, if you enable csum and even data is updated
>> correctly, only metadata is trashed, then you can't even read out
>> the
>> correct data.
> 
> So what?
> This problem occurs anyway *only* in case of a crash,.. and *only* if
> notdatacow+checksumung would be used.
> A case in which currently, the user can either only hope that his data
> is fine (unless higher levels provide some checksumming means[0]), or
> anyway needs to recover from a backup.

Let's make it clear of the combinations and its result in power loss case:

Datacow + Datasum: Good old data

Datacow + nodatasum: Good old data

Nodatacow + datacum: Good old data (data not committed yet) or -EIO 
(data updated)
Not supported yet, so I just assume it's using current csum checking 
behavior.

Nodatacow + nodatasum: Good old data (data not committed yet) or 
uncertain data.

The uncertain part is when data updated, what it should behave.

If we really need to implement nodatacow +datasum, I prefer to make it 
consistent with nodatacow + nodatasum behavior, at least read out the 
data, give some csum warning instead of refuse to read and returning -EIO.

> 
> Intuitively I'd also say it's much less likely that the data (which is
> more in terms of space) is written correctly while the checksum is not.
> Or is it?

Checksums are protected by mandatory metadata CoW, so metadata update is 
always atomic.
Checksum will either be updated correctly, or trashed at all. Unlike data.

And it's highly possible to happen. As when synchronising a filesystem, 
we write data first, then metadata (data and meta may be cached by disk 
controller, but at least we submit such request to disk), then flush all 
data and metadata to disk, and update superblock finally.

Since metadata is updated CoW, unless the superblock is written to disk, 
we are always reading the old metadata trees (including csum tree).

So if powerloss happens between data written to disk and final 
superblock update, it's highly possible to hit the problem.
And considering the data/metadata ratio, we spend more time flushing 
data other than metadata, which increase the possibility further more.

> 
> [0] And when I've investigated back when discussion rose up the first
> time and some list member claimed that most typical cases (DBs, VM
> images) would anyway do their own checksuming,... I came to the
> conclusion that most did not even support it and even if they would
> it's no enabled per default and not really a *full* checksumming in
> most cases.
> 
> 
> 
>> As btrfs csum checker will just prevent you from reading out any
>> data
>> which doesn't match with csum.
> As I've said before, a tool could be provided, that re-computes the
> checksums then (making the data accessible again)... or one could
> simply mount the fs with nochecksum or some other special option, which
> allows bypassing any checks.

Just as you pointed out, such csum bypassing should be the prerequisite 
for nodatacow+datasum.
And unfortunately, we don't have such facility yet.

> 
>> Now it's not just data corruption, but data loss then.
> I think the former is worse than the later. The later gives you a
> chance of noting it, and either recover from a backup, regenerate the
> data (if possible) or manually mark the data as being "good" (though
> corrupted) again.

This depends.
If the upper layer has its own error detection mechanism, like keeping a 
special file fsynced before write (or just call it journal), then 
allowing reading out the corrupted data gives it a chance to find it 
good and continue.
While just returning -EIO kills the chance at all.

BTW, normal user space programs can handle csum mismatch better than -EIO.
Like zip files has its own checksum, btw can't handle -EIO at all.

Thanks,
Qu

> 
> 
> Cheers,
> Chris.
> 
