Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:41991 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752067AbeGCLyQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 07:54:16 -0400
Received: by mail-io0-f181.google.com with SMTP id r24-v6so1441189ioh.9
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jul 2018 04:54:16 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id d13-v6sm460349itj.30.2018.07.03.04.54.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Jul 2018 04:54:14 -0700 (PDT)
Subject: Re: unsolvable technical issues?
To: linux-btrfs@vger.kernel.org
References: <b255d0fb-5cee-36c5-d49f-5f014d20e518@dirtcellar.net>
 <pan$11f2c$c623d7b0$5173b25$c7594479@cox.net>
 <646f0c52-4726-7a7d-0242-4412950bf002@libero.it>
 <64876ad1-9f63-f6f0-9d55-0fa4999f0bf5@gmail.com>
 <pan$15832$609432db$876d9a8a$e5840f46@cox.net>
 <9b482289-c96f-dac3-d2e7-db6a32596334@gmail.com>
 <ea1a9c9b-7132-87f1-04fc-85b278975925@gmail.com>
 <pan$f3f7b$53185d9e$ee073b92$d7d590bf@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0ef3c37b-d8a3-2134-d39e-5aa7605c498c@gmail.com>
Date: Tue, 3 Jul 2018 07:54:14 -0400
MIME-Version: 1.0
In-Reply-To: <pan$f3f7b$53185d9e$ee073b92$d7d590bf@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-07-03 03:35, Duncan wrote:
> Austin S. Hemmelgarn posted on Mon, 02 Jul 2018 07:49:05 -0400 as
> excerpted:
> 
>> Notably, most Intel systems I've seen have the SATA controllers in the
>> chipset enumerate after the USB controllers, and the whole chipset
>> enumerates after add-in cards (so they almost always have this issue),
>> while most AMD systems I've seen demonstrate the exact opposite
>> behavior,
>> they enumerate the SATA controller from the chipset before the USB
>> controllers, and then enumerate the chipset before all the add-in cards
>> (so they almost never have this issue).
> 
> Thanks.  That's a difference I wasn't aware of, and would (because I tend
> to favor amd) explain why I've never seen a change in enumeration order
> unless I've done something like unplug my sata cables for maintenance and
> forget which ones I had plugged in where -- random USB stuff left plugged
> in doesn't seem to matter, even choosing different boot media from the
> bios doesn't seem to matter by the time the kernel runs (I'm less sure
> about grub).
> 
Additionally though, if you in some way make sure SATA drivers are 
loaded before USB ones, you will also never see this issue because of 
USB devices (same goes for GRUB).  A lot of laptops that use connections 
other than USB for the keyboard and mouse behave like this if you use a 
properly stripped down initramfs because you won't have USB drivers in 
the initramfs (and therefore the SATA drivers always load first).
