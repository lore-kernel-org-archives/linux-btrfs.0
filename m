Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i2.italiaonline.it ([212.48.25.210]:43702 "EHLO
	libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751477AbbIQRAM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 13:00:12 -0400
Reply-To: kreijack@inwind.it
Subject: Re: RAID1 storage server won't boot with one disk missing
References: <CAPQXdDQzkQsJrRJH3+c0x93ogDPge_hjHyW1CZ-FQRAdoMaGoA@mail.gmail.com>
 <55FAD9CC.5060206@oracle.com>
To: Anand Jain <anand.jain@oracle.com>, "erpo41@gmail.com" <erpo41@gmail.com>,
        linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <55FAF198.2060106@libero.it>
Date: Thu, 17 Sep 2015 19:00:08 +0200
MIME-Version: 1.0
In-Reply-To: <55FAD9CC.5060206@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,


On 2015-09-17 17:18, Anand Jain wrote:
>  it looks like -o degraded is going to be a very obvious feature,
>  I have plans of making it a default feature, and provide -o
>  nodegraded feature instead. Thanks for comments if any.
> 
> Thanks, Anand

I am not sure if there is a "good" default for this kind of problem; there are several aspects:

- remote machine:
for a remote machine, I think that the root filesystem should be mounted anyway. For a secondary filesystem (home ?), may be that an user intervention could be better (but without home, how an user could log?).

- spare:
in case of a degraded filesystem, the system could insert a spare disk; or a reshaping could be started (raid5->raid1, raid6->raid5)

- initramfs:
this is the most complicated things: currently most initramfs don't mount the filesystem if all the volumes aren't available. Allowing a degraded root filesystem means:
	a) wait for the disks until a timeout
	b) if the timeout expires, mount in degraded mode (inserting a spare disk if available ?)
	c) otherwise mount the filesystem as usual

- degraded:
I think that there are different level of degraded. For example, in case of raid6 a missing device could be acceptable; however in case of a raid5, this should be not allowed; and an user intervention may be preferred.


In the past I suggested the use of an helper, mount.btrfs [1], which could handle all these cases better without a kernel intervention:
- wait for the devices to appear
- verifying if all the needed devices are present 
- mounting the filesystem passing
     - all the devices to the kernel (without relying to udev and btrfs dev scan...)
     - allowing the degraded mode or not                     (policy)
     - starting an insertion of the spare                    (policy)

G.Baroncelli

[1] http://www.spinics.net/lists/linux-btrfs/msg39706.html


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
