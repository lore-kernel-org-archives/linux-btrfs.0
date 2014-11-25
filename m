Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-i2.italiaonline.it ([212.48.25.204]:59321 "EHLO
	smtp-33.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751072AbaKYV75 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 16:59:57 -0500
Message-ID: <5474FBD9.5070709@inwind.it>
Date: Tue, 25 Nov 2014 22:59:53 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Zygo Blaxell <zblaxell@furryterror.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS messes up snapshot LV with origin
References: <27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com> <546B68F8.6080008@ubuntu.com> <FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com> <546BA96D.4050805@ubuntu.com> <2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com> <546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org> <5470C92E.1070607@inwind.it> <20141123001927.GO17380@hungrycats.org> <5474AF87.6090702@inwind.it> <20141125202948.GP17380@hungrycats.org>
In-Reply-To: <20141125202948.GP17380@hungrycats.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/25/2014 09:29 PM, Zygo Blaxell wrote:
> On Tue, Nov 25, 2014 at 05:34:15PM +0100, Goffredo Baroncelli wrote:
>> On 11/23/2014 01:19 AM, Zygo Blaxell wrote:
>> [...]
>>> md-raid works as long as you specify the devices, and because it's always
>>> the lowest layer it can ignore LVs (snapshot or otherwise).  It's also
>>> not a particularly common use case, while making an LV snapshot of a
>>> filesystem is a typical use case.
>>
>> I fully agree; but you still consider a *multi-device* btrfs over lvm...
>> This is like a dm over lvm... which doesn't make sense at all (as you 
>> already wrote)
> 
> It makes sense for btrfs because btrfs can productively use LVs on
> different PVs (e.g. btrfs-raid1 on two LVs, one on each PV).  LVM is
> the bottom layer because not everything in the world is btrfs--things
> like ephemeral /tmp, boot, swap, and temporary backup copies of the btrfs
> (e.g.  before running btrfsck) have to live on the same physical drives
> as the btrfs filesystems.

Let me to summrize

1) btrfs-single-disk on lvm works fine
2) btrfs-w/multiple-disk on lvm works fine
3) btrfs-single-disk on lvm works fine even with snapshot

4) btrfs-w/multiple-disk doesn't work with lvm AND snapshot

However I still doesn't understood why you want btrfs-w/multiple disk over LVM ?



> 
>>>>> and mounting the filesystem fails at 3.  
>>>> Are you sure ?
>>>
>>> Yes, I'm sure.  I've had to replace filesystems destroyed this way.

In a previous email you wrote:
>> Multi-device btrfs fails at 2, 
So I assumed that the point 3 onwards were related to a "single-disk" btrfs.



[...]


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
