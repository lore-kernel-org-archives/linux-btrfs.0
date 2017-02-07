Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:37626 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752057AbdBGUF0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 15:05:26 -0500
Received: by mail-it0-f45.google.com with SMTP id r185so87980684ita.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 12:05:26 -0800 (PST)
Subject: Re: Very slow balance / btrfs-transaction
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <fce777cb-027f-532b-76ab-24a1e5c2cf7c@suse.de>
 <507c32d4-929c-b691-6196-103c8cb9addb@suse.com>
 <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf>
 <8999d95dac21ea8e2908c5012e50c59b@88cbed2449cf>
 <1f5f66cfa8eca19b7e612e3b4745d788@85337f6d4fa4>
 <20170204221051.664ada65@jupiter.sol.kaishome.de>
 <403247fe-376f-27d7-bbd5-d8acd260a8ad@gmail.com>
 <20170207204727.1bcd9b45@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <323c7434-c89a-b795-0022-b4fc87992c35@gmail.com>
Date: Tue, 7 Feb 2017 14:58:35 -0500
MIME-Version: 1.0
In-Reply-To: <20170207204727.1bcd9b45@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-07 14:47, Kai Krakow wrote:
> Am Mon, 6 Feb 2017 08:19:37 -0500
> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
>
>>> MDRAID uses stripe selection based on latency and other measurements
>>> (like head position). It would be nice if btrfs implemented similar
>>> functionality. This would also be helpful for selecting a disk if
>>> there're more disks than stripesets (for example, I have 3 disks in
>>> my btrfs array). This could write new blocks to the most idle disk
>>> always. I think this wasn't covered by the above mentioned patch.
>>> Currently, selection is based only on the disk with most free
>>> space.
>> You're confusing read selection and write selection.  MDADM and
>> DM-RAID both use a load-balancing read selection algorithm that takes
>> latency and other factors into account.  However, they use a
>> round-robin write selection algorithm that only cares about the
>> position of the block in the virtual device modulo the number of
>> physical devices.
>
> Thanks for clearing that point.
>
>> As an example, say you have a 3 disk RAID10 array set up using MDADM
>> (this is functionally the same as a 3-disk raid1 mode BTRFS
>> filesystem). Every third block starting from block 0 will be on disks
>> 1 and 2, every third block starting from block 1 will be on disks 3
>> and 1, and every third block starting from block 2 will be on disks 2
>> and 3.  No latency measurements are taken, literally nothing is
>> factored in except the block's position in the virtual device.
>
> I didn't know MDADM can use RAID10 on odd amounts of disks...
> Nice. I'll keep that in mind. :-)
It's one of those neat features that I stumbled across by accident a 
while back that not many people know about.  It's kind of ironic when 
you think about it too, since the MD RAID10 profile with only 2 replicas 
is actually a more accurate comparison for the BTRFS raid1 profile than 
the MD RAID1 profile.  FWIW, it can (somewhat paradoxically) sometimes 
get better read and write performance than MD RAID0 across the same 
number of disks.

