Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:36211 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756658AbdEKWY6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 18:24:58 -0400
Received: by mail-yw0-f170.google.com with SMTP id b68so3280333ywe.3
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 15:24:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2a289986-4740-72ae-7e7a-8264ed55b435@arcor.de>
References: <0e7ef6b4-7a81-fc66-942e-411f238d631e@arcor.de> <2a289986-4740-72ae-7e7a-8264ed55b435@arcor.de>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 11 May 2017 16:24:57 -0600
Message-ID: <CAJCQCtRNzJPNhMwRtha3Wf1WReDQvaXY=7CpZGW4M=mONLrLSQ@mail.gmail.com>
Subject: Re: Creating btrfs RAID on LUKS devs makes devices disappear
To: Ochi <ochi@arcor.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

journalctl -b -o short-monotonic > journal.log

And then attached the log, hopefully it's small enough to be accepted
by the list server (should be). If that's not revealing it might be
necessary to reboot with rd.udev.debug but start with the simple case
first and see if that reveals what's going on.



Chris Murphy
