Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8930 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944AbaILOuk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Sep 2014 10:50:40 -0400
Message-ID: <54130839.8000707@fb.com>
Date: Fri, 12 Sep 2014 10:50:33 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 00/11] Implement the data repair function for direct
 read
References: <5405C08B.9020009@fb.com> <1410518644-31806-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1410518644-31806-1-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/12/2014 06:43 AM, Miao Xie wrote:
> This patchset implement the data repair function for the direct read, it
> is implemented like buffered read:
> 1.When we find the data is not right, we try to read the data from the other
>   mirror.
> 2.When the io on the mirror ends, we will insert the endio work into the
>   dedicated btrfs workqueue, not common read endio workqueue, because the
>   original endio work is still blocked in the btrfs endio workqueue, if we
>   insert the endio work of the io on the mirror into that workqueue, deadlock
>   would happen.
> 3.If We get right data, we write it back to repair the corrupted mirror.
> 4.If the data on the new mirror is still corrupted, we will try next
>   mirror until we read right data or all the mirrors are traversed.
> 5.After the above work, we set the uptodate flag according to the result.
> 
> The difference is that the direct read may be splited to several small io,
> in order to get the number of the mirror on which the io error happens. we
> have to do data check and repair on the end IO function of those sub-IO
> request.
> 
> Besides that, we also fixed some bugs of direct io.
> 
> Changelog v3 -> v4:
> - Remove the 1st patch which has been applied into the upstream kernel.
> - Use a dedicated btrfs workqueue instead of the system workqueue to
>   deal with the completed repair bio, this suggest was from Chris.
> - Rebase the patchset to integration branch of Chris's git tree.

Perfect, thank you.

-chris
