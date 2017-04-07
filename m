Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:33420 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753115AbdDGBbh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Apr 2017 21:31:37 -0400
Received: by mail-io0-f180.google.com with SMTP id t68so7486080iof.0
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Apr 2017 18:31:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com> <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
From: John Petrini <jpetrini@coredial.com>
Date: Thu, 6 Apr 2017 21:31:36 -0400
Message-ID: <CAD4AmV5PmFHW5Hm-K50g1e3ahWjkD8=d-FtOaBpcvDNO4u+M=g@mail.gmail.com>
Subject: Re: Volume appears full but TB's of space available
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

I've followed your advice and converted the system chunk to raid10. I
hadn't noticed it was raid0 and it's scary to think that I've been
running this array for three months like that. Thank you for saving me
a lot of pain down the road!

Also thank you for the clarification on the output - this is making a
lot more sense.

Regards,

John Petrini
