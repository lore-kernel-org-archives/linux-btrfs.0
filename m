Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:52039 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751510AbdJMWbs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Oct 2017 18:31:48 -0400
Received: by mail-io0-f194.google.com with SMTP id b186so10500681iof.8
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Oct 2017 15:31:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171010162228.GQ3521@twin.jikos.cz>
References: <20171003150604.19596-1-nefelim4ag@gmail.com> <20171003150604.19596-3-nefelim4ag@gmail.com>
 <20171010162228.GQ3521@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sat, 14 Oct 2017 01:31:06 +0300
Message-ID: <CAGqmi75QRdH8z-pcTKVy=YwjLWiQOczxuK7z=k+Y4Ca+cpY=Cw@mail.gmail.com>
Subject: Re: [PATCH 2/4] Btrfs: clear_dirty only on pages only in compression range
To: David Sterba <dsterba@suse.cz>, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-10-10 19:22 GMT+03:00 David Sterba <dsterba@suse.cz>:
> On Tue, Oct 03, 2017 at 06:06:02PM +0300, Timofey Titovets wrote:
>> We need to call extent_range_clear_dirty_for_io()
>> on compression range to prevent application from changing
>> page content, while pages compressing.
>>
>> but "(end - start)" can be much (up to 1024 times) bigger
>> then compression range (BTRFS_MAX_UNCOMPRESSED), so optimize that
>> by calculating compression range for
>> that loop iteration, and flip bits only on that range
>
> I'm not sure this is safe to do. Compress_file_range gets the whole
> range [start,end] from async_cow_start, and other parts of code might
> rely on the status of the whole range, ie. not partially redirtied.

I check some kernel code, io path are complex =\.
I see 3 approaches:
1. That used to signal upper level, that we fail to write that pages
and on other sync() call, kernel can send that data again to writing.
2. We lock pages from any changes while processing data.
3. Serialize writes, i.e. if i understood correctly, that allow to
not send down pages again for several sync requests.

My code above will handle ok first and second case, and in theory will
cause some issues with 3, but doesn't matter.

The main design problem from my point of view for now, that we call
that function many times in the loop, example:
compress_file_range get: 0 - 1048576
extent_range_clear_dirty_for_io(), will get a call for:
0 - 1048576
131072 - 1048576
262144 - 1048576
... & etc

So, we can beat that in different way.
I first think about move extent_range_clear_dirty_for_io() out of
loop, but i think that a better approach.

Whats about:
if (!redirty) {
    extent_range_clear_dirty_for_io(inode, start, end);
    redirty = 1;
}

That will also cover all above cases, because that lock whole range, as before.
But we only call that once, and that will fix design issue.

That you think?

Thanks.
-- 
Have a nice day,
Timofey.
