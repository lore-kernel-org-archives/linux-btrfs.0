Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:59121 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2HNN3H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 09:29:07 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail1.trendhosting.net (Postfix) with ESMTP id 7EDE2150C8
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 15:19:05 +0100 (BST)
Received: from mail1.trendhosting.net ([127.0.0.1])
	by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 8DMn4l4Bx5n8 for <linux-btrfs@vger.kernel.org>;
	Tue, 14 Aug 2012 15:18:59 +0100 (BST)
Message-ID: <502A529B.8060201@pocock.com.au>
Date: Tue, 14 Aug 2012 13:28:59 +0000
From: Daniel Pocock <daniel@pocock.com.au>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: raw partition or LV for btrfs?
References: <5027DDFC.60504@pocock.com.au> <CAG1y0scy=6NByQ9DBF_9m6MrmNrYe1WvX9-JkmbEUKWjd77w8Q@mail.gmail.com>
In-Reply-To: <CAG1y0scy=6NByQ9DBF_9m6MrmNrYe1WvX9-JkmbEUKWjd77w8Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/08/12 22:48, Fajar A. Nugraha wrote:
> On Sun, Aug 12, 2012 at 11:46 PM, Daniel Pocock <daniel@pocock.com.au> wrote:
>>
>>
>> I notice this question on the wiki/faq:
>>
>>
>> https://btrfs.wiki.kernel.org/index.php/UseCases#What_is_best_practice_when_partitioning_a_device_that_holds_one_or_more_btr-filesystems
>>
>> and as it hasn't been answered, can anyone make any comments on the subject
>>
>> Various things come to mind:
>>
>> a) partition the disk, create an LVM partition, and create lots of small
>> LVs, format each as btrfs
>>
>> b) partition the disk, create an LVM partition, and create one big LV,
>> format as btrfs, make subvolumes
>>
>> c) what about using btrfs RAID1?  Does either approach (a) or (b) seem
>> better for someone who wants the RAID1 feature?
> 
> IMHO when the qgroup feature is "stable" (i.e. adopted by distros, or
> at least in stable kernel) then simply creating one big partition (and
> letting btrfs handle RAID1, if you use it) is better. When 3.6 is out,
> perhaps?
> 
> Until then I'd use LVM.
> 

Can you just elaborate on the qgroups feature?
- Does this just mean I can make the subvolume sizes rigid, like LV sizes?
- Or is it per-user restrictions or some other more elaborate solution?

If I create 10 LVs today, with btrfs on each, can I merge them all into
subvolumes on a single btrfs later?

If I just create a 1TB btrfs with subvolumes now, can I upgrade to
qgroups later?  Or would I have to recreate the filesystem?

I really appreciate the answers from people.  Reflecting on some of the
comments and past experience, my feeling is that I should do the following:

a) create the partition table as normal
b) create one big partition as LVM (type 0x8e)
c) create one big LV (for all of the disk)
d) format the LV as btrfs
e) create a subvolume to hold the data from each LV that I have on my
old disk

My reason for doing (b) and (c) is that I may want to have the following
options in future - would these still be possible without LVM at all,
using btrfs on a raw 1TB partition?
- using pvmove to move the filesystem to another physical device (e.g.
if I purchase a 2TB drive to replace the 1TB drive)
- using lvresize to expand the allocation onto such a new drive

If I understand correctly, if I don't use LVM, then such move and resize
operations can't be done for an online filesystem and it has more risk.


