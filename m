Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33903 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbdE2SRL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 14:17:11 -0400
Received: by mail-qk0-f182.google.com with SMTP id d14so12981121qkb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 29 May 2017 11:17:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170529142336.GG14523@twin.jikos.cz>
References: <20170525181220.24692-1-nefelim4ag@gmail.com> <20170525181220.24692-3-nefelim4ag@gmail.com>
 <20170529142336.GG14523@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 29 May 2017 21:16:29 +0300
Message-ID: <CAGqmi779E7eLkivZWwVyp+or=HGrOHp+qx7m7p-HK+ZDJz7rPg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] Btrfs: compression must free at least one sector size
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-05-29 17:23 GMT+03:00 David Sterba <dsterba@suse.cz>:
> On Thu, May 25, 2017 at 09:12:20PM +0300, Timofey Titovets wrote:
>> Btrfs already skip store of data where compression didn't
>> free at least one byte. Let's make logic better and make check
>> that compression free at least one sector size
>> because in another case it useless to store this data compressed
>
> Yeah, there's a room for improvement.
>
> Saving at least one sectorsize sounds ok to me. I'm not sure if this
> should be implemented inside the compressors (lzo, zlib). There'res the
> quick shortcut (the check "if (tot_in > 8192 && tot_in < tot_out)"), but
> otherwise the overall decision whether to use the compressed data is
> done in compress_file_range.
>
>   601         if (will_compress) {
>   602                 /*
>   603                  * we aren't doing an inline extent round the compressed size
>   604                  * up to a block size boundary so the allocator does sane
>   605                  * things
>   606                  */
>   607                 total_compressed = ALIGN(total_compressed, blocksize);
>   608
>   609                 /*
>   610                  * one last check to make sure the compression is really a
>   611                  * win, compare the page count read with the blocks on disk
>   612                  */
>   613                 total_in = ALIGN(total_in, PAGE_SIZE);
>   614                 if (total_compressed >= total_in) {
>   615                         will_compress = 0;
>   616                 } else {
> ...
>
> so the check would go to line 614.
>
> There's one case that your patch misses and it's the compressed inline extent.
> As we'd never submit more than one sectorsize of data to compression, the
> savings would be bigger than one page and thus we'd skip the compression.
>
> This could be fixed easily though, but I'd like to use it as an example why the
> decision should be moved upwards in the callchain (ie. to compress_file_range).

Thanks for advice Devid, i will update the patch.

Also, as i move the check logic to new place, i want send another
patch what will fix the difference in behaviour of check logic in
lzo/zlib, i.e.:
lzo.c:
232        if (tot_out > tot_in)
233                goto out;

zlib.c:
194        if (workspace->strm.total_out >= workspace->strm.total_in) {
195                ret = -E2BIG;
196                goto out;
197        }

I think that the zlib logic more smart, because if compressed size ==
uncompressed it's also useless

-- 
Have a nice day,
Timofey.
