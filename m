Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:21096 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbaAIMVF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 07:21:05 -0500
Message-ID: <52CE93F5.5050109@cn.fujitsu.com>
Date: Thu, 09 Jan 2014 20:20:05 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Alex <alex@bpmit.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: REQ: btrfs list <subvols only> option
References: <loom.20140109T020430-693@post.gmane.org> <38A0596B-F366-453C-ABC2-D4FB25637403@colorremedies.com> <loom.20140109T045506-475@post.gmane.org>
In-Reply-To: <loom.20140109T045506-475@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/09/2014 12:06 PM, Alex wrote:
> Chris Murphy <lists <at> colorremedies.com> writes:
>
>> Specify the mount point for the Btrfs file system and it will list all
> subvols on that file system.
>> Chris Murphy--
> Thank you Chris.
>
> When I do that on my version of the 3.12 userland:
> # btrfs  sub list / -o
There is a bug for 'btrfs sub list -o path', i will send a patch for this

Thanks,
Wang
> returns nothing (with no error), which I wasn't quite expecting because
> there *are* other snapshots and subvols below '/'
>
> AND
>
> # btrfs  sub list / -s
> correctly lists the snapshots only.
>
> I don't understand, what or if, I'm doing something wrong.
> Thank you in advance.
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

