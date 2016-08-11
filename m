Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36078 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbcHKUn6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Aug 2016 16:43:58 -0400
Received: by mail-oi0-f44.google.com with SMTP id f189so9965914oig.3
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Aug 2016 13:43:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$912d3$2d5e3dbf$b96ae0e6$53dad290@cox.net>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
 <pan$d9b53$c31dc60$985cf806$b833643c@cox.net> <CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
 <CAGdWbB72DLAkV3EwO-7Sakc4gPHRT=GmU5ftxo0YfR0wjBefNQ@mail.gmail.com>
 <CAJCQCtS3c5u6hDjHdU92AdQvSECNT99vOMxLiM4tchv4nrwPmA@mail.gmail.com>
 <CAGdWbB7qNFfKy1C3Ldb8aSCxvphZeYcmrXtdiB_ECGXNLZ-K5w@mail.gmail.com>
 <CAD=QJKjZP3V3HE_iXYcLJvq65mXKiXp_aYgZuoHmQFd7mJ7j0Q@mail.gmail.com> <pan$912d3$2d5e3dbf$b96ae0e6$53dad290@cox.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 11 Aug 2016 14:43:56 -0600
Message-ID: <CAJCQCtTM_RdLHdLLsYjw3AVseHWP__7JLARO02ohYGkjzbnkmg@mail.gmail.com>
Subject: Re: checksum error in metadata node - best way to move root fs to new drive?
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 11, 2016 at 1:07 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> The compression-related problem is this:  Btrfs is considerably less
> tolerant of checksum-related errors on btrfs-compressed data,


Why? The data is the data. And why would it matter if it's application
compressed data vs Btrfs compressed data? If there's an error, Btrfs
is intolerant. I don't see how there's a checksum error that Btrfs
tolerates.

But also I don't know if the checksum is predicated on compressed data
or uncompressed data - does the scrub blindly read compressed data,
checksums it, and compares to the previously recorded csum? Or does
the scrub read compressed data, decompresses it, checksums it, then
compares? And does compression compress metadata? I don't think it
does from some of the squashfs testing of the same set of binary files
on ext4 vs btrfs uncompressed vs btrfs compressed. The difference is
explained by inline data being compressed (which it is), so I don't
think the fs itself gets compressed.


Chris Murphy

-- 
Chris Murphy
