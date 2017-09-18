Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:52680 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755500AbdIRLgR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 07:36:17 -0400
Received: by mail-io0-f182.google.com with SMTP id i197so1277890ioe.9
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 04:36:17 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id i76sm3067845itf.3.2017.09.18.04.36.15
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Sep 2017 04:36:15 -0700 (PDT)
Subject: Re: A user cannot remove his readonly snapshots?!
To: linux-btrfs@vger.kernel.org
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
 <38b35e41-313a-1eed-667a-ee3138c8170d@gmail.com>
 <20170915193211.GE32347@rus.uni-stuttgart.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7600502f-bad7-9802-1a0b-146869236133@gmail.com>
Date: Mon, 18 Sep 2017 07:36:12 -0400
MIME-Version: 1.0
In-Reply-To: <20170915193211.GE32347@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-15 15:32, Ulli Horlacher wrote:
> On Fri 2017-09-15 (13:08), Austin S. Hemmelgarn wrote:
>> On 2017-09-15 12:37, Ulli Horlacher wrote:
>>
>>> I have my btrfs filesystem mounted with option user_subvol_rm_allowed
>>> tux@xerus: btrfs subvolume delete /test/tux/zz/.snapshot/2017-09-15_1824.test
>>> Delete subvolume (no-commit): '/test/tux/zz/.snapshot/2017-09-15_1824.test'
>>> ERROR: cannot delete '/test/tux/zz/.snapshot/2017-09-15_1824.test': Read-only file system
>>>
>>> root can delete this snapshot, but not the user. Why?
>>>
>>
>> Add 'user_subvol_rm' to the mount options and try again.
> 
> root@xerus:~# mount -vo user_subvol_rm /dev/sdd4 /test
> mount: wrong fs type, bad option, bad superblock on /dev/sdd4,
>         missing codepage or helper program, or other error
> 
>         In some cases useful info is found in syslog - try
>         dmesg | tail or so.
> 
> root@xerus:~# dmesg | tail -2
> [1514588.018991] BTRFS info (device sdd4): unrecognized mount option 'user_subvol_rm'
> [1514588.028430] BTRFS: open_ctree failed
> 
> user_subvol_rm is not listed on
> https://btrfs.wiki.kernel.org/index.php/Mount_options
> 
> Did you mean user_subvol_rm_allowed?
Yes, that's what I meant, sorry about the confusion.
> I have already used this option, without success. See above.
I missed that, sorry.

