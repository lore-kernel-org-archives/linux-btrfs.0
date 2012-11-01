Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:26772 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933964Ab2KAQCC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 12:02:02 -0400
Message-ID: <50929CF4.9060206@oracle.com>
Date: Fri, 02 Nov 2012 00:01:56 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v4] Btrfs: snapshot-aware defrag
References: <1351333721-3220-1-git-send-email-bo.li.liu@oracle.com> <CANW9uyu0NyFj57AVp2X-Hc=AjXdwyP=wieOcteEbj2_Mx_F95w@mail.gmail.com> <50911FC0.4080104@oracle.com> <CANW9uyse7bw1+=GkV-aRQbDPh1E-t3G4VwkAGc5-76KMfYMjog@mail.gmail.com> <20121101112114.GA4328@liubo.cn.oracle.com> <CANW9uysHg6qk4zSh_yFgP5e545kJZVoma36Hpd1Zzg-hoSVAhQ@mail.gmail.com>
In-Reply-To: <CANW9uysHg6qk4zSh_yFgP5e545kJZVoma36Hpd1Zzg-hoSVAhQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/01/2012 10:05 PM, Itaru Kitayama wrote:
> Hi Liubo:
> 
> The V4 leaves only warnings from btrfs_destroy_inode(). So, you think
> it's normal
> an "old" extent recorded can be removed from the extent tree by the time
> relink_file_extents() invoked?
> 

Yeah, it could be if only we run delayed refs in time.

But I don't think that often happens since we run delayed refs when the amount
reaches its limit(64).

thanks,
liubo

> Itaru
> 
> On Thu, Nov 1, 2012 at 8:21 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> 
>> The current btrfs-next HEAD actually have included this v4 patch, so
>> just pull btrfs-next and give it a shot :)
>>
>> thanks,
>> liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

