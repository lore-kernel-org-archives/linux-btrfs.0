Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:51275 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab3K0JPt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Nov 2013 04:15:49 -0500
Received: by mail-bk0-f49.google.com with SMTP id my13so3009374bkb.8
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 01:15:48 -0800 (PST)
Message-ID: <5295B818.4080906@gmail.com>
Date: Wed, 27 Nov 2013 11:15:04 +0200
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: kreijack@inwind.it
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS-PROG: recursively subvolume snapshot and delete
References: <1384621747-25441-1-git-send-email-kreijack@inwind.it> <5293BFD1.6000502@libero.it> <5294BA6D.5080006@gmail.com> <5294DE1A.8010305@libero.it>
In-Reply-To: <5294DE1A.8010305@libero.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 26/11/2013 7:44 μμ, Goffredo Baroncelli wrote:
> On 2013-11-26 16:12, Konstantinos Skarlatos wrote:
>> On 25/11/2013 11:23 μμ, Goffredo Baroncelli wrote:
>>> Hi all,
>>>
>>> nobody is interested in these new features ?
>> Is this ZFS-style recursive snapshotting? If yes, i am interested, and
>> thanks for your great work :)
> No it is not equal. My recursive snapshotting is not atomic as the ZFS
> one; every subvolume snapshot is atomic, but each snapshot is taken at
> different time.
For my use case that is not a problem, but others may disagree
>
> BR
> G.Baroncelli
>
>>> On 2013-11-16 18:09, Goffredo Baroncelli wrote:
>>>> Hi All,
>>>>
>>>> the following patches implement the recursively snapshotting and
>>>> deleting of a subvolume.
>>>>
>>>> To snapshot recursively you must pass the -R switch:
>>>>
>>>> # btrfs subvolume create sub1
>>>> Create subvolume './sub1'
>>>> # btrfs subvolume create sub1/sub2
>>>> Create subvolume 'sub1/sub2'
>>>>
>>>> # btrfs subvolume snapshot -R sub1 sub1-snap
>>>> Create a snapshot of 'sub1' in './sub1-snap'
>>>> Create a snapshot of 'sub1/sub2' in './sub1-snap/sub2'
>>>>
>>>> To recursively delete subvolumes, you must pass the switch '-R':
>>>>
>>>> # btrfs subvolume create sub1
>>>> Create subvolume './sub1'
>>>> # btrfs subvolume create sub1/sub2
>>>> Create subvolume 'sub1/sub2'
>>>>
>>>> # btrfs subvolume delete -R sub1
>>>> Delete subvolume '/root/sub1/sub2'
>>>> Delete subvolume '/root/sub1'
>>>>
>>>>
>>>> Some caveats:
>>>> 1) the recursively behaviour need the root capability
>>>> This because how the subvolume are discovered
>>>>
>>>> 2) it is not possible to recursively snapshot a subvolume
>>>> in read-only mode
>>>> This because when a subvolume is snapshotted, its
>>>> nested subvolumes appear as directory in the snapshot.
>>>> These directories are removed before snapshotting the
>>>> nested subvolumes. This is incompatible with a read
>>>> only subvolume.
>>>>
>>>> BR
>>>> G.Baroncelli
>>>>
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

