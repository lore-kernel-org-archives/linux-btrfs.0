Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:44839 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751640AbbDCHGv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Apr 2015 03:06:51 -0400
Message-ID: <551E3C06.9040305@cn.fujitsu.com>
Date: Fri, 3 Apr 2015 15:06:46 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] btrfs-progs: Doc: Add warning and note on btrfs-convert.
References: <1428024075-10211-1-git-send-email-quwenruo@cn.fujitsu.com> <pan$c078e$9a53acee$d6e24908$3d5c7666@cox.net>
In-Reply-To: <pan$c078e$9a53acee$d6e24908$3d5c7666@cox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Qu Wenruo posted on Fri, 03 Apr 2015 09:21:15 +0800 as excerpted:
>
>> +WARNING: If one hopes to rollback to ext2/3/4, he or she should not execute
>> +*btrfs balance* command on converted btrfs.
>> +Since it will change the extent layout and make *btrfs-convert* unable to
>> +rollback.
>
> Because "since" is subordinating and the sentence doesn't contain what
> it is subordinated to as that's explained in the previous sentence,
> "Since it will..." introduces a sentence fragment.
Thanks.

It seems my English is really poor... :(
>
> Possible correction 1, combine the sentences:  Either simply eliminate
> the period following the previous sentence, or convert it to a comma,
> either way combining the sentences into one.
I'll take this one.

Thanks,
Qu
>
> Possible correction 2, eliminate the subordinator:  Eliminate "Since"
> and begin the second sentence with "A balance..." (replacing "it").
>
> Possible correction 3, reorder and edit, something like this:
>
> +WARNING: Do not execute a *btrfs balance" on a converted btrfs until you
> +are sure you will not rollback, as a balance changes the extent layout
> +and prevents btrfs-convert from successfully rolling back to ext2/3/4.
>
