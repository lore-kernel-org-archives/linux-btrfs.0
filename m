Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:13314 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab2ISC6t (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 22:58:49 -0400
Message-ID: <505934E3.8040307@cn.fujitsu.com>
Date: Wed, 19 Sep 2012 10:58:43 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V4 4/7] Btrfs-progs: fix wrong way to check if the root
 item contains otime and uuid
References: <50584E6D.8000602@cn.fujitsu.com> <50585420.6060407@cn.fujitsu.com> <50592607.709@oracle.com>
In-Reply-To: <50592607.709@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 	wed, 19 Sep 2012 09:55:19 +0800, Anand Jain wrote:
> 
> Miao,
> 
>> wrong because it is possbile that ->generation may equal to the first
>> variant of the next item.
> 
>  When can this happen ?  Can you provide a scenario to run through. ?

On the old kernel:
# mkfs.btrfs <partition>
# mount <partition> <mnt>
# btrfs sub snap <mnt> <mnt>/snap0
# btrfs sub snap <mnt> <mnt>/snap1
# btrfs sub list -u <mnt>

Thanks
Miao

> 
> Thanks, Anand
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


