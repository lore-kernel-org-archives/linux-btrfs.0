Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50981 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752184AbdGDPbs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Jul 2017 11:31:48 -0400
Subject: Re: Commit edf064e7c (btrfs: nowait aio support) breaks shells
To: Markus Trippelsdorf <markus@trippelsdorf.de>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>
References: <20170704042306.GA274@x4> <20170704074505.GA277@x4>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <db94b5f7-d3a1-2340-0758-9437193d8254@suse.de>
Date: Tue, 4 Jul 2017 10:31:55 -0500
MIME-Version: 1.0
In-Reply-To: <20170704074505.GA277@x4>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/04/2017 02:45 AM, Markus Trippelsdorf wrote:
> On 2017.07.04 at 06:23 +0200, Markus Trippelsdorf wrote:
>> commit edf064e7c6fec3646b06c944a8e35d1a3de5c2c3 (HEAD, refs/bisect/bad)
>> Author: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> Date:   Tue Jun 20 07:05:49 2017 -0500
>>
>>     btrfs: nowait aio support
>>
>> apparently breaks several shell related features on my system.
> 
> Here is a simple testcase:
> 
>  % echo "foo" >> test
>  % echo "foo" >> test
>  % cat test
>  foo
>  %
> 

Thanks for testing.
Yes, pos must be set with iocb->ki_pos for appends. I should not have
removed the initialization. Could you try this patch?

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 59e2dccdf75b..7947781229e5 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1931,6 +1931,7 @@ static ssize_t btrfs_file_write_iter(struct kiocb
*iocb,
 	 */
 	update_time_for_write(inode);

+	pos = iocb->ki_pos;
 	start_pos = round_down(pos, fs_info->sectorsize);
 	oldsize = i_size_read(inode);
 	if (start_pos > oldsize) {



-- 
Goldwyn
