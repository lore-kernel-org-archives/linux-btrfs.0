Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:34046 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932109AbdDGBPy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Apr 2017 21:15:54 -0400
Received: by mail-it0-f43.google.com with SMTP id y18so1814667itc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Apr 2017 18:15:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
From: John Petrini <jpetrini@coredial.com>
Date: Thu, 6 Apr 2017 21:15:52 -0400
Message-ID: <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
Subject: Re: Volume appears full but TB's of space available
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Okay so I came across this bug report:
https://bugzilla.redhat.com/show_bug.cgi?id=1243986

It looks like I'm just misinterpreting the output of btrfs fi df. What
should I be looking at to determine the actual free space? Is Free
(estimated):   13.83TiB (min: 13.83TiB) the proper metric?

Simply running df does not seem to report the usage properly

/dev/sdj                      25T   11T  5.9T  65% /mnt/storage-array

Thank you,

John Petrini
