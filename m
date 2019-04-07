Return-Path: <SRS0=Yn0v=SJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6D7C10F0E
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 18:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D01920896
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Apr 2019 18:45:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="xE4bENKN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbfDGSp2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Apr 2019 14:45:28 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:37961 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbfDGSp2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Apr 2019 14:45:28 -0400
Received: by mail-lj1-f176.google.com with SMTP id p14so9248342ljg.5
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Apr 2019 11:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=BlOHComsFKrWS4op23qzULI6FEyqII1OXnwUUAxioq4=;
        b=xE4bENKNNhY07q8+58laCMyN2w8jqDIS7czrESPKHgwifYRyAJ9L9UcahkOWCXbNEP
         51Vow4j8/Ak9lgvw9zKLbSezEaioWxLFl7/PPk1Bdlq55gH+XgEC0kl0W2Jbpr8qKmLs
         yRsP3HitOUARS0U0t1tCFBjCPvpIM06eJZCbOAInF0gL/KInLDAThW9jxql2irKNcXe3
         y0kub6b3ZOMQf06w5sf6INQCwUNSsoGNu6Q9WF4HCTrZFr8zl94EbPkrXk82nhtDtykH
         8S4p2BdYph7muwc7Nbo1wSQtEfMMiTS+amO2GuuaD2ullqAaQyZlTzGDBTfHRmzfZnuc
         H/Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=BlOHComsFKrWS4op23qzULI6FEyqII1OXnwUUAxioq4=;
        b=SGw3rHYNdcYN4Gbe8+vtbPSYh09fZHNSrYqWIglXNUBMLZBcEn5GtFuWehLj8jJc1e
         wzF73hzEoqLfBGxJmgZ7gBC2bLVMgq8khO0uAiQ2wiQE1mDSJj1bq6T7c/Qmsbhk+gJg
         o0wAfPrnSUODbetu0Bk0VWcw/83iX0Uz3X2LHRx1/j4SnbhaFVWwPsaP0w8zDY4BkbW0
         2gE+ikOD5HNmJhDOknQPTiB7m+PiVFL5CfDxYtyC9df2tO6bSjTkmAgjYA7YwuU6/thn
         I+rWhxBQ2coCnp6YuKg+UvZDGjmoC/z/SpPvF8JMZvoZ9nbeZtGca9dLUQhAtDO0trEZ
         0GXw==
X-Gm-Message-State: APjAAAUUUw/pG0HvnfENvbqqKtk/dU2twG+LteGbo8vDL3miSw+HfGuI
        5TcKp5A0j22KIGse19idYvpJ5sBTw5/7XcbXh/bWjg==
X-Google-Smtp-Source: APXvYqwZbEmj5FqBq6CVQlAQGtJu11Lu28vnuTdGUCIXabniD98wX4iBk92rwOMlc55uUa1XDuVbUzLBE0IJPhZVoRo=
X-Received: by 2002:a2e:7e0f:: with SMTP id z15mr13601256ljc.122.1554662726408;
 Sun, 07 Apr 2019 11:45:26 -0700 (PDT)
MIME-Version: 1.0
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <9a800f8e-a8eb-ea5c-328b-7aed53bc3742@avgustinov.eu> <edbb548a-75e8-0b9e-914f-684aa6b4a5ea@gmx.com>
 <7d605543-2899-144a-7b46-7caed803b43b@avgustinov.eu> <8fdb5da5-d649-0c0d-1a21-c3f430476afd@gmx.com>
 <ce8be6b2-1a2f-201f-a4ff-03686b3620f1@avgustinov.eu> <3dcaf6ae-34c4-3760-70f9-6ce2962b42c8@gmx.com>
 <e9720559-eff2-e88b-12b4-81defb8c29c5@avgustinov.eu> <a75981da-86f7-e0fb-d1dc-a2576b09c668@gmx.com>
 <039ec3eb-c44e-35e9-cf1b-f9f75849d873@avgustinov.eu> <c69778f5-a015-8b77-3fab-e41e49a0e0db@gmx.com>
 <51021dd7-b21b-b001-c3f9-9bc31205738b@avgustinov.eu> <00e3ddf1-cbd7-a65a-dee3-ca720cecc77d@gmx.com>
 <a6917f39-eeb4-5548-f346-a78972c7c3fe@avgustinov.eu> <6a592ffa-4a5a-81af-baef-8f1681accc87@gmx.com>
 <2c786019-646a-486f-1306-25a3df36e6b3@avgustinov.eu> <52b23bd7-108b-63f3-b958-2a5959c7ca6e@gmx.com>
 <f2b33d93-aa37-9fd3-6036-44e1e3f065eb@avgustinov.eu> <a9135dba-26fe-777f-048b-87052d5cbd14@gmx.com>
 <21ff2435-af15-573c-e897-05ceb4f42e0b@avgustinov.eu>
In-Reply-To: <21ff2435-af15-573c-e897-05ceb4f42e0b@avgustinov.eu>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sun, 7 Apr 2019 12:45:15 -0600
Message-ID: <CAJCQCtQJkJwEyouCUzcV1MzPkcxhvtqxkWqmrwnB9txV=MUTXA@mail.gmail.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     "Nik." <btrfs@avgustinov.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Apr 7, 2019 at 1:42 AM Nik. <btrfs@avgustinov.eu> wrote:
> 2019-04-07 01:18, Qu Wenruo:

> > You have 2 bits flipped just in one tree block!
> >
> If the data-tree structures alone have so many bits flipped, how much
> flipped bits are to be expected in the data itself? What should a normal
> btrfs user do in order to prevent such disasters?

I think the corruption in your case is inferred by Btrfs only by bad
key ordering, not csum failure for the leaf? I can't tell for sure
from the error, but I don't see a csum complaint.

I'd expect a RAM caused corruption could affect a metadata leaf data,
followed by csum computation. Therefore no csum failure on subsequent
read. Whereas if the corruption is storage stack related, we'd see a
csum error on subsequent read.

Once there's corruption in a block address, the corruption can
propagate into anything else that depends on that block address even
if there isn't another corruption event. So one event, multiple
corruptions.


> And another thing: if I am getting it right, it should have been more
> reliable/appropriate to let btrfs manage the five disks behind the md0
> with a raid1 profile instead binding them in a RAID5 and "giving" just a
> single device to btrfs.

Not necessarily. If corruption happens early enough, it gets baked
into all copies of the metadata.


-- 
Chris Murphy
