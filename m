Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56211 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab2IRGLk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 02:11:40 -0400
Message-ID: <50581098.7090309@cn.fujitsu.com>
Date: Tue, 18 Sep 2012 14:11:36 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V3 4/7] Btrfs-progs: fix wrong way to check if the root
 item contains otime and uuid
References: <50487FD8.1000804@cn.fujitsu.com> <50580D1C.9020303@oracle.com>
In-Reply-To: <50580D1C.9020303@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 18 Sep 2012 13:56:44 +0800, Anand Jain wrote:
> 
> 
>> -                if(ri->generation == ri->generation_v2) {
>> +                if(sh->len == sizeof(struct btrfs_root_item)) {
>>                       t = ri->otime.sec;
> 
>  This looks fine now but should this work when we
>  move to v3 and still have access to v2 introduced
>  members.?
> 
>  ker cli
>  v3  v2  v2 introduced members are unnecessarily blocked
>  v2  v3  --as above--

No.

I will update my patch to fix this problem.

Thanks
Miao
