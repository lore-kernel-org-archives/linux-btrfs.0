Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36792 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933805AbcHJWX1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Aug 2016 18:23:27 -0400
Received: by mail-oi0-f44.google.com with SMTP id f189so78435541oig.3
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Aug 2016 15:23:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGdWbB72DLAkV3EwO-7Sakc4gPHRT=GmU5ftxo0YfR0wjBefNQ@mail.gmail.com>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
 <pan$d9b53$c31dc60$985cf806$b833643c@cox.net> <CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
 <CAGdWbB72DLAkV3EwO-7Sakc4gPHRT=GmU5ftxo0YfR0wjBefNQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 10 Aug 2016 16:23:20 -0600
Message-ID: <CAJCQCtS3c5u6hDjHdU92AdQvSECNT99vOMxLiM4tchv4nrwPmA@mail.gmail.com>
Subject: Re: checksum error in metadata node - best way to move root fs to new drive?
To: Dave T <davestechshop@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Duncan <1i5t5.duncan@cox.net>,
        Austin Hemmelgarn <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 10, 2016 at 4:01 PM, Dave T <davestechshop@gmail.com> wrote:

> I will be very disappointed if I cannot use btrfs + dm-crypt. As far
> as I can see, there is no alternative given that I need to use
> snapshots (and LVM, as good as it is, has severe performance penalties
> for its snapshots).

See LVM thin provisioning snapshots. I haven't benchmarked it, but
it's a night and day difference from conventional (thick) snapshots.
The gotchas are currently there's no raid support, and the snapshots
are whole volume. So each snapshot appears as a volume with the same
UUID as the original, and by default they're not active. So for me
it's a bit of a head scratcher what happens when mounting a snapshot
concurrent with another. For Btrfs this ends badly. For XFS it refuses
unless using nouuid, but still seems capable of writing to the two
volumes without causing problems.

But yes, I like Btrfs snapshots and refinks better. *shrug*

If you find a Btrfs on dmcrypt problem, it's a serious bug, and I
think it would get attention very quickly.


-- 
Chris Murphy
