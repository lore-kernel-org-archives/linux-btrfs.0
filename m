Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:38432 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753268AbcJKWL1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 18:11:27 -0400
Received: by mail-it0-f42.google.com with SMTP id o19so35630868ito.1
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2016 15:10:39 -0700 (PDT)
Date: Tue, 11 Oct 2016 18:10:31 -0400
From: Nicholas D Steeves <nsteeves@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Charles Zeitler <cfzeitler@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: raid levels and NAS drives
Message-ID: <20161011221031.GB5515@DigitalMercury.dynalias.net>
References: <CAB9fVVH6S-Y0Li=6xyw2P23CEPwVRA6hRbjJNi+_3etHnqMh1w@mail.gmail.com>
 <c7e8a508-1e55-4049-1e9e-63942f80d030@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c7e8a508-1e55-4049-1e9e-63942f80d030@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 10, 2016 at 08:07:53AM -0400, Austin S. Hemmelgarn wrote:
> On 2016-10-09 19:12, Charles Zeitler wrote:
> >Is there any advantage to using NAS drives
> >under RAID levels,  as oppposed to regular
> >'desktop' drives for BTRFS?
[...]
> So, as for what you should use in a RAID array, here's my specific advice:
> 1. Don't worry about enterprise drives unless you've already got a system
> that has them.  They're insanely overpriced for relatively minimal benefit
> when compared to NAS drives.
> 2. If you can afford NAS drives, use them, they'll get you the best
> combination of energy efficiency, performance, and error recovery.
> 3. If you can't get NAS drives, most desktop drives work fine, but you will
> want to bump up the scsi_command_timer attribute in the kernel for them (200
> seconds is reasonable, just make sure you have good cables and a good
> storage controller).
> 4. Avoid WD Green drives, without special effort, they will get worse
> performance and have shorter lifetimes than any other hard disk I've ever
> seen.
> 5. Generally avoid drives with a capacity over 1TB from manufacturers other
> than WD, HGST, and Seagate, most of them are not particularly good quality
> (especially if it's an odd non-power-of-two size like 5TB).

+1 !  Additionally, is it still the case that it is generally safer to
buy the largest capacity disks offered by the previous generation of
technology rather than the current largest capacity?  eg: right now
that would be 4TB or 6TB, and not 8TB or 10TB.

Cheers,
Nicholas
