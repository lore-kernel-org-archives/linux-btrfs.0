Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31331 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbaA2CHb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 21:07:31 -0500
Message-ID: <52E862BB.5020400@cn.fujitsu.com>
Date: Wed, 29 Jan 2014 10:08:59 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V2 1/4] Btrfs: filter the ordered extents that has been
 logged
References: <1389702712-26638-1-git-send-email-miaox@cn.fujitsu.com> <1389702712-26638-2-git-send-email-miaox@cn.fujitsu.com> <52E7C3BE.5090107@fb.com>
In-Reply-To: <52E7C3BE.5090107@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 28 Jan 2014 09:50:38 -0500, Josef Bacik wrote:
> 
> On 01/14/2014 07:31 AM, Miao Xie wrote:
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>   fs/btrfs/ordered-data.c |    2 ++
>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
>> index 69582d5..e4c3d56 100644
>> --- a/fs/btrfs/ordered-data.c
>> +++ b/fs/btrfs/ordered-data.c
>> @@ -433,6 +433,8 @@ void btrfs_get_logged_extents(struct btrfs_root *log, struct inode *inode)
>>       spin_lock_irq(&tree->lock);
>>       for (n = rb_first(&tree->tree); n; n = rb_next(n)) {
>>           ordered = rb_entry(n, struct btrfs_ordered_extent, rb_node);
>> +        if (test_bit(BTRFS_ORDERED_LOGGED_CSUM, &ordered->flags))
>> +            continue;
>>           spin_lock(&log->log_extents_lock[index]);
>>           if (list_empty(&ordered->log_list)) {
>>               list_add_tail(&ordered->log_list, &log->logged_list[index]);
> This isn't right, the logged extents are the extents we need to wait on before we exit fsync, logged_csum tells us that we've already copied its csums into the log.  Thanks,

My mistake, We need another flag to filter the ordered extents.

Thanks
Miao

