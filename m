Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33562 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbbGNTJV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 15:09:21 -0400
Received: by widic2 with SMTP id ic2so45842485wid.0
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2015 12:09:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150714184122.GL10539@carfax.org.uk>
References: <20150604084245.GR23272@merlins.org> <20150624032008.GF20517@merlins.org>
 <CAA7pwKOA1yyA8kyB+a3iTOp8TnkRzAErF1Mo=2t5M3pFn2tjUw@mail.gmail.com>
 <pan$5335b$94315604$8405c6ac$de90de30@cox.net> <CAA7pwKNtS6UB+tXdB9c4D9J2gOk56gM-O1q+19A6SZcdcdFVtw@mail.gmail.com>
 <20150714184122.GL10539@carfax.org.uk>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Tue, 14 Jul 2015 21:09:00 +0200
Message-ID: <CAA7pwKOytX18=mtPjfGmGgvd-x=nNpFYSsHX3m7uMJCCjZU8zg@mail.gmail.com>
Subject: Re: counting fragments takes more time than defragmenting
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14 July 2015 at 20:41, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Jul 14, 2015 at 01:57:07PM +0200, Patrik Lundquist wrote:
>> On 24 June 2015 at 12:46, Duncan <1i5t5.duncan@cox.net> wrote:
>> >
>> > Regardless of whether 1 or huge -t means maximum defrag, however, the
>> > nominal data chunk size of 1 GiB means that 30 GiB file you mentioned
>> > should be considered ideally defragged at 31 extents.  This is a
>> > departure from ext4, which AFAIK in theory has no extent upper limit, so
>> > should be able to do that 30 GiB file in a single extent.
>> >
>> > But btrfs or ext4, 31 extents ideal or a single extent ideal, 150 extents
>> > still indicates at least some remaining fragmentation.
>>
>> So I converted the VMware VMDK file to a VirtualBox VDI file:
>>
>> -rw------- 1 plu plu 28845539328 jul 13 13:36 Windows7-disk1.vmdk
>> -rw------- 1 plu plu 28993126400 jul 13 14:04 Windows7.vdi
>>
>> $ filefrag Windows7.vdi
>> Windows7.vdi: 15 extents found
>>
>> $ btrfs filesystem defragment -t 3g Windows7.vdi
>> $ filefrag Windows7.vdi
>> Windows7.vdi: 24 extents found
>>
>> How can it be less than 28 extents with a chunk size of 1 GiB?
>
>    I _think_ the fragment size will be limited by the block group
> size. This is not the same as the chunk size for some RAID levels --
> for example, RAID-0, a block group can be anything from 2 to n chunks
> (across the same number of devices), where each chunk is 1 GiB, so
> potentially you could have arbitrary-sized block groups. The same
> would apply to RAID-10, -5 and -6.
>
>    (Note, I haven't verified this, but it makes sense based on what I
> know of the internal data structures).

It's a raid1 filesystem, so the block group ought to be the same size
as the chunk, right?

A 2GiB block group would suffice to explain it though.
