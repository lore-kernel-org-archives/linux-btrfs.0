Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58821 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab3KZPNd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 10:13:33 -0500
Received: by mail-wi0-f179.google.com with SMTP id ey16so609969wid.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2013 07:13:31 -0800 (PST)
Message-ID: <5294BA6D.5080006@gmail.com>
Date: Tue, 26 Nov 2013 17:12:45 +0200
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: kreijack@inwind.it, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS-PROG: recursively subvolume snapshot and delete
References: <1384621747-25441-1-git-send-email-kreijack@inwind.it> <5293BFD1.6000502@libero.it>
In-Reply-To: <5293BFD1.6000502@libero.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/11/2013 11:23 μμ, Goffredo Baroncelli wrote:
> Hi all,
>
> nobody is interested in these new features ?
Is this ZFS-style recursive snapshotting? If yes, i am interested, and 
thanks for your great work :)
>
> On 2013-11-16 18:09, Goffredo Baroncelli wrote:
>> Hi All,
>>
>> the following patches implement the recursively snapshotting and
>> deleting of a subvolume.
>>
>> To snapshot recursively you must pass the -R switch:
>>
>> # btrfs subvolume create sub1
>> Create subvolume './sub1'
>> # btrfs subvolume create sub1/sub2
>> Create subvolume 'sub1/sub2'
>>
>> # btrfs subvolume snapshot -R sub1 sub1-snap
>> Create a snapshot of 'sub1' in './sub1-snap'
>> Create a snapshot of 'sub1/sub2' in './sub1-snap/sub2'
>>
>> To recursively delete subvolumes, you must pass the switch '-R':
>>
>> # btrfs subvolume create sub1
>> Create subvolume './sub1'
>> # btrfs subvolume create sub1/sub2
>> Create subvolume 'sub1/sub2'
>>
>> # btrfs subvolume delete -R sub1
>> Delete subvolume '/root/sub1/sub2'
>> Delete subvolume '/root/sub1'
>>
>>
>> Some caveats:
>> 1) the recursively behaviour need the root capability
>> This because how the subvolume are discovered
>>
>> 2) it is not possible to recursively snapshot a subvolume
>> in read-only mode
>> This because when a subvolume is snapshotted, its
>> nested subvolumes appear as directory in the snapshot.
>> These directories are removed before snapshotting the
>> nested subvolumes. This is incompatible with a read
>> only subvolume.
>>
>> BR
>> G.Baroncelli
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>

