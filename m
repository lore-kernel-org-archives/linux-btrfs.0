Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32518 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbaAGB33 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 20:29:29 -0500
Message-ID: <52CB57EF.1060606@cn.fujitsu.com>
Date: Tue, 07 Jan 2014 09:27:11 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs: fix wrong send_in_progress accounting
References: <1389000306-15320-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20140106163015.GX6498@twin.jikos.cz>
In-Reply-To: <20140106163015.GX6498@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/07/2014 12:30 AM, David Sterba wrote:
> On Mon, Jan 06, 2014 at 05:25:06PM +0800, Wang Shilong wrote:
>> Steps to reproduce:
>>
>>   # mkfs.btrfs -f /dev/sda8
>>   # mount /dev/sda8 /mnt
>>   # btrfs sub snapshot -r /mnt /mnt/snap1
>>   # btrfs sub snapshot -r /mnt /mnt/snap2
>>   # btrfs send /mnt/snap2 -p /mnt/snap1
>>
>> As @send_root will also add into clone_sources, and we should
>> take care not to decrease its count twice.
> Yes, send_root is appended to the clone_roots but the
> clone_sources_to_rollback does not track this, it's not updated after
> it's added in
>
>    sctx->clone_roots[sctx->clone_roots_cnt++].root = sctx->send_root;
>
> so send->root->send_in_progress is not modified in the loop that
> decrements all clone_root's counters again.
>
> I don't see the warning that should catch negative values of the counter
> in btrfs_root_dec_send_in_progress. Am I missing something?
just run 'dmesg' after the above commands.

Thanks,
Wang
>
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

