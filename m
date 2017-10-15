Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:52805 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751235AbdJOWJp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 15 Oct 2017 18:09:45 -0400
Received: by mail-io0-f194.google.com with SMTP id f20so14104013ioj.9
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Oct 2017 15:09:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171010163706.GR3521@twin.jikos.cz>
References: <20171003150604.19596-1-nefelim4ag@gmail.com> <20171003150604.19596-4-nefelim4ag@gmail.com>
 <20171010163706.GR3521@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 16 Oct 2017 01:09:04 +0300
Message-ID: <CAGqmi76z2nisakzci3W6n=1PLc+8vd+9iKZ3mnhAj64hNVT_kQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] Btrfs: handle unaligned tail of data ranges more efficient
To: David Sterba <dsterba@suse.cz>, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

May be then just add a comment at least at one of that functions?
Like:
/*
 * Handle unaligned end, end is inclusive, so always unaligned
 */

Or something like:
/*
 * It's obvious, kernel use paging, so range
 * Almost always have aligned start like 0
 * and unaligned end like 8192 - 1
 */

Or we assume that everybody who look at kernel code, must understood
that basic things?

Thanks


2017-10-10 19:37 GMT+03:00 David Sterba <dsterba@suse.cz>:
> On Tue, Oct 03, 2017 at 06:06:03PM +0300, Timofey Titovets wrote:
>> At now while switch page bits in data ranges
>> we always hande +1 page, for cover case
>> where end of data range is not page aligned
>
> The 'end' is inclusive and thus not aligned in most cases, ie. it's
> offset 4095 in the page, so the IS_ALIGNED is allways true and the code
> is equivalent to the existing condition (index <= end_index).



-- 
Have a nice day,
Timofey.
