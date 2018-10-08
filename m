Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B862AC65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 21:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D1F9213A2
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 21:01:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D1F9213A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=couderc.eu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbeJIEPT (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 9 Oct 2018 00:15:19 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:11940 "EHLO smtp1-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725749AbeJIEPT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 Oct 2018 00:15:19 -0400
Received: from mail.tol.fr (unknown [78.234.252.95])
        by smtp1-g21.free.fr (Postfix) with ESMTP id 6D116B0053B;
        Mon,  8 Oct 2018 23:01:37 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by mail.tol.fr (Postfix) with ESMTP id 0BE9397805FC;
        Mon,  8 Oct 2018 23:01:37 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at sos.couderc.eu
Received: from mail.tol.fr ([127.0.0.1])
        by localhost (sos.couderc.eu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id d-qWF6Cj3cXe; Mon,  8 Oct 2018 23:01:36 +0200 (CEST)
Received: from [192.168.163.11] (unknown [192.168.163.254])
        by mail.tol.fr (Postfix) with ESMTPSA id 2D1EF9780522;
        Mon,  8 Oct 2018 23:01:36 +0200 (CEST)
Subject: Re: Which device is missing ?
To:     Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <700c973f-7ac7-5416-6e15-9e5e4faf9f67@couderc.eu>
 <20181008161055.GB25913@carfax.org.uk> <20181008161447.GC25913@carfax.org.uk>
From:   Pierre Couderc <pierre@couderc.eu>
Message-ID: <b93e52ee-7bc5-db85-b634-d8aa5ed80ced@couderc.eu>
Date:   Mon, 8 Oct 2018 23:01:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181008161447.GC25913@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: fr-classic
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 10/08/2018 06:14 PM, Hugo Mills wrote:
> On Mon, Oct 08, 2018 at 04:10:55PM +0000, Hugo Mills wrote:
>> On Mon, Oct 08, 2018 at 03:49:53PM +0200, Pierre Couderc wrote:
>>> I ma trying to make a "RAID1" with /dev/sda2 ans /dev/sdb (or similar).
>>>
>>> But I have stranges status or errors  about "missing devices" and I
>>> do not understand the current situation :
>>>
>>>
>>> root@server:~# btrfs fi show
>>> Label: none  uuid: 28c2b7ab-631c-40a3-bab7-00dac5dd20eb
>>>          Total devices 1 FS bytes used 190.91GiB
>>>          devid    1 size 1.82TiB used 196.02GiB path /dev/sda2
>>>
>>> warning, device 1 is missing
>>> Label: none  uuid: 2d45149a-fb97-4c2a-bae2-4cfe4e01a8aa
>>>          Total devices 2 FS bytes used 116.18GiB
>>>          devid    2 size 1.82TiB used 118.03GiB path /dev/sdb
>>>          *** Some devices missing
>>     This looks like you've created a RAID-1 array with /dev/sda2 and
>> /dev/sdb, and then run mkfs.btrfs again on /dev/sda2, overwriting the
>> original [part of a] filesystem on /dev/sda2, and replacing it with a
>> wholly different filesystem. Since the new FS on /dev/sda2 (UUID
>> 28c2...) doesn't have the same UUID as the original FS (UUID 2d45...),
>> and the original FS was made of two devices, btrfs fi show is telling
>> you that there's some devices missing -- /dev/sda2 is no longer part
>> of that FS, and is therefore a missing device.
>>
>>     I note that you've got data on both filesystems, so they must both
>> have been mounted somewhere and had stuff put on them.
>>
>>     I recommend doing something like this:
>>
>> # mkfs /media/btrfs/myraid1 /media/btrfs/tmp
>> # mount /dev/sdb /media/btrfs/myraid1/
>> # mount /dev/sda2 /media/btrfs/tmp/              # mount both filesystems
>> # cp /media/btrfs/tmp/* /media/btrfs/myraid1     # put it where you want it
>> # umount /media/btrfs/tmp/
>> # wipefs /dev/sda2                               # destroy the FS on sda2
>> # btrfs replace start 1 /dev/sda2 /media/btrfs/myraid1/
>>
>>     This will copy all the data from the filesystem on /dev/sda2 into
>> the filesystem on /dev/sdb, destroy the FS on sda2, and then use sda2
>> as the second device for the main FS.
>>
>> *WARNING!*
>>
>>     Note that, since the main FS is missing a device, it will probably
>> need to be mounted in degraded mode (-o degraded), and that on kernels
>> earlier than (IIRC) 4.14, this can only be done *once* without the FS
>> becoming more or less permanently read-only. On recent kernels, it
>> _should_ be OK.
>>
>> *WARNING ENDS*
>     Oh, and for the record, to make a RAID-1 filesystem from scratch,
> you simply need this:
>
> # mkfs.btrfs -m raid1 -d raid1 /dev/sda2 /dev/sdb
>
>     You do not need to run mkfs.btrfs on each device separately.
>
>     Hugo.
Thnk you very much. I understand a bit better. I think  that I have 
nothing of interest on /dev/sdb and that its contents is the result of 
previous trials.
And that my system is on /dev/dsda2 as :

root@server:~# df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            3.9G     0  3.9G   0% /dev
tmpfs           787M  8.8M  778M   2% /run
/dev/sda2       1.9T  193G  1.7T  11% /
tmpfs           3.9G     0  3.9G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           3.9G     0  3.9G   0% /sys/fs/cgroup
/dev/sda1       511M  5.7M  506M   2% /boot/efi
tmpfs           100K     0  100K   0% /var/lib/lxd/shmounts
tmpfs           100K     0  100K   0% /var/lib/lxd/devlxd
root@server:~#

Is it exact ?
If yes, I suppose I should wipe data on /dev/sdb, then build the RAID by 
expanding /dev/sda2.
So I should :

wipefs /dev/sdb
btrfs device add /dev/sdb /
btrfs balance start -v -mconvert=raid1 -dconvert=raid1 /


Does it sound correct ? (my kernel is boot/vmlinuz-4.18.0-1-amd64)




