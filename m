Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:33244 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753990AbcIAVAH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Sep 2016 17:00:07 -0400
Received: by mail-ua0-f176.google.com with SMTP id l94so161588560ual.0
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Sep 2016 14:00:07 -0700 (PDT)
Message-ID: <1472752723.3137.21.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: Thu, 01 Sep 2016 14:58:43 -0300
In-Reply-To: <416ba17a-24ad-9dd2-3513-31a8600850b0@suse.com>
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
         <1472747695.3137.7.camel@gmail.com>
         <b0ec9154-16a5-5293-952a-0d5a988488e8@gmail.com>
         <ab83503e-58c5-e1b4-b1ba-1e1ea8313607@suse.com>
         <1472751548.3137.9.camel@gmail.com>
         <416ba17a-24ad-9dd2-3513-31a8600850b0@suse.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff,

Em Qui, 2016-09-01 às 13:43 -0400, Jeff Mahoney escreveu:
> Absolutely.  It doesn't affect the ability to take, retain, or
> recover
> using snapshots.  It only affects the ability to see how much space a
> particular snapshot is using on disk, both from the user wanting to
> know
> and snapper using it to make retention decisions.  Snapper can handle
> qgroups not being there.
> 

Thanks for the prompt answer. I'm glad because space is not a concern
here, at least now :) Hence, I have plenty time to wait for a proper
fix. Until there, I will try to keep my snapshot count low.
