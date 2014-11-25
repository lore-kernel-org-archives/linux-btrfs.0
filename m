Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33219 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaKYRKf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 12:10:35 -0500
Received: by mail-wg0-f46.google.com with SMTP id x12so1448949wgg.33
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 09:10:34 -0800 (PST)
Message-ID: <5474B805.1090806@gmail.com>
Date: Tue, 25 Nov 2014 18:10:29 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 0/4] New 'btrfs chunk list' command
References: <1416931045-24259-1-git-send-email-kreijack@inwind.it> <1995604.saxct2VtQ4@merkaba>
In-Reply-To: <1995604.saxct2VtQ4@merkaba>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/25/2014 05:08 PM, Martin Steigerwald wrote:
> Hi Goffredo,
> 
> Am Dienstag, 25. November 2014, 16:57:21 schrieb Goffredo Baroncelli:
>> This is a revamp of a my previous patches set[1]. After more than
>> year of attempts these patches were never merged, so I tried to
>> simplify them and to change a bit the focus. The previous patches set
>> had the focus to the disk usage.
>> The aim of these patches now is to show the chunks distribution
>> among the disks. So a new command 'btrfs chunk list' is added:
>>
>> $ sudo ./btrfs chunk list /mnt/btrfs1/
>> Data,RAID6: Size:3.00GiB, Used:1.02MiB
>>    /dev/vdb	   1.00GiB
>>    /dev/vdd	   1.00GiB
>>    /dev/vde	   1.00GiB
>>    /dev/vdf	   1.00GiB
>>    /dev/vdg	   1.00GiB
> 
> I still like your previous patch set *a lot* and wonder why exactly is has 
> never been merged. I know there has been quite some discussion about it, but 
> in the end I lost track.

David told [wrote] few minutes ago that this patch is still on the queue.


> 
> Can the chunk list also display the usage inside the chunks?
Unfortunately not. I don't know how it would be possible to get this info.

> 
> Thanks,
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
