Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:58120 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbaLVUEL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 15:04:11 -0500
Received: by mail-pd0-f174.google.com with SMTP id fp1so6396689pdb.5
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 12:04:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54985E4C.40003@gmail.com>
References: <CACyXjPwb-G3BkW6i7X5K3q5w4Fm8GhYt198KKzX3kqpioUKgxA@mail.gmail.com>
	<54982A79.1090102@gmail.com>
	<CACyXjPwiRXaV9ASetZa_cYD2R9TxQLfQP0x7aLknWuRXdtZ2Og@mail.gmail.com>
	<54985E4C.40003@gmail.com>
Date: Mon, 22 Dec 2014 12:04:10 -0800
Message-ID: <CACyXjPwstBv92VL_Q5w=NqNfAO-WUU1-7vf30Rt7NjwKeTQfeA@mail.gmail.com>
Subject: Re: Can BTRFS handle XATTRs larger than 4K?
From: Richard Sharpe <realrichardsharpe@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 22, 2014 at 10:09 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2014-12-22 12:27, Richard Sharpe wrote:
>>
>> On Mon, Dec 22, 2014 at 6:28 AM, Austin S Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>>
>>> On 2014-12-19 21:07, Richard Sharpe wrote:
>>>>
>>>>
>>>> Hi folks,
>>>>
>>>> I need a Linux file system that supports XATTRs up to 64K.
>>>>
>>>> Can BTRFS support that or is XFS the only Linux file system with such
>>>> support?
>>>>
>>> At the moment, BTRFS is limited to xattrs that fit inline in the metadata
>>> nodes (so ~3900 bytes for a 4k leafsize).
>>>
>>> XFS, however, isn't the only Linux filesystem that supports xattrs that
>>> size.  Assuming that you are using a recent kernel, you can also use such
>>> xattrs on at least:
>>>   * XFS
>>>   * JFS
>>>   * ext4
>>>   * reiserfs (I think, not 100% certain about this one though)
>>>   * OCFS2 (even though it is technically a cluster fs, it can be run
>>> single
>>> node without the clustering)
>>>   * ZFS (IIRC, ZFS supports unlimited xattr size)
>>>   * NTFS (no limit on xattr size, though you should use NTFS-3G instead
>>> of
>>> the in-kernel driver)
>>>   * SquashFS (read-only)
>>>   * HFS+ (Also no limit on xattr size)
>>> Of these, I'd personally suggest using XFS unless you need to be able to
>>> shrink the filesystem, in which case I'd suggest ext4.
>>
>>
>> Thanks for the info. I hadn't realized that ext4 had lifted the
>> restriction.
>>
> Yeah, it would be nice if there was more clarity in the documentation.
>
> Personally, I'd love to see unlimited length xattr's like NTFS and HFS+ do,
> as that would greatly improve interoperability (both Windows and OS X use
> xattrs, although they call them 'alternative data streams' and 'forks'
> respectively), and provide a higher likelihood that xattrs would start
> getting used more.

Well, there is a big difference in the semantics of Alternate Data
Streams (ADSs) and XATTRs.

For example, you can seek on an ADS and read at any offset. You cannot
do that on an XATTR (at least, not with the semantics provided by the
UNIX interface.)

-- 
Regards,
Richard Sharpe
(何以解憂？唯有杜康。--曹操)
