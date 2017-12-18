Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44654 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757897AbdLRIyN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 03:54:13 -0500
Subject: Re: Unexpected raid1 behaviour
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <5A357909.8010206@yandex.ru>
 <pan$36ed4$200dd538$4324239e$ed0f9f4@cox.net>
 <23094.37316.66397.431081@tree.ty.sabi.co.uk>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <be7e5573-4247-89bd-00f0-7d84120ce582@oracle.com>
Date: Mon, 18 Dec 2017 16:49:51 +0800
MIME-Version: 1.0
In-Reply-To: <23094.37316.66397.431081@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> Put another way, the multi-device design is/was based on the
> demented idea that block-devices that are missing are/should be
> "remove"d, so that a 2-device volume with a 'raid1' profile
> becomes a 1-device volume with a 'single'/'dup' profile, and not
> a 2-device volume with a missing block-device and an incomplete
> 'raid1' profile, 

  Agreed. IMO degraded-raid1-single-chunk is an accidental feature
  caused by [1], which we should revert back, since..
    - balance (to raid1 chunk) may fail if FS is near full
    - recovery (to raid1 chunk) will take more writes as compared
      to recovery under degraded raid1 chunks

  [1]
  commit 95669976bd7d30ae265db938ecb46a6b7f8cb893
  Btrfs: don't consider the missing device when allocating new chunks

  There is an attempt to fix it [2], but will certainly takes time as
  there are many things to fix around this.

  [2]
  [PATCH RFC] btrfs: create degraded-RAID1 chunks

 > even if things have been awkwardly moving in
 > that direction in recent years.
> Note the above is not totally accurate today because various
> hacks have been introduced to work around the various issues.
  May be you are talking about [3]. Pls note its a workaround
  patch (which I mentioned in its original patch). Its nice that
  we fixed the availability issue through this patch and the
  helper function it added also helps the other developments.
  But for long term we need to work on [2].

  [3]
  btrfs: Introduce a function to check if all chunks a OK for degraded 
rw mount

>> Thus, if a device disappears, to get it back you really have
>> to reboot, or at least unload/reload the btrfs kernel module,
>> in ordered to clear the stale device state and have btrfs
>> rescan and reassociate devices with the matching filesystems.
> 
> IIRC that is not quite accurate: a "missing" device can be
> nowadays "replace"d (by "devid") or "remove"d, the latter
> possibly implying profile changes:
 >
>    https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Using_add_and_delete
> 
> Terrible tricks like this also work:
> 
>    https://www.spinics.net/lists/linux-btrfs/msg48394.html

  Its replace, which isn't about bringing back a missing disk.


>> Meanwhile, as mentioned above, there's active work on proper
>> dynamic btrfs device tracking and management. It may or may
>> not be ready for 4.16, but once it goes in, btrfs should
>> properly detect a device going away and react accordingly,
> 
> I haven't seen that, but I doubt that it is the radical redesign
> of the multi-device layer of Btrfs that is needed to give it
> operational semantics similar to those of MD RAID, and that I
> have vaguely described previously.

  I agree that btrfs volume manager is incomplete in view of
  data center RAS requisites, there are couple of critical
  bugs and inconsistent design between raid profiles, but I
  doubt if it needs a radical redesign.

  Pls take a look at [4], comments are appreciated as usual.
  I have experimented with two approaches and both are reasonable. -
  There isn't any harm to leave failed disk opened (but stop any
  new IO to it). And there will be udev
  'btrfs dev forget --mounted <dev>' call when device disappears
  so that we can close the device.
  In the 2nd approach, close the failed device right away when disk
  write fails, so that we continue to have only two device states.
  I like the latter.

>> and it should detect a device coming back as a different
>> device too.
> 
> That is disagreeable because of poor terminology: I guess that
> what was intended that it should be able to detect a previous
> member block-device becoming available again as a different
> device inode, which currently is very dangerous in some vital
> situations.

  If device disappears, the patch [4] will completely take out the
  device from btrfs, and continues to RW in degraded mode.
  When it reappears then [5] will bring it back to the RW list.

   [4]
   btrfs: introduce device dynamic state transition to failed
   [5]
   btrfs: handle dynamically reappearing missing device

  From the btrfs original design, it always depends on device SB
  fsid:uuid:devid so it does not matter about the device
  path or device inode or device transport layer. For eg. Dynamically
  you can bring a device under different transport and it will work
  without any down time.


 > That would be trivial if the complete redesign of block-device
 > states of the Btrfs multi-device layer happened, adding an
 > "active" flag to an "accessible" flag to describe new member
 > states, for example.

  I think you are talking about BTRFS_DEV_STATE.. But I think
  Duncan is talking about the patches which I included in my
  reply.

Thanks, Anand

