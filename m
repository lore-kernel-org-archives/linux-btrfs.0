Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:62458 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbaAAWf2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Jan 2014 17:35:28 -0500
Received: by mail-ee0-f52.google.com with SMTP id d17so6014641eek.39
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jan 2014 14:35:26 -0800 (PST)
Received: from nec-laptop.localdomain (HSI-KBW-095-208-248-073.hsi5.kabel-badenwuerttemberg.de. [95.208.248.73])
        by mx.google.com with ESMTPSA id a51sm130693922eeh.8.2014.01.01.14.35.25
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 01 Jan 2014 14:35:26 -0800 (PST)
Message-ID: <52C4982C.1040606@gmail.com>
Date: Wed, 01 Jan 2014 23:35:24 +0100
From: Oliver Mangold <o.mangold@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: coredump in btrfsck
References: <52C4884F.6040000@gmail.com> <45E0985F-4F75-47D1-BD6E-2286D5844AE3@colorremedies.com>
In-Reply-To: <45E0985F-4F75-47D1-BD6E-2286D5844AE3@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01.01.2014 22:58, Chris Murphy wrote:
> On Jan 1, 2014, at 2:27 PM, Oliver Mangold <o.mangold@gmail.com> wrote:
>
>> I fear, I broke my FS by running btrfsck. I tried 'btrfsck --repair' and it fixed several problems but finally crashed with some debug message from 'extent-tree.c', so I also tried 'btrfsck --repair --init-extent-tree'.
> It is sort of a (near) last restort, you know this right? What did you try before btrfsck? Did you set dmesg -n7, then mount -o recovery and if so what was recorded in dmesg?
Ehm, actually, no. Before I ran btrfsck there was no reason to use '-o 
recovery' or something, because the filesystem seemed to work. But I was 
worried after running btrfsck, because the FS apparently was in an 
inconsistent state. So I tried 'btrfsck --repair' and when that crashed 
'btrfsck --init-extent-tree'. Didn't know it is considered 'last 
resort'. It did the trick for several previous problems and seemed to 
have no negative consequences, so I tried it now also.

But it looks like I can still recover my data with 'btrfs restore', so 
it's less critical than assumed.

Sorry, that I can't give you the logs you would have liked. Didn't 
expect anything bad to happen. I would just wsh that btrfsck could fix 
that kind of problem. Let me know if I can help.
>> produces log messages:
>>
>> Jan 01 21:45:09 home kernel: btrfs: device fsid 31a5d433-4f7b-49cc-9bc0-9422471f5194 devid 1 transid 4793 /dev/mapper/primary-home
>> Jan 01 21:45:09 home kernel: btrfs: disk space caching is enabled
>> Jan 01 21:45:09 home kernel: parent transid verify failed on 2176851968 wanted 4792 found 4793
>> Jan 01 21:45:09 home kernel: parent transid verify failed on 2176851968 wanted 4792 found 4793
>> Jan 01 21:45:09 home kernel: btrfs: open_ctree failed
> If you previously tried -o recovery, before btrfsck did you try btrfs-zero-log and if so what were the results in console and in dmesg?
>
>
> Chris Murphy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

