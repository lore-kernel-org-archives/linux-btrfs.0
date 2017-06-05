Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:36751 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbdFES4z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jun 2017 14:56:55 -0400
Received: by mail-qt0-f196.google.com with SMTP id s33so10782498qtg.3
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Jun 2017 11:56:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170605161003.GX12135@twin.jikos.cz>
References: <20170529231805.4797-1-nefelim4ag@gmail.com> <20170529231805.4797-3-nefelim4ag@gmail.com>
 <20170605161003.GX12135@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 5 Jun 2017 21:56:14 +0300
Message-ID: <CAGqmi76jA2YmchTrQkMUFPfbXEtDXMs9C3Ji7v7kN_vtffAP_Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] Btrfs: compression must free at least one sector size
To: dsterba@suse.cz, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-06-05 19:10 GMT+03:00 David Sterba <dsterba@suse.cz>:
> On Tue, May 30, 2017 at 02:18:05AM +0300, Timofey Titovets wrote:
>> Btrfs already skip store of data where compression didn't
>> free at least one byte. Let's make logic better and make check
>> that compression free at least one sector size
>> because in another case it useless to store this data compressed
>>
>> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
>> ---
>>  fs/btrfs/inode.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 17cbe930..2793007b 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -609,9 +609,10 @@ static noinline void compress_file_range(struct inode *inode,
>>               /*
>>                * one last check to make sure the compression is really a
>>                * win, compare the page count read with the blocks on disk
>> +              * compression must free at least one sector size
>>                */
>>               total_in = ALIGN(total_in, PAGE_SIZE);
>> -             if (total_compressed >= total_in) {
>> +             if (total_compressed + blocksize > total_in) {
>
> We're doing aligned calculation here, shouldn't this be >= ?
>
> If total_compressed + blocksize == total_in, we have saved exactly one
> blocksize.

We discussed that already in:
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg64350.html

IIRC: long in short:
- input data size 8192
- output data size 4096

This invertion logic, i.e. check if compression can be skipped, if
comparasion are true -> skip compression.

In case of above check,
old logic:
total_compressed >= total_in
4096 >= 8192 -> will_compress=1
With if blocksize added:
4096+4096 >= 8192 -> will_compress=0
So this must be changed to:
4096+4096 > 8192 -> will_compress=1
Because compression save one blocksize

Also will_compress not used after this code, so in theory this code
can be refactored to be more obvious, like that:
  total_in = ALIGN(total_in, PAGE_SIZE);
-             if (total_compressed + blocksize > total_in) {
-                          will_compress = 0;
-             } else {
+            if (total_compressed + blocksize <= total_in) {
                          num_bytes = total_in;
                           *num_added += 1;

Thanks

-- 
Have a nice day,
Timofey.
