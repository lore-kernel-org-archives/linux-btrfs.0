Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:38399 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752204AbdLLQ1Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 11:27:25 -0500
Received: by mail-it0-f51.google.com with SMTP id r6so25574174itr.3
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 08:27:25 -0800 (PST)
Subject: Re: broken btrfs filesystem
To: Hugo Mills <hugo@carfax.org.uk>, Neal Becker <ndbecker2@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAG3t+pHLcrMLH8XxWSc+P6v-gtMZds+RNKBz6RKzAWdWr8ObhQ@mail.gmail.com>
 <20171212145201.GA18793@carfax.org.uk>
 <CAG3t+pH3+B08M4y1t+K4p2SEk5KURtF_jTitL0RWZ2E-yVAHgg@mail.gmail.com>
 <20171212162423.GB18793@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5ce1cc10-c195-e931-88f5-85cee56e29e0@gmail.com>
Date: Tue, 12 Dec 2017 11:27:20 -0500
MIME-Version: 1.0
In-Reply-To: <20171212162423.GB18793@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-12-12 11:24, Hugo Mills wrote:
> On Tue, Dec 12, 2017 at 04:18:09PM +0000, Neal Becker wrote:
>> Is it possible to check while it is mounted?
> 
>     Certainly not while mounted read-write. While mounted read-only --
> I'm not certain. Possibly.
In theory, it is possible, but I think that the safety measures in 
`btrfs check` don't distinguish between the two cases, so in practice it 
may not be possible.
> 
>     Hugo.
> 
>> On Tue, Dec 12, 2017 at 9:52 AM Hugo Mills <hugo@carfax.org.uk> wrote:
>>
>>> On Tue, Dec 12, 2017 at 09:02:56AM -0500, Neal Becker wrote:
>>>> sudo ls -la ~/
>>>> [sudo] password for nbecker:
>>>> ls: cannot access '/home/nbecker/.bash_history': No such file or
>>> directory
>>>> ls: cannot access '/home/nbecker/.bash_history': No such file or
>>> directory
>>>> ls: cannot access '/home/nbecker/.bash_history': No such file or
>>> directory
>>>> ls: cannot access '/home/nbecker/.bash_history': No such file or
>>> directory
>>>> ls: cannot access '/home/nbecker/.bash_history': No such file or
>>> directory
>>>> ls: cannot access '/home/nbecker/.bash_history': No such file or
>>> directory
>>>> total 11652
>>>> drwxr-xr-x. 1 nbecker nbecker     5826 Dec 12 08:48  .
>>>> drwxr-xr-x. 1 root    root          48 Aug  2 19:32  ..
>>>> [...]
>>>> -rwxrwxr-x. 1 nbecker nbecker      207 Dec  3  2015  BACKUP.sh
>>>> -?????????? ? ?       ?              ?            ?  .bash_history
>>>> -?????????? ? ?       ?              ?            ?  .bash_history
>>>> -?????????? ? ?       ?              ?            ?  .bash_history
>>>> -?????????? ? ?       ?              ?            ?  .bash_history
>>>> -?????????? ? ?       ?              ?            ?  .bash_history
>>>> -?????????? ? ?       ?              ?            ?  .bash_history
>>>> -rw-r--r--. 1 nbecker nbecker       18 Oct  8  2014  .bash_logout
>>>> [...]
>>>
>>>     Could you show the result of btrfs check --readonly on this FS? The
>>> rest, below, doesn't show up anything unusual to me.
>>>
>>>     Hugo.
>>>
>>>> uname -a
>>>> Linux nbecker2 4.14.3-300.fc27.x86_64 #1 SMP Mon Dec 4 17:18:27 UTC
>>>> 2017 x86_64 x86_64 x86_64 GNU/Linux
>>>>
>>>>   btrfs --version
>>>> btrfs-progs v4.11.1
>>>>
>>>> sudo btrfs fi show
>>>> Label: 'fedora'  uuid: 93c586fa-6d86-4148-a528-e61e644db0c8
>>>> Total devices 1 FS bytes used 80.96GiB
>>>> devid    1 size 230.00GiB used 230.00GiB path /dev/sda3
>>>>
>>>> sudo btrfs fi df /home
>>>> Data, single: total=226.99GiB, used=78.89GiB
>>>> System, single: total=4.00MiB, used=48.00KiB
>>>> Metadata, single: total=3.01GiB, used=2.07GiB
>>>> GlobalReserve, single: total=222.36MiB, used=0.00B
>>>>
>>>> dmesg.log is here:
>>>> https://nbecker.fedorapeople.org/dmesg.txt
>>>>
>>>> mount | grep btrfs
>>>> /dev/sda3 on / type btrfs
>>>> (rw,relatime,seclabel,ssd,space_cache,subvolid=257,subvol=/root)
>>>> /dev/sda3 on /home type btrfs
>>>> (rw,relatime,seclabel,ssd,space_cache,subvolid=318,subvol=/home)
>>>>
>>>
> 

