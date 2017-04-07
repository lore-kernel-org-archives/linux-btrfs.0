Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:34935 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754281AbdDGBVG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Apr 2017 21:21:06 -0400
Received: by mail-yw0-f181.google.com with SMTP id d191so28384807ywe.2
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Apr 2017 18:21:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
References: <CAD4AmV5UPAKOohdMvGGbb7FV+EaToMg-kRX2rTJFB3NmwD0iwQ@mail.gmail.com>
 <CAD4AmV7jYAoUnr4BkGDtMx_sNN++wWsBFA3McLXq285UM7y5fw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 6 Apr 2017 19:21:05 -0600
Message-ID: <CAJCQCtQhcYYSoLoVE3i10De8V_CM9yGnMh4uzGsAZAczPfXerQ@mail.gmail.com>
Subject: Re: Volume appears full but TB's of space available
To: John Petrini <jpetrini@coredial.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 6, 2017 at 7:15 PM, John Petrini <jpetrini@coredial.com> wrote:
> Okay so I came across this bug report:
> https://bugzilla.redhat.com/show_bug.cgi?id=1243986
>
> It looks like I'm just misinterpreting the output of btrfs fi df. What
> should I be looking at to determine the actual free space? Is Free
> (estimated):   13.83TiB (min: 13.83TiB) the proper metric?
>
> Simply running df does not seem to report the usage properly
>
> /dev/sdj                      25T   11T  5.9T  65% /mnt/storage-array


Free should be correct. And df -h should be IEC units, so I'd expect
it to be closer to the value of btrfs fi us than this. But the code
has changed over time, I'm not sure when the last adjustment was made.

-- 
Chris Murphy
