Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:33456 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751400AbeCEQRm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Mar 2018 11:17:42 -0500
Received: by mail-it0-f51.google.com with SMTP id w19so9641793ite.0
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Mar 2018 08:17:42 -0800 (PST)
Subject: Re: btrfs space used issue
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-btrfs@vger.kernel.org
References: <CAFmraXiqhYUvM3VDGHp3Zj0i5SMH_Koy6Ed4B6W092-SVFSNVg@mail.gmail.com>
 <9d98d11a-0c30-56eb-efa9-889237592b4b@gmail.com>
 <CAFmraXjW_J-ezbwcS6YW6=4WThYmZ6-coeFBqtMUgyEdQKCkrw@mail.gmail.com>
 <CAA91j0Xqco3jYYnPJS81_xa7b73hzLNA8AN6WXiqHeW5sJzu2w@mail.gmail.com>
 <CAFmraXhRtUh-HPV4vpeE3-0B=vCeK40b2HfsOk_boSFu+EjQhg@mail.gmail.com>
 <pan$bee0f$57d3b021$cd11cf8a$d3c1d93d@cox.net>
 <20180305152827.GA27477@infradead.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <94411d71-b9b7-b0ee-f61d-5c4a93b1ad41@gmail.com>
Date: Mon, 5 Mar 2018 11:17:35 -0500
MIME-Version: 1.0
In-Reply-To: <20180305152827.GA27477@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-03-05 10:28, Christoph Hellwig wrote:
> On Sat, Mar 03, 2018 at 06:59:26AM +0000, Duncan wrote:
>> Indeed.  Preallocation with COW doesn't make the sense it does on an
>> overwrite-in-place filesystem.
> 
> It makes a whole lot of sense, it just is a little harder to implement.
> 
> There is no reason not to preallocate specific space, or if you aren't
> forced to be fully log structured by the medium, specific blocks to
> COW into.  It just isn't quite as trivial as for a rewrite in place
> file system to implement.
Yes, there's generally no reason not to pre-allocate space, but given 
how BTRFS implements pre-allocation, it doesn't make sense to do so 
pretty much at all for anything but NOCOW files, as it doesn't even 
guarantee that you'll be able to write however much data you 
pre-allocated space for (and it doesn't matter whether you use fallocate 
or just write out a run of zeroes, either way does not work in a manner 
consistent with how other filesystems do).

There's been discussion before about this, arising from the (completely 
illogical given how fallocate is expected to behave) behavior that you 
can fallocate more than half the free space on a BTRFS volume but will 
then fail writes with -ENOSPC part way through actually writing data to 
the pre-allocated space you just reserved (and that it can fail for 
other reasons too with -ENOSPC).
