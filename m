Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51508 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379AbcECB0t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 21:26:49 -0400
MIME-Version: 1.0
In-Reply-To: <20160502145002.GB20589@infradead.org>
References: <1461805789-3632-1-git-send-email-ming.lei@canonical.com>
	<1461805789-3632-2-git-send-email-ming.lei@canonical.com>
	<20160502145002.GB20589@infradead.org>
Date: Tue, 3 May 2016 09:26:45 +0800
Message-ID: <CACVXFVONp+kUjTJ=J7EbU_MEQpHG_UOK1WY3oFxtUhtRDX-U5w@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] fs: direct-io: call .bi_end_io via bio_endio()
From: Ming Lei <ming.lei@canonical.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "open list:FILESYSTEMS (VFS and infrastructure)"
	<linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 2, 2016 at 10:50 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Apr 28, 2016 at 09:09:48AM +0800, Ming Lei wrote:
>> bio_endio() is the graceful way to complete one bio.
>
>
>
>>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>> ---
>>  fs/direct-io.c | 7 +------
>>  1 file changed, 1 insertion(+), 6 deletions(-)
>>
>> diff --git a/fs/direct-io.c b/fs/direct-io.c
>> index a8dd60a..0a35e51 100644
>> --- a/fs/direct-io.c
>> +++ b/fs/direct-io.c
>> @@ -350,15 +350,10 @@ static void dio_bio_end_io(struct bio *bio)
>>   */
>>  void dio_end_io(struct bio *bio, int error)
>>  {
>> -     struct dio *dio = bio->bi_private;
>> -
>>       if (!bio->bi_error)
>>               bio->bi_error = error;
>>
>> -     if (dio->is_async)
>> -             dio_bio_end_aio(bio);
>> -     else
>> -             dio_bio_end_io(bio);
>> +     bio_endio(bio);
>>  }
>>  EXPORT_SYMBOL_GPL(dio_end_io);
>
> dio_end_io is only used by btrfs.  So instead of this and the previous
> patch you should just open code the error assignment and call to
> bio_endio in btrfs.

OK.

Thanks,
