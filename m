Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:41733 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbeBYGrr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Feb 2018 01:47:47 -0500
Received: by mail-oi0-f49.google.com with SMTP id g5so2407920oiy.8
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Feb 2018 22:47:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACzgC9j7uNqDGc8W2cLRb-9kGmf=DCqS3_jLLZuFOwdmVPeuQg@mail.gmail.com>
References: <CACzgC9j7uNqDGc8W2cLRb-9kGmf=DCqS3_jLLZuFOwdmVPeuQg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 24 Feb 2018 23:47:46 -0700
Message-ID: <CAJCQCtQC=FrQuya5VU2v_=VetviHLh45d6QK24FqzOKjEYPW0g@mail.gmail.com>
Subject: Re: csum failed error messages
To: Adam Bahe <adambahe@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like they're already fixed:

[Sat Feb 24 06:04:54 2018] BTRFS info (device sde): read error
corrected: ino 181466 off 114257920 (dev /dev/sdi sector 5332484024)


Question is why there's bad data. You can use 'btrfs dev stats' to
show the errors on all devices. If the errors are fairly distributed,
it could be memory related but usually it'll affect both copies, which
isn't the case here. So I think probably it's a device stack problem:
cable, controller, drive, vibration, something like that.


---
Chris Murphy
