Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:36586 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932647AbdHVOiB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 10:38:01 -0400
Received: by mail-it0-f43.google.com with SMTP id x187so537219ite.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 07:38:00 -0700 (PDT)
Subject: Re: finding root filesystem of a subvolume?
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <20170822124036.GA32302@carfax.org.uk>
 <20170822125030.GB14804@rus.uni-stuttgart.de>
 <16778020-9167-b7cc-4768-ee33dca2bbb7@gmail.com>
 <20170822133030.GE14804@rus.uni-stuttgart.de>
 <0c35fba9-a514-31dd-a703-17f4727ed229@gmail.com>
 <20170822135301.GF14804@rus.uni-stuttgart.de>
 <ebb608fe-15f3-3b51-b06f-28c1dcfb6612@gmail.com>
 <20170822142336.GB32302@carfax.org.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ccc4d5e7-8aa7-bf6b-c639-74fcd0204ad3@gmail.com>
Date: Tue, 22 Aug 2017 10:37:57 -0400
MIME-Version: 1.0
In-Reply-To: <20170822142336.GB32302@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-22 10:23, Hugo Mills wrote:
> On Tue, Aug 22, 2017 at 10:12:25AM -0400, Austin S. Hemmelgarn wrote:
>> On 2017-08-22 09:53, Ulli Horlacher wrote:
>>> On Tue 2017-08-22 (09:37), Austin S. Hemmelgarn wrote:
>>>
>>>>> root@fex:~# df -T /local/.backup/home
>>>>> Filesystem     Type  1K-blocks      Used Available Use% Mounted on
>>>>> -              -    1073740800 104252160 967766336  10% /local/.backup/home
>>>>
>>>> Hmm, now I'm really confused, I just checked on the Ubuntu 17.04 and
>>>> 16.04.3 VM's I have (I only run current and the most recent LTS
>>>> version), and neither of them behave like this.
>>>
>>> I have this kind of output on all of my Ubuntu hosts:
>>>
>>> root@moep:~# grep PRETTY_NAME /etc/os-release
>>> PRETTY_NAME="Ubuntu 16.04.3 LTS"
>>>
>>> root@moep:~# df -T /usb/UF/tmp/blubb
>>> Filesystem     Type 1K-blocks    Used Available Use% Mounted on
>>> -              -     12581888 3690524   7253700  34% /usb/UF/tmp/blubb
>>>
>>> root@moep:~# btrfs subvolume show /usb/UF/tmp/blubb
>>> /usb/UF/tmp/blubb
>>>          Name:                   blubb
>>>          UUID:                   ecf8c804-d4a3-9948-89fe-b0c1971c25cb
>>>          Parent UUID:            -
>>>          Received UUID:          -
>>>          Creation time:          2017-08-22 12:54:16 +0200
>>>          Subvolume ID:           262
>>>          Generation:             23
>>>          Gen at creation:        22
>>>          Parent ID:              5
>>>          Top level ID:           5
>>>          Flags:                  -
>>>          Snapshot(s):
>>>
>>> root@moep:~# dpkg -l | grep btrfs
>>> ii  btrfs-tools                                 4.4-1ubuntu1                                 amd64        Checksumming Copy on Write Filesystem utilities
>>>
>> Hmm, interesting.  Are you using qgroups by chance?
> 
>     I get this behaviour (the "- -") only if it's a non-mounted
> subvolume:
> 
> hrm@amelia:~ $ df -T .
> Filesystem     Type  1K-blocks     Used Available Use% Mounted on
> /dev/sdb1      btrfs 117220284 95271852  18611060  84% /home
> 
> hrm@amelia:~ $ sudo btrfs sub crea foo
> Create subvolume './foo'
> 
> hrm@amelia:~ $ df -T ./foo
> Filesystem     Type 1K-blocks     Used Available Use% Mounted on
> -              -    117220284 95271880  18611032  84% /home/hrm/foo
> 
> hrm@amelia:~ $ sudo mkdir foo/bar
> hrm@amelia:~ $ df -T foo/bar
> Filesystem     Type 1K-blocks     Used Available Use% Mounted on
> -              -    117220284 95271852  18611060  84% /home/hrm/foo
> 
> hrm@amelia:~ $ mkdir foo2
> 
> hrm@amelia:~ $ sudo mount /dev/sdb1 ./foo2 -o subvol=home/hrm/foo
> 
> hrm@amelia:~ $ df -T foo2
> Filesystem     Type  1K-blocks     Used Available Use% Mounted on
> /dev/sdb1      btrfs 117220284 95272384  18610528  84% /home/hrm/foo2
> 
Wait, I think I see what's up here.  I was just calling `df -T` without 
pointing at the subvolume (which correctly ignores it because it's not 
actually mounted).  It looks like this is a side effect of the (rather 
irritating) fake mount-point behavior of subvolumes.
