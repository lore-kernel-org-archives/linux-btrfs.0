Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:35640 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934455AbcIAQfP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 12:35:15 -0400
Received: by mail-qk0-f172.google.com with SMTP id v123so90725895qkh.2
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Sep 2016 09:35:04 -0700 (PDT)
Message-ID: <1472747695.3137.7.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>, Jeff Mahoney <jeffm@suse.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: Thu, 01 Sep 2016 13:34:55 -0300
In-Reply-To: <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
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
         <1472734635.3137.4.camel@gmail.com>
         <0778dff0-cb43-d279-adb2-0e314b61110d@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Em Qui, 2016-09-01 às 09:21 -0400, Austin S. Hemmelgarn escreveu:
> Yes, you can just run `btrfs quota disable /` and it should
> work.  This 
> ironically reiterates that one of the bigger problems with BTRFS is
> that 
> distros are enabling unstable and known broken features by default
> on 
> install.  I was pretty much dumbfounded when I first learned that 
> OpenSUSE is enabling BTRFS qgroups by default since they are known
> to 
> not work reliably and cause all kinds of issues.

Thanks Austin! I executed the command and now I get:

btrfs qgroup show /
ERROR: can't perform the search - No such file or directory
ERROR: can't list qgroups: No such file or directory

as expected. Now I will wait for +- 1 week to see if the problem will
occur and, if not, I will send an e-mail to openSUSE factory mailing
list to start a discussion if it is better to not enable qgroups by
default.

Best regards and thanks everyone for the help,
Ronan Arraes
