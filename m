Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:49538 "EHLO
        cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbeHXBEr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 21:04:47 -0400
Received: from cc-smtpin1.netcologne.de (cc-smtpin1.netcologne.de [89.1.8.201])
        by cc-smtpout2.netcologne.de (Postfix) with ESMTP id 55A4612953
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 23:33:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by cc-smtpin1.netcologne.de (Postfix) with ESMTP id 52D5411D70
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 23:33:08 +0200 (CEST)
Received: from [209.85.222.54] (helo=cc-smtpin1.netcologne.de)
        by localhost with ESMTP (eXpurgate 4.6.0)
        (envelope-from <s.schumacher@netcologne.de>)
        id 5b7f2814-5f8a-7f0000012729-7f0000018cea-1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 23:33:08 +0200
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by cc-smtpin1.netcologne.de (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 23:33:08 +0200 (CEST)
Received: by mail-ua1-f54.google.com with SMTP id r15-v6so4155282uao.1
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 14:33:08 -0700 (PDT)
MIME-Version: 1.0
From: Stefan Malte Schumacher <s.schumacher@netcologne.de>
Date: Thu, 23 Aug 2018 23:33:06 +0200
Message-ID: <CAA3ktq=WB7FUyLEmNy-jz8TUgVBaF0aUUXT4buAd8CoUbd3kJQ@mail.gmail.com>
Subject: Device Delete Stalls - Conclusion
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everybody,

first, let me thank everybody for their advice. What I did was close
the terminal with the device delete-process running in it and fired it
up again. It took about 5 minutes of intensive IO-Usage and the data
was redistributed and and the /dev/sda/ removed from the list of
drives. I am currently running a scrub, which I hope will find and
correct any errors caused by the forceful abort of the device delete
process. Many people suggested it: Next time I am going to replace one
of the older 4TB drives with a bigger one I will use "replace"
directly instead of "add/delete".

Yours sincerely
Stefan
