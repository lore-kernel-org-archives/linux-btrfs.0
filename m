Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18-i6.italiaonline.it ([213.209.14.18]:58713 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725975AbeGRGgG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 02:36:06 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 0/4] 3- and 4- copy RAID1
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <cover.1531503452.git.dsterba@suse.com>
 <9945d460-99b5-a927-a614-c797bbc7862d@dirtcellar.net>
 <d340ce28-6c93-22d4-0f56-73de8e55f1f6@libero.it>
 <pan$b5258$f3ecc84$8e06948b$54511335@cox.net>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <793d8ec3-7934-ea60-521d-7a039c9f1ce9@libero.it>
Date: Wed, 18 Jul 2018 07:59:52 +0200
MIME-Version: 1.0
In-Reply-To: <pan$b5258$f3ecc84$8e06948b$54511335@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/17/2018 11:12 PM, Duncan wrote:
> Goffredo Baroncelli posted on Mon, 16 Jul 2018 20:29:46 +0200 as
> excerpted:
> 
>> On 07/15/2018 04:37 PM, waxhead wrote:
> 
>> Striping and mirroring/pairing are orthogonal properties; mirror and
>> parity are mutually exclusive.
> 
> I can't agree.  I don't know whether you meant that in the global sense, 
> or purely in the btrfs context (which I suspect), but either way I can't 
> agree.
> 
> In the pure btrfs context, while striping and mirroring/pairing are 
> orthogonal today, Hugo's whole point was that btrfs is theoretically 
> flexible enough to allow both together and the feature may at some point 
> be added, so it makes sense to have a layout notation format flexible 
> enough to allow it as well.

When I say orthogonal, It means that these can be combined: i.e. you can have
- striping (RAID0)
- parity  (?)
- striping + parity  (e.g. RAID5/6)
- mirroring  (RAID1)
- mirroring + striping  (RAID10)

However you can't have mirroring+parity; this means that a notation where both 'C' ( = number of copy) and 'P' ( = number of parities) is too verbose.

[...]
> 
>> Question #2: historically RAID10 is requires 4 disks. However I am
>> guessing if the stripe could be done on a different number of disks:
>> What about RAID1+Striping on 3 (or 5 disks) ? The key of striping is
>> that every 64k, the data are stored on a different disk....
> 
> As someone else pointed out, md/lvm-raid10 already work like this.  What 
> btrfs calls raid10 is somewhat different, but btrfs raid1 pretty much 
> works this way except with huge (gig size) chunks.

As implemented in BTRFS, raid1 doesn't have striping.

 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
