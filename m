Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:33728 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbcIANCo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 09:02:44 -0400
Received: by mail-qk0-f170.google.com with SMTP id z190so83756082qkc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Sep 2016 06:02:43 -0700 (PDT)
Message-ID: <1472734635.3137.4.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Chris Murphy <lists@colorremedies.com>, Jeff Mahoney <jeffm@suse.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: Thu, 01 Sep 2016 09:57:15 -0300
In-Reply-To: <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
References: <1471023419.16857.9.camel@gmail.com>
         <57C426AB.3020607@cn.fujitsu.com> <1472485953.3290.0.camel@gmail.com>
         <57C4EB85.7030000@cn.fujitsu.com> <1472561404.3179.3.camel@gmail.com>
         <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
         <1472676550.8145.1.camel@gmail.com>
         <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
         <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
         <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
         <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
         <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
         <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Em Qua, 2016-08-31 às 17:09 -0600, Chris Murphy escreveu:
> OK so Ronan, I'm gonna guess the simplest work around for your
> problem
> is to disable quota support, and see if the problem happens again.
> 

Look at the output of the command proposed by Jeff:

btrfs qgroup show /
qgroupid         rfer         excl 
--------         ----         ---- 
0/5          16.00KiB     16.00KiB 
0/257        16.00KiB     16.00KiB 
0/258        16.30MiB     16.30MiB 
0/259        11.65GiB    309.67MiB 
0/260         2.34MiB      2.34MiB 
0/261        16.00KiB     16.00KiB 
0/262        13.19GiB     13.19GiB 
0/263        16.00KiB     16.00KiB 
0/264        60.00KiB     60.00KiB 
0/265       480.00KiB    480.00KiB 
0/266        16.00KiB     16.00KiB 
0/267         2.00GiB      2.00GiB 
0/268        16.00KiB     16.00KiB 
0/269        16.00KiB     16.00KiB 
0/270        16.00KiB     16.00KiB 
0/271        16.00KiB     16.00KiB 
0/272        16.00KiB     16.00KiB 
0/273        16.00KiB     16.00KiB 
0/274        16.00KiB     16.00KiB 
0/275       205.78MiB    205.78MiB 
0/276        16.00KiB     16.00KiB 
0/277        48.00KiB     48.00KiB 
0/278       328.41MiB    328.41MiB 
0/283         3.92GiB     26.63MiB 
0/285         3.93GiB      4.10MiB 
0/294         7.84GiB    100.59MiB 
0/330         7.98GiB      6.61MiB 
0/332         8.32GiB     69.17MiB 
0/353         9.53GiB     49.46MiB 
0/355        10.51GiB    235.39MiB 
0/415        11.54GiB      3.38MiB 
0/416        11.54GiB    896.00KiB 
0/417        11.57GiB      2.68MiB 
0/418        11.57GiB    160.00KiB 
0/419        11.54GiB      2.40MiB 
0/420        11.54GiB    192.00KiB 
0/421        11.62GiB      4.61MiB 
0/422        11.83GiB    212.93MiB 
0/427        11.64GiB      1.27MiB 
0/428        11.65GiB      4.25MiB 
1/0          16.11GiB      4.77GiB 
255/262      13.19GiB     13.19GiB 

This system was installed with Tumbleweed ISO and I did not change
anything in btrfs options. Hence, it seems that openSUSE is enabling
quotas by default. Now, I need to disable it and avoid triggering the
problem. What is the best way I can do this? Is it OK to do just:

btrfs quota disable /

? Or do I need to format and recreate btrfs without quotas?

> If it doesn't happen again then it sounds like the reproduce steps
> are:
> 
> a. enable quota support
> b. do something metadata heavy workload that's also maybe hitting
> fsync; from opensuse list the example that sometimes causes it:
> 
> 
>   osc co home:Ronis_BR/julia
>   cd home:Ronis_BR/julia
>   osc build --root=`pwd`/jail openSUSE_Tumbleweed x86_64
> 
> I wonder if it's easier to hit it on a hard drive, slower fsyncs?

This sounds good! Actually, I'm using a 7200RPM hard driver.

Thank you all very much for all the help,
Ronan Arraes
