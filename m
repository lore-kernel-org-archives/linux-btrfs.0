Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:33978 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751159AbdECSni (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2017 14:43:38 -0400
Received: by mail-yw0-f196.google.com with SMTP id u70so15321128ywe.1
        for <linux-btrfs@vger.kernel.org>; Wed, 03 May 2017 11:43:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cdf96959-94e8-4932-465f-ea5c72187892@inwind.it>
References: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com>
 <20170502135820.2ft7bsoceeqhnbqf@angband.pl> <CAA91j0V97dCb+j_thg0oi7B4D29VVKcqtRcpCWbgQyzi+FScKA@mail.gmail.com>
 <20170502184923.jdpfx3pwkl5avdph@angband.pl> <c7f3c9fe-2f28-e102-9df7-273dc5a6ca8e@inwind.it>
 <20170502221506.3dfe125e@jupiter.sol.kaishome.de> <cdf96959-94e8-4932-465f-ea5c72187892@inwind.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 3 May 2017 12:43:36 -0600
Message-ID: <CAJCQCtQwCohHJBKihg5fMC2Wc6+jz=Zc-a5MAOBaV4Pt-YzN6w@mail.gmail.com>
Subject: Re: Can I see what device was used to mount btrfs?
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If I understand the bug report correctly, the user specifies mounting
by label which then systemd is converting into /dev/dm-0 (because it's
a two LUKS devices Btrfs volume).

Why not convert the fstab mount by label request, into a /dev/by-uuid/
path; and then systemd calls mount with -u,--uuid mount option rather
than the block device? I'd think this is better no matter what the
file system is, but certainly with Btrfs and possibly ZFS. That makes
the device discovery problem not systemd's problem to hassle with.



Chris Murphy




On Wed, May 3, 2017 at 11:05 AM, Goffredo Baroncelli <kreijack@inwind.it> wrote:
> On 2017-05-02 22:15, Kai Krakow wrote:
>>> For example, it would be possible to implement a sane check that
>>> prevent to mount a btrfs filesystem if two devices exposes the same
>>> UUID...
>> Ideally, the btrfs wouldn't even appear in /dev until it was assembled
>> by udev. But apparently that's not the case, and I think this is where
>> the problems come from. I wish, btrfs would not show up as device nodes
>> in /dev that the mount command identified as btrfs. Instead, btrfs
>> would expose (probably through udev) a device node
>> in /dev/btrfs/fs_identifier when it is ready.
>
>
> And what if udev fails to assemble the devices (for example because not all the disks are available or because there are two disks with the same uuid) ?
> And if the user can't access the disks, how he could solve the issues (i.e. two disk with the same uuid)
>
> I think that udev should be put out of the game of assembling the disks. For the following reasons:
> 1) udev is not developed by the BTRFS community where the btrfs knowledges are; there are a lot of corner cases which are not clear to the btrfs developers; how these case could be more clearer to the udev developers (who indeed are very smart guys) ?
> 2) I don't think that udev is flexible enough to handle all the cases (e.g.: two disks with the same uuid,  missing devices)
> 3) udev works quite well at handling the device appearing; why it should be involved in the filesystem assembling ?
>
>
> BR
> G.Baroncelli
>
>
> --
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Chris Murphy
