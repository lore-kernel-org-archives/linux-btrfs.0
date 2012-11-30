Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58627 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab2K3LS1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Nov 2012 06:18:27 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so371830pbc.19
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Nov 2012 03:18:26 -0800 (PST)
Message-ID: <50B895FD.80006@gmail.com>
Date: Fri, 30 Nov 2012 19:18:21 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: chris.mason@fusionio.com, jbacik@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: remove warning check in io_ctl_map_page
References: <n> <1354255348-5011-1-git-send-email-y> <50b84c20.a657320a.776a.fffff16d@mx.google.com> <20121130090252.GA7353@liubo.cn.oracle.com>
In-Reply-To: <20121130090252.GA7353@liubo.cn.oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012年11月30日 17:02, Liu Bo wrote:

> On Fri, Nov 30, 2012 at 02:02:26PM +0800, shhuiw@gmail.com wrote:
>> From: Wang Sheng-Hui <shhuiw@gmail.com>
>>
>> io_ctl_map_page is called by many functions in free-space-cache.
>> In some scenarios, the ->cur is not null, e.g. io_ctl_add_entry.
>> Remove the check here.
> 
> Hi Wang,
> 
> Seems to be impossible according to the code, even in io_ctl_add_entry().
> 
> So have you seen such a warning in your flight running?  If you do,
> maybe you can post it here and we can figure out the whys.
> 


Hi Liu Bo,

I just walked through the code. reread io_ctl_add_entry, and just noticed
that io_ctl_set_crc is called before io_ctl_map_page, which can guarantee
the ->cur is set to null before map.

Thanks for helping me understand the code.

Regards,
Sheng-Hui


> thanks,
> liubo
> 
>>
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>> ---
>>  fs/btrfs/free-space-cache.c |    1 -
>>  1 files changed, 0 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
>> index c3318cb..4ea66d4 100644
>> --- a/fs/btrfs/free-space-cache.c
>> +++ b/fs/btrfs/free-space-cache.c
>> @@ -307,7 +307,6 @@ static void io_ctl_unmap_page(struct io_ctl *io_ctl)
>>  
>>  static void io_ctl_map_page(struct io_ctl *io_ctl, int clear)
>>  {
>> -	WARN_ON(io_ctl->cur);
>>  	BUG_ON(io_ctl->index >= io_ctl->num_pages);
>>  	io_ctl->page = io_ctl->pages[io_ctl->index++];
>>  	io_ctl->cur = kmap(io_ctl->page);
>> -- 
>> 1.6.0.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


