Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35049 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753722AbdAFPQT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jan 2017 10:16:19 -0500
Received: by mail-lf0-f54.google.com with SMTP id m78so34391029lfg.2
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Jan 2017 07:15:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$bae57$81ae2edc$f6b8d81e$acf53525@cox.net>
References: <c0d145b6-6c81-ef52-4876-85eab927bae7@techsquare.com> <pan$bae57$81ae2edc$f6b8d81e$acf53525@cox.net>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Fri, 6 Jan 2017 17:15:42 +0200
Message-ID: <CAK5rZE7J2Awyy6FCm2VyNjE22-ckTetsO+9bCP-4cSsiRjiaeg@mail.gmail.com>
Subject: Re: kernel crash after upgrading to 4.9
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> I seem to have a similar issue to a subject in December:
>> Subject: page allocation stall in kernel 4.9 when copying files from one
>> btrfs hdd to another
>> In my case, this is caused when rsync'ing large amounts of data over NFS
>> to the server with the BTRFS file system.  This was not apparent in the
>> previous kernel (4.7).

As I browse through latest series of btrfs corruption/crash reports
I wonder which kernel version is reasonably safest to use.
4.7, 4.8 or 4.9 series?

What are your experiences and recommendations?
