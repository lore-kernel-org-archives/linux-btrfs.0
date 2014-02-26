Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:10961 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaBZItw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Feb 2014 03:49:52 -0500
Message-ID: <530DAB0C.2090707@cn.fujitsu.com>
Date: Wed, 26 Feb 2014 16:51:24 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/9] Btrfs: stop joining the log transaction if sync log
 fails
References: <1392890939-19044-1-git-send-email-miaox@cn.fujitsu.com> <1392890939-19044-7-git-send-email-miaox@cn.fujitsu.com> <20140222002751.GP16073@twin.jikos.cz>
In-Reply-To: <20140222002751.GP16073@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 22 Feb 2014 01:27:51 +0100, David Sterba wrote:
> On Thu, Feb 20, 2014 at 06:08:57PM +0800, Miao Xie wrote:
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -142,6 +142,12 @@ static int start_log_trans(struct btrfs_trans_handle *trans,
>>  
>>  	mutex_lock(&root->log_mutex);
>>  	if (root->log_root) {
>> +		if (ACCESS_ONCE(root->fs_info->last_trans_log_full_commit) ==
>> +		    trans->transid) {
>> +			ret = -EAGAIN;
>> +			goto out;
>> +		}
> 
> So last_trans_log_full_commit needs special handling, but opencoding it
> everywhere is no very clean. Documented set/get helpers would be much
> better.
> 

Right, I'll update it in the next version.

Thanks for your review.
Miao
