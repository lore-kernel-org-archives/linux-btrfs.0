Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34059 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754675AbcIBT0B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Sep 2016 15:26:01 -0400
Received: by mail-qk0-f178.google.com with SMTP id t7so130325140qkh.1
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2016 12:26:01 -0700 (PDT)
Message-ID: <1472844353.3083.1.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>, Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: Fri, 02 Sep 2016 16:25:53 -0300
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

Hi guys!

Jeff was right. I had the problem again today and quotas are disabled
now. I couldn't get any useful message in log this time. Look at the
metadata:

btrfs fi usage /
Overall:
    Device size:		   1.26TiB
    Device allocated:		  43.07GiB
    Device unallocated:		   1.21TiB
    Device missing:		     0.00B
    Used:			  41.94GiB
    Free (estimated):		   1.21TiB	(min: 622.46GiB)
    Data ratio:			      1.00
    Metadata ratio:		      2.00
    Global reserve:		 352.00MiB	(used: 0.00B)

Data,single: Size:40.01GiB, Used:39.94GiB
   /dev/sda6	  40.01GiB

Metadata,DUP: Size:1.50GiB, Used:1.00GiB
   /dev/sda6	   3.00GiB

System,DUP: Size:32.00MiB, Used:16.00KiB
   /dev/sda6	  64.00MiB

Unallocated:
   /dev/sda6	   1.21TiB

Any ideas to help me?

Regards,
Ronan Arraes
