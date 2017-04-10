Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:36515 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753668AbdDJRNs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 13:13:48 -0400
Received: by mail-io0-f180.google.com with SMTP id l7so102961066ioe.3
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Apr 2017 10:13:48 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id w133sm3830038itf.2.2017.04.10.10.13.43
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Apr 2017 10:13:43 -0700 (PDT)
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
To: linux-btrfs@vger.kernel.org
References: <572D0C8B.8010404@mendix.com>
 <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
 <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
 <51778c0f-2720-1c2d-aba2-e22e5f4d3a3a@mendix.com>
 <4532f6ee-2a6e-412a-7230-edb76735d55f@mendix.com>
 <07a7f59e-64e0-4d09-5d32-01bc933fe38d@gmail.com>
 <20170410144533.664fc304@jupiter.sol.kaishome.de>
 <5488ea5a-b41c-5987-e664-ec17cf2d5e01@gmail.com>
 <20170410184444.08ced097@jupiter.sol.local>
 <20170410185437.235b3b86@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7ea65b63-d399-c049-d466-681c1df2d025@gmail.com>
Date: Mon, 10 Apr 2017 13:13:39 -0400
MIME-Version: 1.0
In-Reply-To: <20170410185437.235b3b86@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-04-10 12:54, Kai Krakow wrote:
> Am Mon, 10 Apr 2017 18:44:44 +0200
> schrieb Kai Krakow <hurikhan77@gmail.com>:
>
>> Am Mon, 10 Apr 2017 08:51:38 -0400
>> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
>>
>>> On 2017-04-10 08:45, Kai Krakow wrote:
>>>> Am Mon, 10 Apr 2017 08:39:23 -0400
>>>> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
>>>>
>>  [...]
>>>>
>>>> Does btrfs really support lazytime now?
>>>>
>>> It appears to, I do see fewer writes with it than without it.  At
>>> the very least, if it doesn't, then nothing complains about it.
>>
>> Did you put it in /etc/fstab only for the rootfs? If yes, it probably
>> has no effect. You would need to give it as rootflags on the kernel
>> cmdline.
>
> I did a "fgrep lazytime /usr/src/linux -ir" and it reveals only ext4
> and f2fs know the flag. Kernel 4.10.
>
> So probably you're seeing a placebo effect. If you put lazytime for
> rootfs just only into fstab, it won't have an effect because on initial
> mount this file cannot be opened (for obvious reasons), and on remount,
> btrfs seems to happily accept lazytime but it has no effect. It won't
> show up in /proc/mounts. Try using it in rootflags kernel cmdline and
> you should see that the kernel won't accept the flag lazytime.
>
The command-line also rejects a number of perfectly legitimate arguments 
that BTRFS does understand too though, so that's not much of a test. 
I've just finished some quick testing though, and it looks like you're 
right, BTRFS does not support this, which means I now need to figure out 
what the hell was causing the IOPS counters in collectd to change in 
rough correlation  with remounting (especially since it appears to 
happen mostly independent of the options being changed).

This is somewhat disappointing though, as supporting this would probably 
help with the write-amplification issues inherent in COW filesystems.
