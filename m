Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:34200 "EHLO
	mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbcHKOMF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Aug 2016 10:12:05 -0400
Received: by mail-qt0-f174.google.com with SMTP id u25so2556879qtb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Aug 2016 07:12:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGdWbB7qNFfKy1C3Ldb8aSCxvphZeYcmrXtdiB_ECGXNLZ-K5w@mail.gmail.com>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
 <pan$d9b53$c31dc60$985cf806$b833643c@cox.net> <CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
 <CAGdWbB72DLAkV3EwO-7Sakc4gPHRT=GmU5ftxo0YfR0wjBefNQ@mail.gmail.com>
 <CAJCQCtS3c5u6hDjHdU92AdQvSECNT99vOMxLiM4tchv4nrwPmA@mail.gmail.com> <CAGdWbB7qNFfKy1C3Ldb8aSCxvphZeYcmrXtdiB_ECGXNLZ-K5w@mail.gmail.com>
From: Nicholas D Steeves <nsteeves@gmail.com>
Date: Thu, 11 Aug 2016 10:12:04 -0400
Message-ID: <CAD=QJKjZP3V3HE_iXYcLJvq65mXKiXp_aYgZuoHmQFd7mJ7j0Q@mail.gmail.com>
Subject: Re: checksum error in metadata node - best way to move root fs to new drive?
To: Dave T <davestechshop@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Duncan <1i5t5.duncan@cox.net>,
        Austin Hemmelgarn <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Why is the combination of dm-crypt|luks+btrfs+compress=lzo as
overlooked as a potential cause?  Other than the "raid56 ate my data"
I've noticed a bunch of "luks+btrfs+compress=lzo ate my data" threads.

On 10 August 2016 at 15:46, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
>
> As far as dm-crypt goes, it looks like BTRFS is stable on top in the
> configuration I use (aex-xts-plain64 with a long key using plain dm-crypt
> instead of LUKS).  I have heard rumors of issues when using LUKS without
> hardware acceleration, but I've never seen any conclusive proof, and what
> little I've heard sounds more like it was just race conditions elsewhere
> causing the issues.
>

Austin, I'm very curious if they were also using compress=lzo, because
my informal hypothesis is that the encryption+btrfs+compress=lzo
combination precipitates these issues.  Maybe the combo is more likely
to trigger these race conditions?  It might also be neat to mine the
archive to see these seem to be more likely to occur with fast SSDs vs
slow rotational disks.  Do you use compress=lzo?

On 10 August 2016 at 18:52, Dave T <davestechshop@gmail.com> wrote:
> On Wed, Aug 10, 2016 at 5:15 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
>> 1. Report 'btrfs check' without --repair, let's see what it complains
>> about and if it might be able to plausibly fix this.
>
> First, a small part of the dmesg output:
>
> [  172.772283] Btrfs loaded
> [  172.772632] BTRFS: device label top_level devid 1 transid 103495 /dev/dm-0
> [  274.320762] BTRFS info (device dm-0): use lzo compression

Compress=lzo confirmed.  Corruption occurred on an SSD.

On 10 August 2016 at 17:21, Chris Murphy <lists@colorremedies.com> wrote:
> I'm using LUKS, aes xts-plain64, on six devices. One is using mixed-bg
> single device. One is dsingle mdup. And then 2x2 mraid1 draid1. I've
> had zero problems. The two computers these run on do have aesni
> support. Aging wise, they're all at least a  year old. But I've been
> using Btrfs on LUKS for much longer than that.
>

Chris, do you use compress=lzo?  SSDs or rotational disks?

If a bunch of people are using this combo without issue, I'll drop the
informal hypothesis as "just a suspicion informed by sloppy pattern
recognition" ;-)

Thank you!
Nicholas
