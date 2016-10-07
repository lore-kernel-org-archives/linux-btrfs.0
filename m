Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:33439 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753525AbcJGOAb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Oct 2016 10:00:31 -0400
Received: by mail-qt0-f181.google.com with SMTP id s49so21635971qta.0
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Oct 2016 07:00:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6bf85d64-2792-85db-0169-c6288e95a775@suse.com>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <94e50637-9f66-19c7-35e4-e6b2c8bf919c@suse.com> <CAGfcS_mLABcdd_3n=0cV8nx1DXoLBDFC6SbmMou_ZXWjw0BqRA@mail.gmail.com>
 <a8dac132-78b3-4276-2ed3-d30a74b0d31b@suse.com> <CAGfcS_=2x-CqGwXXeWejiUoDTgy9HxAtPdy2Nur2CAMYT3d26A@mail.gmail.com>
 <6bf85d64-2792-85db-0169-c6288e95a775@suse.com>
From: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
Date: Fri, 7 Oct 2016 10:00:29 -0400
Message-ID: <CAGfcS_nKwJB+v+5+TB1GU+ywxYh9dBD6vCUXbMnAyU4JwvdiRg@mail.gmail.com>
Subject: Re: unable to handle kernel paging request - btrfs
To: Jeff Mahoney <jeffm@suse.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 30, 2016 at 8:38 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 9/30/16 5:07 PM, Rich Freeman wrote:
>> On Fri, Sep 30, 2016 at 4:55 PM, Jeff Mahoney <jeffm@suse.com> wrote:
>>> This looks like a use-after-free on one of the pages used for
>>> compression.  Can you post the output of objdump -Dr
>>> /lib/modules/$(uname -r)/kernel/fs/btrfs/btrfs.ko somewhere?
>>>
>>
>> Sure:
>> https://drive.google.com/open?id=0BwUDImviY_gcR3JfT0Z1cUlRVEk
>>
>> I was impressed by just how large it was.
>>
>> I take it you're going to try to use the offsets in the oops to figure
>> out where it went wrong?  I really need to get kernel core dumping
>> working on this box...
>
> Yep.  What I think is happening is that we have workspace getting freed
> while it's in use.  The faulting address is in vmalloc space and it's
> also the first argument to memcpy, which makes it the destination.  In
> lzo_decompress_biovec, that means it's the workspace->cbuf.  Beyond that
> I'll have to dig a bit more.
>

I'll confess to not being much of a kernel hacker, but could this
error also be caused by a buffer overrun?  If working_bytes or
in_page_bytes_left are larger than the size of the buffer then the
memcpy would overrun the length of the buffer.  I don't know if that
generates a different error than the one reported.

What guarantee do we have that working_bytes is less than the size of
workspace->cbuf?  I'm just throwing stuff out there because as far as
I can tell the code never frees workspace (I'm guessing kunmap at the
very end might take care of it).

--
Rich
