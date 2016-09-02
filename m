Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:33799 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932236AbcIBPUk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Sep 2016 11:20:40 -0400
Received: by mail-qt0-f170.google.com with SMTP id 38so20821762qte.1
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2016 08:20:40 -0700 (PDT)
Message-ID: <1472829630.3713.8.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>, Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: Fri, 02 Sep 2016 12:20:30 -0300
In-Reply-To: <9dee919a-0e81-5ba7-ddc6-7dcdb3a6b873@suse.com>
References: <1471023419.16857.9.camel@gmail.com>
         <1472561404.3179.3.camel@gmail.com>
         <CAJCQCtTn6y1Qy5J_Wuef-bbwJ9g50NgM-a2UtWvh=01S_JntKA@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff,

Em Sex, 2016-09-02 às 10:48 -0400, Jeff Mahoney escreveu:
> Sorry, I miscommunicated there.  The WARN_ON is annoying.  It's the
> underlying issue that's causing you to lose work that is the one that
> concerns me.
> 

Oh, OK, I see, sorry about that :)

Thus, if disabling quotas does not help to fix my problem, is there any
workaround you can think of to avoid the problem you suggested in the
previous e-mail?

Best regards,
Ronan Arraes
