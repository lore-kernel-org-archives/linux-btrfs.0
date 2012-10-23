Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46390 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740Ab2JWSKW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Oct 2012 14:10:22 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so1730437bkc.19
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Oct 2012 11:10:21 -0700 (PDT)
Message-ID: <5086DDAE.3050708@gmail.com>
Date: Tue, 23 Oct 2012 20:10:54 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBLasO2cmxpbmc=?= <michael@kjorling.se>
CC: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        Chris Murphy <lists@colorremedies.com>
Subject: Re: device delete, error removing device
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com> <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com> <20121022091904.GY25498@carfax.org.uk> <B2B2C037-F5C8-4A75-A0D8-6C0AACDFAF4E@colorremedies.com> <20121022171809.GA25498@carfax.org.uk> <20121023075721.GB391@yeono.kjorling.se>
In-Reply-To: <20121023075721.GB391@yeono.kjorling.se>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012-10-23 09:57, Michael Kjörling wrote:
> On 22 Oct 2012 18:18 +0100, from hugo@carfax.org.uk (Hugo Mills):
>>> [root@f18v ~]# btrfs device delete /dev/sdb /mnt [root@f18v ~]#
>>> btrfs fi show failed to read /dev/sr0 Label: none  uuid:
>>> 6e96a96e-3357-4f23-b064-0f0713366d45 Total devices 5 FS bytes
>>> used 7.52GB devid    5 size 12.00GB used 4.17GB path /dev/sdf 
>>> devid    4 size 12.00GB used 4.62GB path /dev/sde devid    3
>>> size 3.00GB used 2.68GB path /dev/sdd devid    2 size 3.00GB
>>> used 2.68GB path /dev/sdc *** Some devices missing
>>> 
>>> However, I think that last line is a bug. When I
>>> 
>>> [root@f18v ~]# btrfs device delete missing /mnt
>>> 
>>> I get
>>> 
>>> [ 2152.257163] btrfs: no missing devices found to remove
>>> 
>>> So they're missing but not missing?
>> 
>> If you run sync, or wait for 30 seconds, you'll find that fi
>> show shows the correct information again -- btrfs fi show reads
>> the superblocks directly, and if you run it immediately after the
>> dev del, they've not been flushed back to disk yet.
> 
> That sounds like it has the potential to bite a lot of people in
> the rear. Yes, 30 seconds or a sync is trivial, but only if you
> know about it.

IIRC Chris [Mason] told that when a disk is removed, the super-block
(signature) is zeroed and a sync is issued. Looking at the code,
confirm it:

form fs/btrfs/volume.c:

int btrfs_rm_device(struct btrfs_root *root, char *device_path)
{
[...]
        /*
         * at this point, the device is zero sized.  We want to
         * remove it from the devices list and zero out the old super
         */
        if (clear_super) {
                /* make sure this device isn't detected as part of
                 * the FS anymore
                 */
             memset(&disk_super->magic, 0, sizeof(disk_super->magic));
             set_buffer_dirty(bh);
             sync_dirty_buffer(bh);
        }
[...]

I think that what Chris [Murphy] was reported is a bug of the btrfs
user space program (which is corrected in the latest git).
Unfortunately we don't know which version Chris is using so we cannot
reach a conclusion (if the bug was corrected, or it is a new bug).

BR
G.Baroncelli
> 
> Considering that a device delete is a pretty rare but potentially 
> important operation, would it not be better for a sync to be done 
> automatically after a "device delete" command? And potentially
> others in a similar vein. With an option --no-sync or similar to
> disable the behavior (in the relatively unlikely situation that
> multiple devices are unavailable and need to be deleted, for
> example).
> 
> I can definitely see the described behavior qualifying as a "WTF?" 
> moment.
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
