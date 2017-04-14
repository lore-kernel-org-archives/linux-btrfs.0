Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:34528 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbdDNQ6G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Apr 2017 12:58:06 -0400
Received: by mail-yw0-f179.google.com with SMTP id k13so37470503ywk.1
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Apr 2017 09:58:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSc42UVczbDvVfWBma4eeoAMHRQJMX0vbSMt9yE4nPjeg@mail.gmail.com>
References: <CAFKQ2Bs9-=serb7F-PHDVNQ-X2AXcWPG5jBs9xKXTKkTQ59O7Q@mail.gmail.com>
 <CAJCQCtSc42UVczbDvVfWBma4eeoAMHRQJMX0vbSMt9yE4nPjeg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 14 Apr 2017 10:58:04 -0600
Message-ID: <CAJCQCtSVmsiP9rTw0aap0=EO=w1pb8r4D4kUjJrEy8MPBMrwig@mail.gmail.com>
Subject: Re: Encountered kernel bug#72811. Advice on recovery?
To: Chris Murphy <lists@colorremedies.com>
Cc: Ank Ular <ankular.anime@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 14, 2017 at 10:46 AM, Chris Murphy <lists@colorremedies.com> wrote:

>
> The passive repair works when it's a few bad sectors on the drive. But
> when it's piles of missing data, this is the wrong mode. It needs a
> limited scrub or balance to fix things. Right now you have to manually
> do a full scrub or balance after you've mounted for even one second
> using degraded,rw. That's why you want to avoid it at all costs.


Small clarification on "right now you have to manually do"

I don't mean YOU personally, with your array. I mean, anyone who
happens to have done even the tiniest amount of writes to a Btrfs
volume while mounted in rw,degraded. Once a new device is added and
the bad/missing device deleted, you still have to manually do a scrub
or balance of the entire array. That's the only way to fix up the
array back to normal. It's not automatic.

The way to avoid this is to *immediately* before any new writes, do a
device add and device delete missing*. That prevents any degraded
chunks from being written.



* ON non-raid56 volumes, you can use 'btrfs replace'.



-- 
Chris Murphy
