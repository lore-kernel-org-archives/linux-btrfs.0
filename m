Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:33298 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752284AbdGDWQz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jul 2017 18:16:55 -0400
Received: by mail-pf0-f179.google.com with SMTP id e7so120104942pfk.0
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Jul 2017 15:16:55 -0700 (PDT)
Subject: Re: Commit edf064e7c (btrfs: nowait aio support) breaks shells
To: Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
References: <20170704042306.GA274@x4> <20170704074505.GA277@x4>
 <db94b5f7-d3a1-2340-0758-9437193d8254@suse.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c57bf8a7-fb0d-1a53-814d-bb4fba4b246b@kernel.dk>
Date: Tue, 4 Jul 2017 16:16:52 -0600
MIME-Version: 1.0
In-Reply-To: <db94b5f7-d3a1-2340-0758-9437193d8254@suse.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/04/2017 09:31 AM, Goldwyn Rodrigues wrote:
> 
> 
> On 07/04/2017 02:45 AM, Markus Trippelsdorf wrote:
>> On 2017.07.04 at 06:23 +0200, Markus Trippelsdorf wrote:
>>> commit edf064e7c6fec3646b06c944a8e35d1a3de5c2c3 (HEAD, refs/bisect/bad)
>>> Author: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>> Date:   Tue Jun 20 07:05:49 2017 -0500
>>>
>>>     btrfs: nowait aio support
>>>
>>> apparently breaks several shell related features on my system.
>>
>> Here is a simple testcase:
>>
>>  % echo "foo" >> test
>>  % echo "foo" >> test
>>  % cat test
>>  foo
>>  %
>>
> 
> Thanks for testing.
> Yes, pos must be set with iocb->ki_pos for appends. I should not have
> removed the initialization. Could you try this patch?
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 59e2dccdf75b..7947781229e5 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1931,6 +1931,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb
> *iocb,
>  	 */
>  	update_time_for_write(inode);
> 
> +	pos = iocb->ki_pos;
>  	start_pos = round_down(pos, fs_info->sectorsize);
>  	oldsize = i_size_read(inode);
>  	if (start_pos > oldsize) {

Please expedite getting this upstream, asap.

-- 
Jens Axboe

