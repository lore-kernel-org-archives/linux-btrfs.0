Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg1-f180.google.com ([209.85.215.180]:39421 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728024AbeIMVZs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 17:25:48 -0400
Received: by mail-pg1-f180.google.com with SMTP id i190-v6so2974713pgc.6
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2018 09:15:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAPqC6xR1rbNqpPUUxU2OyvtCHoD2LOywE5cRDtNTbqJ2=5e_nQ@mail.gmail.com>
 <e107e504-ee53-8879-23c2-9fc8cfe7c755@suse.com>
In-Reply-To: <e107e504-ee53-8879-23c2-9fc8cfe7c755@suse.com>
From: Serhat Sevki Dincer <jfcgauss@gmail.com>
Date: Thu, 13 Sep 2018 19:15:21 +0300
Message-ID: <CAPqC6xROL93b5DOrNPaNSZahVKYqSpg0-84DgHsFTQZtHVdnRg@mail.gmail.com>
Subject: Re: btrfs convert problem
To: nborisov@suse.com
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -1 seems to be EPERM, is your device write-protected, readonly or
> something like that ?

I am able to use ext4 partition read/write, created a file and wrote
in it, un/re mounted it, all is ok.
The drive only has a microusb port and a little led light; no rw
switch or anything like that..
