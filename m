Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:50821 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751287AbdECRFh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 May 2017 13:05:37 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Can I see what device was used to mount btrfs?
References: <1e2e2e5c-5ee8-85c1-1db4-74293d8c9c1e@gmail.com>
 <20170502135820.2ft7bsoceeqhnbqf@angband.pl>
 <CAA91j0V97dCb+j_thg0oi7B4D29VVKcqtRcpCWbgQyzi+FScKA@mail.gmail.com>
 <20170502184923.jdpfx3pwkl5avdph@angband.pl>
 <c7f3c9fe-2f28-e102-9df7-273dc5a6ca8e@inwind.it>
 <20170502221506.3dfe125e@jupiter.sol.kaishome.de>
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <cdf96959-94e8-4932-465f-ea5c72187892@inwind.it>
Date: Wed, 3 May 2017 19:05:34 +0200
MIME-Version: 1.0
In-Reply-To: <20170502221506.3dfe125e@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-05-02 22:15, Kai Krakow wrote:
>> For example, it would be possible to implement a sane check that
>> prevent to mount a btrfs filesystem if two devices exposes the same
>> UUID... 
> Ideally, the btrfs wouldn't even appear in /dev until it was assembled
> by udev. But apparently that's not the case, and I think this is where
> the problems come from. I wish, btrfs would not show up as device nodes
> in /dev that the mount command identified as btrfs. Instead, btrfs
> would expose (probably through udev) a device node
> in /dev/btrfs/fs_identifier when it is ready.


And what if udev fails to assemble the devices (for example because not all the disks are available or because there are two disks with the same uuid) ?
And if the user can't access the disks, how he could solve the issues (i.e. two disk with the same uuid)

I think that udev should be put out of the game of assembling the disks. For the following reasons:
1) udev is not developed by the BTRFS community where the btrfs knowledges are; there are a lot of corner cases which are not clear to the btrfs developers; how these case could be more clearer to the udev developers (who indeed are very smart guys) ?
2) I don't think that udev is flexible enough to handle all the cases (e.g.: two disks with the same uuid,  missing devices)
3) udev works quite well at handling the device appearing; why it should be involved in the filesystem assembling ?


BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
