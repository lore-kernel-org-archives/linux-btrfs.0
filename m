Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35555 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932842AbdHVOM2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 10:12:28 -0400
Received: by mail-io0-f175.google.com with SMTP id 1so27305935ioy.2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 07:12:28 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id z139sm5181639itb.41.2017.08.22.07.12.26
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Aug 2017 07:12:26 -0700 (PDT)
Subject: Re: finding root filesystem of a subvolume?
To: linux-btrfs@vger.kernel.org
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <20170822124036.GA32302@carfax.org.uk>
 <20170822125030.GB14804@rus.uni-stuttgart.de>
 <16778020-9167-b7cc-4768-ee33dca2bbb7@gmail.com>
 <20170822133030.GE14804@rus.uni-stuttgart.de>
 <0c35fba9-a514-31dd-a703-17f4727ed229@gmail.com>
 <20170822135301.GF14804@rus.uni-stuttgart.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <ebb608fe-15f3-3b51-b06f-28c1dcfb6612@gmail.com>
Date: Tue, 22 Aug 2017 10:12:25 -0400
MIME-Version: 1.0
In-Reply-To: <20170822135301.GF14804@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-22 09:53, Ulli Horlacher wrote:
> On Tue 2017-08-22 (09:37), Austin S. Hemmelgarn wrote:
> 
>>> root@fex:~# df -T /local/.backup/home
>>> Filesystem     Type  1K-blocks      Used Available Use% Mounted on
>>> -              -    1073740800 104252160 967766336  10% /local/.backup/home
>>
>> Hmm, now I'm really confused, I just checked on the Ubuntu 17.04 and
>> 16.04.3 VM's I have (I only run current and the most recent LTS
>> version), and neither of them behave like this.
> 
> I have this kind of output on all of my Ubuntu hosts:
> 
> root@moep:~# grep PRETTY_NAME /etc/os-release
> PRETTY_NAME="Ubuntu 16.04.3 LTS"
> 
> root@moep:~# df -T /usb/UF/tmp/blubb
> Filesystem     Type 1K-blocks    Used Available Use% Mounted on
> -              -     12581888 3690524   7253700  34% /usb/UF/tmp/blubb
> 
> root@moep:~# btrfs subvolume show /usb/UF/tmp/blubb
> /usb/UF/tmp/blubb
>          Name:                   blubb
>          UUID:                   ecf8c804-d4a3-9948-89fe-b0c1971c25cb
>          Parent UUID:            -
>          Received UUID:          -
>          Creation time:          2017-08-22 12:54:16 +0200
>          Subvolume ID:           262
>          Generation:             23
>          Gen at creation:        22
>          Parent ID:              5
>          Top level ID:           5
>          Flags:                  -
>          Snapshot(s):
> 
> root@moep:~# dpkg -l | grep btrfs
> ii  btrfs-tools                                 4.4-1ubuntu1                                 amd64        Checksumming Copy on Write Filesystem utilities
> 
Hmm, interesting.  Are you using qgroups by chance?

