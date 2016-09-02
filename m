Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:34302 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753364AbcIBOn0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Sep 2016 10:43:26 -0400
Received: by mail-qt0-f178.google.com with SMTP id 38so20126962qte.1
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Sep 2016 07:43:26 -0700 (PDT)
Message-ID: <1472827395.3713.6.camel@gmail.com>
Subject: Re: BTRFS constantly reports "No space left on device" even with a
 huge unallocated space
From: Ronan Arraes Jardim Chagas <ronisbr@gmail.com>
To: Jeff Mahoney <jeffm@suse.com>, Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: Fri, 02 Sep 2016 11:43:15 -0300
In-Reply-To: <d1319d2e-3016-7eef-5f3f-87677600e13c@suse.com>
References: <1471023419.16857.9.camel@gmail.com>
         <1472485953.3290.0.camel@gmail.com> <57C4EB85.7030000@cn.fujitsu.com>
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
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff,

Em Sex, 2016-09-02 às 10:26 -0400, Jeff Mahoney escreveu:
> I explained what I think Ronan's issue is in another part of the
> thread
> just now.  I don't think that's a severe issue at
> all.  Annoying?  Sure,
> but I'm more concerned with the underlying ENOSPC issue.  Without
> more
> info, I don't know what the cause of it is and when it was
> introduced.

Sorry, but I really need to humbly disagree with you. Look to what has
already happened to me when the problem occurred (which is almost every
day):

1) Firefox crash;
2) Libreoffice crash (auto-save stop working);
3) Can't save my work in any text editor (vim, neovim, gedit, etc.);
4) Sometimes I can't even log as root (in TTY or by `su`);
5) Sometimes only a hard-reset solves the problem;
6) I was left with a broken operational system when the problem
occurred during a `zypper dup`.

I just can't tell you how much work I lost during those situations. So,
I think we cannot call this issue just annoying. I think it is very
severe.

Best regards,
Ronan Arraes
