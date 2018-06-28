Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:46964 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966628AbeF1WE0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 18:04:26 -0400
Received: by mail-oi0-f43.google.com with SMTP id y207-v6so6630669oie.13
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 15:04:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <29e89355-2e35-8f2b-51ab-776f41fc2c70@georgianit.com>
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com>
 <9bbde3a8-2498-a538-5744-c857f5a57947@oracle.com> <CAJCQCtSuKpcn2Or3LiCYqeFMFFoRU09BFQE_n8FAhQ2Vo+83PA@mail.gmail.com>
 <29e89355-2e35-8f2b-51ab-776f41fc2c70@georgianit.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 28 Jun 2018 16:04:25 -0600
Message-ID: <CAJCQCtR1Jgn7656vDebiBn-wRKOMqB7VdiZf_QoG30mLg+LHKA@mail.gmail.com>
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: Remi Gauvin <remi@georgianit.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 28, 2018 at 9:37 AM, Remi Gauvin <remi@georgianit.com> wrote:
> On 2018-06-28 10:17 AM, Chris Murphy wrote:
>
>> 2. The new data goes in a single chunk; even if the user does a manual
>> balance (resync) their data isn't replicated. They must know to do a
>> -dconvert balance to replicate the new data. Again this is a net worse
>> behavior than mdadm out of the box, putting user data at risk.
>
> I'm not sure this is the case.  Even though writes failed to the
> disconnected device, btrfs seemed to keep on going as though it *were*.

Yeah in your case the failure happens during normal operation and in
that case there's no degraded state on Btrfs. So it keeps writing to
raid1 chunk on the working drive, with writes on the failed devices
going nowhere (with lots of write errors). When you stop using the
volume, fix the problem with the missing drive, then remount the
volume, it really should still use only the new copy on the never
missing drive, even though it won't necessarily notice the file is
missing on the formerly missing drive. You have to balance manually to
fix it.


> When the array was re-mounted with both devices, (never mounted as
> degraded), and scrub was run, scrub took a *long* time fixing errors, at
> a whopping 3MB/s, and reported having fixed millions of them.

That's slow but it's expected to fix a lot of problems. Even in a very
short amount of time there are thousands of missing data and metadata
extents that need to be replicated.




-- 
Chris Murphy
