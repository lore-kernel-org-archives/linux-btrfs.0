Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44787 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914Ab3DKNqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Apr 2013 09:46:00 -0400
Received: by mail-pa0-f45.google.com with SMTP id kl13so913139pab.18
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Apr 2013 06:46:00 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs: add a rb_tree to improve performance of ulist search
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <5166B9C9.6090108@jan-o-sch.net>
Date: Thu, 11 Apr 2013 21:45:53 +0800
Cc: Wang Shilong <wangsl-fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-Id: <76EC70D9-6972-4A2A-AFE1-D6DB1FA30617@gmail.com>
References: <5166495E.8030107@cn.fujitsu.com> <5166B9C9.6090108@jan-o-sch.net>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Jan

[snip]

>>  
>> +#include<linux/list.h>
>> +#include<linux/rbtree.h>
> 
> I didn't expect the space after "#include" being optional. If it compiles, I'm
> fine with it. With a space, it would look more familiar, though.

I am happy to send V2 to correct this coding style problem.
Thanks very much for reviewing it so carefully!

Thanks,
Wang
>> +
>> /*
>>  * ulist is a generic data structure to hold a collection of unique u64
>>  * values. The only operations it supports is adding to the list and
>> @@ -34,6 +37,7 @@ struct ulist_iterator {
>> struct ulist_node {
>> 	u64 val;		/* value to store */
>> 	u64 aux;		/* auxiliary value saved along with the val */
>> +	struct rb_node rb_node;	/* used to speed up search */
>> };
>> 
>> struct ulist {
>> @@ -54,6 +58,8 @@ struct ulist {
>> 	 */
>> 	struct ulist_node *nodes;
>> 
>> +	struct rb_root root;
>> +
>> 	/*
>> 	 * inline storage space for the first ULIST_SIZE entries
>> 	 */
>> 
> 
> Makes a lot of sense. Thanks!
> 
> Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

