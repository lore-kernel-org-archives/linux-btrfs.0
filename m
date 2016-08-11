Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:35371 "EHLO
	mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbcHKHSL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Aug 2016 03:18:11 -0400
Received: by mail-qk0-f180.google.com with SMTP id v123so25189466qkh.2
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Aug 2016 00:18:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS3c5u6hDjHdU92AdQvSECNT99vOMxLiM4tchv4nrwPmA@mail.gmail.com>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
 <pan$d9b53$c31dc60$985cf806$b833643c@cox.net> <CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
 <CAGdWbB72DLAkV3EwO-7Sakc4gPHRT=GmU5ftxo0YfR0wjBefNQ@mail.gmail.com> <CAJCQCtS3c5u6hDjHdU92AdQvSECNT99vOMxLiM4tchv4nrwPmA@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Thu, 11 Aug 2016 10:18:09 +0300
Message-ID: <CAA91j0UG_EZjKPcLMk22ariPFD156bTOYjLX76gMR-XPLNU8fA@mail.gmail.com>
Subject: Re: checksum error in metadata node - best way to move root fs to new drive?
To: Chris Murphy <lists@colorremedies.com>
Cc: Dave T <davestechshop@gmail.com>, Duncan <1i5t5.duncan@cox.net>,
        Austin Hemmelgarn <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 11, 2016 at 1:23 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Wed, Aug 10, 2016 at 4:01 PM, Dave T <davestechshop@gmail.com> wrote:
>
>> I will be very disappointed if I cannot use btrfs + dm-crypt. As far
>> as I can see, there is no alternative given that I need to use
>> snapshots (and LVM, as good as it is, has severe performance penalties
>> for its snapshots).
>
> See LVM thin provisioning snapshots. I haven't benchmarked it, but
> it's a night and day difference from conventional (thick) snapshots.
> The gotchas are currently there's no raid support, and the snapshots
> are whole volume. So each snapshot appears as a volume with the same
> UUID as the original, and by default they're not active. So for me
> it's a bit of a head scratcher what happens when mounting a snapshot
> concurrent with another. For Btrfs this ends badly. For XFS it refuses
> unless using nouuid, but still seems capable of writing to the two
> volumes without causing problems.
>

XFS now allows changing UUID, as do LVM and MD. We can also change
btrfs UUID using "btrfstune -u", but I wonder if there is any way to
change device UUID in this case.

One problem is that even before you come around doing it various udev
rules kick in and create links to wrong instance overwriting previous
ones; and I'm not sure either xfs_admin or btrfstune trigger change
event. So we may end up with stale completely wrong links.
