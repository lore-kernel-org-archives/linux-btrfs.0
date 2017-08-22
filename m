Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:35711 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932833AbdHVNhN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 09:37:13 -0400
Received: by mail-io0-f180.google.com with SMTP id 1so26926233ioy.2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 06:37:13 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id i127sm4979787ita.3.2017.08.22.06.37.11
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Aug 2017 06:37:11 -0700 (PDT)
Subject: Re: finding root filesystem of a subvolume?
To: linux-btrfs@vger.kernel.org
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <20170822124036.GA32302@carfax.org.uk>
 <20170822125030.GB14804@rus.uni-stuttgart.de>
 <16778020-9167-b7cc-4768-ee33dca2bbb7@gmail.com>
 <20170822133030.GE14804@rus.uni-stuttgart.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0c35fba9-a514-31dd-a703-17f4727ed229@gmail.com>
Date: Tue, 22 Aug 2017 09:37:10 -0400
MIME-Version: 1.0
In-Reply-To: <20170822133030.GE14804@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-22 09:30, Ulli Horlacher wrote:
> On Tue 2017-08-22 (09:27), Austin S. Hemmelgarn wrote:
> 
>>>>> root@fex:~# df -T
>>>>> Filesystem     Type  1K-blocks      Used Available Use% Mounted on
>>>>> -              -    1073740800 104244552 967773976  10% /local/.backup/home
>>>>
>>>>      I've never seen the "- -" output from df before. Is this a bind
>>>> mount or something?
>>>
>>> No, /local/.backup/home is just a btrfs subvolume
>>
>> It arguably shouldn't be showing up here then if it's not been
>> explicitly mounted.  I'm betting you're running OpenSUSE or SLES
> 
> No:
> 
> root@fex:~# cat /etc/os-release
> NAME="Ubuntu"
> VERSION="14.04.5 LTS, Trusty Tahr"
> ID=ubuntu
> ID_LIKE=debian
> PRETTY_NAME="Ubuntu 14.04.5 LTS"
> VERSION_ID="14.04"
> HOME_URL="http://www.ubuntu.com/"
> SUPPORT_URL="http://help.ubuntu.com/"
> BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
> 
> root@fex:~# df -T /local/.backup/home
> Filesystem     Type  1K-blocks      Used Available Use% Mounted on
> -              -    1073740800 104252160 967766336  10% /local/.backup/home
> 
> root@fex:~# type df
> df is hashed (/bin/df)
> 
> root@fex:~# dpkg -S /bin/df
> coreutils: /bin/df
> 
Hmm, now I'm really confused, I just checked on the Ubuntu 17.04 and 
16.04.3 VM's I have (I only run current and the most recent LTS 
version), and neither of them behave like this.
