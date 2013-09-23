Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:37984 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752892Ab3IWBQZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Sep 2013 21:16:25 -0400
Message-ID: <523F95C4.1080404@cn.fujitsu.com>
Date: Mon, 23 Sep 2013 09:13:40 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Dusty Mabe <dustymabe@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/9] enhance btrfs qgroup show command
References: <50C068D4.6020105@cn.fujitsu.com> <loom.20130922T170658-776@post.gmane.org>
In-Reply-To: <loom.20130922T170658-776@post.gmane.org>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/22/2013 11:14 PM, Dusty Mabe wrote:
> Miao Xie <miaox <at> cn.fujitsu.com> writes:
>
>> The patchset enhanced btrfs qgroup show command.
>>
>> Firstly, we restructure show_qgroups, make it easy to add new features.
>>
>> And then we add '-p' '-c', '-l',and '-e' options to print the parent
>> qgroup id, child qgroup id, max referenced size and max exclusive size
>> of qgroup respectively, add '-F' and '-f' option to list qgroups that
>> impact the given path.
>
> Hi,
>
> What is the status of this patch? I don't ever think it made it in upstream. 
> Was it flawed or just forgotten? 
I will rebase this patchset and resend.

Thanks,
Wang
>
> Thanks,
> Dusty 
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

