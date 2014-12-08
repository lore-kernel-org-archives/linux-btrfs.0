Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33369 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937AbaLHRfV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 12:35:21 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so5413142wid.3
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Dec 2014 09:35:20 -0800 (PST)
Message-ID: <5485E1A0.4030602@gmail.com>
Date: Mon, 08 Dec 2014 18:36:32 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Phillip Susi <psusi@ubuntu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2][BTRFS-PROGS] Don't use LVM snapshot device
References: <1417718382-6753-1-git-send-email-kreijack@inwind.it> <5485C432.3030307@ubuntu.com>
In-Reply-To: <5485C432.3030307@ubuntu.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/08/2014 04:30 PM, Phillip Susi wrote:
> On 12/4/2014 1:39 PM, Goffredo Baroncelli wrote:
[...]
>> To check if a device is a LVM snapshot, it is checked the 'udev' 
>> device property 'DM_UDEV_LOW_PRIORITY_FLAG' . If it is set to 1, 
>> the device has to be skipped.
> 
>> As consequence, btrfs now depends also by the libudev.
> 
> Rather than modify btrfs device scan to link to libudev and ignore the
> caller when commanded to scan a snapshot, wouldn't it be
> simpler/better to just fix the udev rule to not *call* btrfs device
> scan on the snapshot?

I like this approach, but as I wrote before, it seems that 
initramfs executes a "btrfs dev scan".... (see my previoue email 
'Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their snapshots' 
date 2014/12/03 9:34):

$ grep -r "btrfs dev.*scan" /usr/share/initramfs-tools/
/usr/share/initramfs-tools/scripts/local-premount/btrfs:	/sbin/btrfs device scan 2> /dev/null

(this is from a debian). 
However it has to be pointed out that
fedora doesn't seems to do the same...

I have to investigate a bit....

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
