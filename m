From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: use do_div to avoid compile errors on 32bit box
Date: Sat, 20 Aug 2011 09:35:26 +0800
Message-ID: <4E4F0F5E.4010601@cn.fujitsu.com>
References: <1313747324-27477-1-git-send-email-liubo2009@cn.fujitsu.com> <20110819132250.GC28234@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com, dave@jikos.cz
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110819132250.GC28234@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/19/2011 09:22 PM, Josef Bacik wrote:
> On Fri, Aug 19, 2011 at 05:48:44PM +0800, Liu Bo wrote:
>> When doing div operation of u64 type, we need to be careful and use do_div
>> to avoid compile ERROR on 32bit box:
>>
>> "ERROR: "__udivdi3" [fs/btrfs/btrfs.ko] undefined!
>> make[1]: *** [__modpost] Error 1
>>
>> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> 
> Chris just left for vacation, can you send this to Linus/lkml so it gets pulled
> in.  Thanks,
> 

Already done.

thanks,
liubo

> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

