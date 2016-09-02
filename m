Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36206 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932340AbcIBT42 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Sep 2016 15:56:28 -0400
Received: by mail-qk0-f174.google.com with SMTP id l2so131370387qkf.3
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2016 12:56:28 -0700 (PDT)
Message-ID: <1472846181.13263.2.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>, Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: Fri, 02 Sep 2016 16:56:21 -0300
In-Reply-To: <506f2875-8cea-2d99-3664-52ee546adcfd@suse.com>
References: <1471023419.16857.9.camel@gmail.com>
         <1472676550.8145.1.camel@gmail.com>
         <CAJCQCtR8EKENcy0ApONzDTX0RNZb8Dh-+_au4cMkyK24RzDoNw@mail.gmail.com>
         <CAJCQCtTWJMigkeLUP0+aTFPwdpuJtMa3C4isercAfE_Wh3b=PQ@mail.gmail.com>
         <52290114-3b37-2de5-9c9f-ceda6dff955b@suse.com>
         <CAJCQCtSPLw5Kwunm6WdhDCiE8Kc7BcfZy6W9veuns7kBmgyivw@mail.gmail.com>
         <a61878b9-7b88-7aee-40cf-05368cd01d78@suse.com>
         <CAJCQCtTBfhXOLg3URfreG29NVfujPjEc0O_cnDFCzDQm0iRtaA@mail.gmail.com>
         <1472734635.3137.4.camel@gmail.com>
         <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
         <1472747695.3137.7.camel@gmail.com>
         <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
         <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
         <b9bd0a3d-0ae0-a30c-c14d-c85434134890@gmail.com>
         <CAJCQCtT1RptgW-_esKmm2_5eRTxd10wHNxwgNWHSD86LZJ7edQ@mail.gmail.com>
         <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com>
         <1472827395.3713.6.camel@gmail.com>
         <9dee919a-0e81-5ba7-ddc6-7dcdb3a6b873@suse.com>
         <1472829630.3713.8.camel@gmail.com>
         <506f2875-8cea-2d99-3664-52ee546adcfd@suse.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi again guys!

After I rebooted the computer, I still can't run balance on metatada:

btrfs balance start -musage=1 /
ERROR: error during balancing '/': No space left on device
There may be more info in syslog - try dmesg | tail

dmesg shows:

[ 2022.530285] BTRFS info (device sda6): relocating block group
128509280256 flags 36
[ 2023.355206] BTRFS info (device sda6): relocating block group
127972409344 flags 36
[ 2024.265313] BTRFS info (device sda6): relocating block group
127435538432 flags 36
[ 2025.646712] BTRFS info (device sda6): relocating block group
126898667520 flags 36
[ 2026.794791] BTRFS info (device sda6): relocating block group
126361796608 flags 36
[ 2028.023517] BTRFS info (device sda6): relocating block group
125824925696 flags 36
[ 2028.881287] BTRFS info (device sda6): relocating block group
125288054784 flags 36
[ 2029.739342] BTRFS info (device sda6): relocating block group
124751183872 flags 36
[ 2030.631990] BTRFS info (device sda6): relocating block group
124214312960 flags 36
[ 2031.523176] BTRFS info (device sda6): relocating block group
123677442048 flags 36
[ 2032.407859] BTRFS info (device sda6): relocating block group
123140571136 flags 36
[ 2033.806672] BTRFS info (device sda6): relocating block group
122603700224 flags 36
[ 2035.237712] BTRFS info (device sda6): relocating block group
122066829312 flags 36
[ 2038.257268] BTRFS info (device sda6): relocating block group
122033274880 flags 34
[ 2039.911443] BTRFS info (device sda6): relocating block group
121496403968 flags 36
[ 2040.958106] BTRFS info (device sda6): relocating block group
120959533056 flags 36
[ 2041.841051] BTRFS info (device sda6): relocating block group
120422662144 flags 36
[ 2042.828359] BTRFS info (device sda6): relocating block group
119885791232 flags 36
[ 2044.297744] BTRFS info (device sda6): relocating block group
119348920320 flags 36
[ 2045.684932] BTRFS info (device sda6): relocating block group
118812049408 flags 36
[ 2046.761787] BTRFS info (device sda6): relocating block group
118275178496 flags 36
[ 2048.200756] BTRFS info (device sda6): relocating block group
117738307584 flags 36
[ 2049.806986] BTRFS info (device sda6): relocating block group
117201436672 flags 36
[ 2051.170470] BTRFS info (device sda6): relocating block group
116664565760 flags 36
[ 2051.910536] BTRFS info (device sda6): relocating block group
116127694848 flags 36
[ 2052.678395] BTRFS info (device sda6): relocating block group
115590823936 flags 36
[ 2053.737959] BTRFS info (device sda6): relocating block group
106363355136 flags 36
[ 2054.852065] BTRFS info (device sda6): relocating block group
105826484224 flags 36
[ 2055.911187] BTRFS info (device sda6): relocating block group
105222504448 flags 36
[ 2057.047407] BTRFS info (device sda6): 4 enospc errors during balance

and I have:

btrfs fi usage /
Overall:
    Device size:		   1.26TiB
    Device allocated:		  80.07GiB
    Device unallocated:		   1.18TiB
    Device missing:		     0.00B
    Used:			  41.95GiB
    Free (estimated):		   1.18TiB	(min: 603.95GiB)
    Data ratio:			      1.00
    Metadata ratio:		      2.00
    Global reserve:		 352.00MiB	(used: 576.00KiB)

Data,single: Size:40.01GiB, Used:39.95GiB
   /dev/sda6	  40.01GiB

Metadata,DUP: Size:20.00GiB, Used:1.00GiB
   /dev/sda6	  40.00GiB

System,DUP: Size:32.00MiB, Used:16.00KiB
   /dev/sda6	  64.00MiB

Unallocated:
   /dev/sda6	   1.18TiB

Hope this brings new information!

Best regards,
Ronan Arraes
