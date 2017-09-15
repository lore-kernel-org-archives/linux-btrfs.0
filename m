Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:38761 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbdIORQ4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 13:16:56 -0400
Received: by mail-io0-f194.google.com with SMTP id e9so4585200iod.5
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 10:16:56 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id j83sm728864ioi.57.2017.09.15.10.16.53
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Sep 2017 10:16:53 -0700 (PDT)
Subject: Re: snapshots of encrypted directories?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20170914145739.GA32347@rus.uni-stuttgart.de>
 <20170914153222.GC7067@carfax.org.uk>
 <ac97097d-f107-042c-f402-580a2ab5aa76@gmail.com>
 <20170915100103.GB32347@rus.uni-stuttgart.de>
 <CAEtw4r1KUQJGZkKEA+e3J=3+4a9hW+-ZBRBfTXhwYn4Ae30CCw@mail.gmail.com>
 <20170915162825.GC32347@rus.uni-stuttgart.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6cd1ef22-7cab-4c8c-0b73-d254aeca83ad@gmail.com>
Date: Fri, 15 Sep 2017 13:16:50 -0400
MIME-Version: 1.0
In-Reply-To: <20170915162825.GC32347@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-15 12:28, Ulli Horlacher wrote:
> On Fri 2017-09-15 (12:15), Peter Becker wrote:
>> 2017-09-15 12:01 GMT+02:00 Ulli Horlacher <framstag@rus.uni-stuttgart.de>:
>>
>>> On Fri 2017-09-15 (06:45), Andrei Borzenkov wrote:
>>>
>>>> The actual question is - do you need to mount each individual btrfs
>>>> subvolume when using encfs?
>>>
>>> And even worse it goes with ecryptfs: I do not know at all how to mount a
>>> snapshot, so that the user has access to it.
>>
>> A snapshot is simply a subvolume.
>>
>> Get the ID of the snapshot and mount it:
>>
>> btrfs subvolume list /btrfs
>> mount -o subvolid=<ID> /dev/<DISK> /<MOUNTPOINT_ENCRYPTED>
>>
>> Or mount the snapshot directly by path:
>>
>> mount -o subvol=/snapshots/home/2015-12-01 /<MOUNTPOINT_ENCRYPTED>
>>
>> And then mount enryptfs:
>>
>> mount.ecryptfs /<MOUNTPOINT_ENCRYPTED> /<MOUNTPOINT_DECRYPTED>
> 
> This only possible by root.
> For a user it is not possible to have access for his own snapshots.
> Bad.
> 
Which is why you use EncFS (which is a FUSE module that runs in 
userspace and requires no root privileges) instead of eCryptFS (which is 
a kernel assisted filesystem that doesn't use FUSE, has more complicated 
setup constraints, and requires CAP_SYS_ADMIN or root access).

