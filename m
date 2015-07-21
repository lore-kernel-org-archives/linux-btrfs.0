Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36804 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbbGUPf3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jul 2015 11:35:29 -0400
Received: by wicgb10 with SMTP id gb10so59403452wic.1
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jul 2015 08:35:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150714191558.GM10539@carfax.org.uk>
References: <20150604084245.GR23272@merlins.org> <20150624032008.GF20517@merlins.org>
 <CAA7pwKOA1yyA8kyB+a3iTOp8TnkRzAErF1Mo=2t5M3pFn2tjUw@mail.gmail.com>
 <pan$5335b$94315604$8405c6ac$de90de30@cox.net> <CAA7pwKNtS6UB+tXdB9c4D9J2gOk56gM-O1q+19A6SZcdcdFVtw@mail.gmail.com>
 <20150714184122.GL10539@carfax.org.uk> <CAA7pwKOytX18=mtPjfGmGgvd-x=nNpFYSsHX3m7uMJCCjZU8zg@mail.gmail.com>
 <20150714191558.GM10539@carfax.org.uk>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Tue, 21 Jul 2015 17:35:08 +0200
Message-ID: <CAA7pwKOF8Zfy2-BquOniuqju7bFEsx15ysx1v9HrLNkk4_TqOA@mail.gmail.com>
Subject: Re: counting fragments takes more time than defragmenting
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14 July 2015 at 21:15, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Jul 14, 2015 at 09:09:00PM +0200, Patrik Lundquist wrote:
>> On 14 July 2015 at 20:41, Hugo Mills <hugo@carfax.org.uk> wrote:
>> > On Tue, Jul 14, 2015 at 01:57:07PM +0200, Patrik Lundquist wrote:
>> >> On 24 June 2015 at 12:46, Duncan <1i5t5.duncan@cox.net> wrote:
>> >> >
>> >> > Regardless of whether 1 or huge -t means maximum defrag, however, the
>> >> > nominal data chunk size of 1 GiB means that 30 GiB file you mentioned
>> >> > should be considered ideally defragged at 31 extents.  This is a
>> >> > departure from ext4, which AFAIK in theory has no extent upper limit, so
>> >> > should be able to do that 30 GiB file in a single extent.
>> >> >
>> >> > But btrfs or ext4, 31 extents ideal or a single extent ideal, 150 extents
>> >> > still indicates at least some remaining fragmentation.
>> >>
>> >> So I converted the VMware VMDK file to a VirtualBox VDI file:
>> >>
>> >> -rw------- 1 plu plu 28845539328 jul 13 13:36 Windows7-disk1.vmdk
>> >> -rw------- 1 plu plu 28993126400 jul 13 14:04 Windows7.vdi
>> >>
>> >> $ filefrag Windows7.vdi
>> >> Windows7.vdi: 15 extents found
>> >>
>> >> $ btrfs filesystem defragment -t 3g Windows7.vdi
>> >> $ filefrag Windows7.vdi
>> >> Windows7.vdi: 24 extents found
>> >>
>> >> How can it be less than 28 extents with a chunk size of 1 GiB?
>> >
>> >    I _think_ the fragment size will be limited by the block group
>> > size. This is not the same as the chunk size for some RAID levels --
>> > for example, RAID-0, a block group can be anything from 2 to n chunks
>> > (across the same number of devices), where each chunk is 1 GiB, so
>> > potentially you could have arbitrary-sized block groups. The same
>> > would apply to RAID-10, -5 and -6.
>> >
>> >    (Note, I haven't verified this, but it makes sense based on what I
>> > know of the internal data structures).
>>
>> It's a raid1 filesystem, so the block group ought to be the same size
>> as the chunk, right?
>
>    Yes.
>
>> A 2GiB block group would suffice to explain it though.
>
>    Not with RAID-1 -- I'd expect the block group size to be 1 GiB.

So I had a look at the filefrag source and filefrag actually doesn't
print the number of extents but the number of disk fragments.
Contiguously allocated extents counts as one fragment.

"Windows7.vdi: 47 extents found" is really 213 extents over 47 disk fragments.

But I have one 2GiB extent, according to filefrag -v, so the question
remains. :-)
