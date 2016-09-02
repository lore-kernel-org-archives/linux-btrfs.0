Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:32781 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752753AbcIBWje (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Sep 2016 18:39:34 -0400
Received: by mail-oi0-f46.google.com with SMTP id c15so181556309oig.0
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2016 15:39:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1472854386.9717.7.camel@gmail.com>
References: <1471023419.16857.9.camel@gmail.com> <1472676550.8145.1.camel@gmail.com>
 <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
 <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
 <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com> <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
 <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com> <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
 <1472734635.3137.4.camel@gmail.com> <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
 <1472747695.3137.7.camel@gmail.com> <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
 <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com> <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
 <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
 <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com> <1472827395.3713.6.camel@gmail.com>
 <9dee919a-0e81-5ba7-ddc6-7dcdb3a6b873@suse.com> <1472829630.3713.8.camel@gmail.com>
 <506f2875-8cea-2d99-3664-52ee546adcfd@suse.com> <1472846181.13263.2.camel@gmail.com>
 <CAJCQCtQDmhU92-Jw=QFALzuKpGL1VdEo5XbJ3ipKbambNqtaFg@mail.gmail.com> <1472854386.9717.7.camel@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 2 Sep 2016 16:39:25 -0600
Message-ID: <CAJCQCtSuCcd36zGcBYazhOPBVh4Ujg8WD0GR2vM2sFbTnFn1Jw@mail.gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
To: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Jeff Mahoney <jeffm@suse.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 2, 2016 at 4:13 PM, Ronan Arraes Jardim Chagas
<ronisbr@gmail.com> wrote:
> Hi!
>
> Em Sex, 2016-09-02 às 15:34 -0600, Chris Murphy escreveu:
>> Except for your software build case, I have about the same workload
>> you have with two machines, one SSD one HDD, using 4.7.0 for a month,
>> and then 4.7.2 for the last week. I haven't had any enospc on these
>> two systems.
>>
>> I think for you the path of least resistance that also permits
>> further
>> testing is to see if you can track down the leap 42.2 beta kernel
>> which is 4.4.19-1-default. I'm not easily finding that particular
>> one,
>> but I did find something a bit more recent:
>> http://download.opensuse.org/repositories/Kernel:/openSUSE-42.2/stand
>> ard/x86_64/
>
> Unfortunately, it will not be possible since my actual hardware depends
> on kernel >= 4.6 :(

Worth a shot, considering the opensuse/SLE 4.4 kernel has a shittonne
of backports. It seems unlikely to me opensuse intends to not support
your hardware (skylake?)



>
> Just now, I saw the problem again. For the first time, it happened
> twice in a small period. I was copying the e-mail from one IMAP server
> to my local HD. I use offlineimap, but this time it changed the backend
> to sqlite and started to create tons of database files, I think. My HDD
> IO stayed at 60/70% for a very long period.
>
> Hence, let's do a review of situations in which I saw the problem:
>
> 1) Local builds using `osc`;
> 2) During `zypper dup`;
> 3) When offlineimap created tons of database files;
> 4) During rsync-ing /home;
> 4) During usage of a virtual machine (the disk image was in an EXT4
> partition).

I don't think there's anything remarkable about any of these. And I
even do VM stuff on Btrfs. I also don't think it's the drive.

What it sounds like is possible, is the file system is now in some
kind of weird metadata state and it keeps tripping up on that. There
may be more than one bug going on, one that gets it into this state,
and then one that face plants with enospc when it's encountered.




-- 
Chris Murphy
