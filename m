Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:35705 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209AbcHKUdK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Aug 2016 16:33:10 -0400
Received: by mail-oi0-f48.google.com with SMTP id 4so9693849oih.2
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Aug 2016 13:33:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD=QJKjZP3V3HE_iXYcLJvq65mXKiXp_aYgZuoHmQFd7mJ7j0Q@mail.gmail.com>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
 <pan$d9b53$c31dc60$985cf806$b833643c@cox.net> <CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
 <CAGdWbB72DLAkV3EwO-7Sakc4gPHRT=GmU5ftxo0YfR0wjBefNQ@mail.gmail.com>
 <CAJCQCtS3c5u6hDjHdU92AdQvSECNT99vOMxLiM4tchv4nrwPmA@mail.gmail.com>
 <CAGdWbB7qNFfKy1C3Ldb8aSCxvphZeYcmrXtdiB_ECGXNLZ-K5w@mail.gmail.com> <CAD=QJKjZP3V3HE_iXYcLJvq65mXKiXp_aYgZuoHmQFd7mJ7j0Q@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 11 Aug 2016 14:33:08 -0600
Message-ID: <CAJCQCtTF-YcDW8QzNFw4db3XyVWb3urvQ8VaAMbRUbhBy6k1QQ@mail.gmail.com>
Subject: Re: checksum error in metadata node - best way to move root fs to new drive?
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: Dave T <davestechshop@gmail.com>, Chris Murphy <lists@colorremedies.com>,
        Duncan <1i5t5.duncan@cox.net>,
        Austin Hemmelgarn <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 11, 2016 at 8:12 AM, Nicholas D Steeves <nsteeves@gmail.com> wrote:

>
> Chris, do you use compress=lzo?  SSDs or rotational disks?

No compression, SSD and HDD. The stuff I care about is on dmcrypt
(LUKS) for some time. Stuff I sorta care about on plain partitions.
Stuff I don't care much about are either on LVM LV's (usually thinp),
or qcow2.

I have used compression for periods measured in months not years, both
zlib and lzo, on both SSD and HDD, to no ill effect. But it's true
some of the more abrupt and worse damaged file systems did use
compress=lzo. Since lzo is faster and only a bit less better
compression than zlib, it may be more people choose lzo and that's why
it turns out if there's a problem with compression it happens to be
lzo, coincidence rather than causation. I'm not even sure there's
enough information to have correlation.



-- 
Chris Murphy
