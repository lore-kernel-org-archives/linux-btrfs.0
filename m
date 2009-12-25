From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: btrfsctl exit with 1 when succeed
Date: Fri, 25 Dec 2009 09:19:14 +0900
Message-ID: <4B340502.10806@jp.fujitsu.com>
References: <E88DD564E9DC5446A76B2B47C3BCCA150221B14DD3@pdsmsx503.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: zhipeng.gong@intel.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <E88DD564E9DC5446A76B2B47C3BCCA150221B14DD3@pdsmsx503.ccr.corp.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

I also want to know why this conversion is needed.
This might be a typo, I think.

Could someone tell us why?
Can we fix this conversion? Or shouldn't we fix it
considering back-compatibility?

Regards,
taruisi

(2009/11/11 15:16), Gong, Zhipeng wrote:
> We'd like to use btrfsctl in a shell script, however, btrfsctl exit with 1 even if the operation is successful, which is opposite to the usual shell command convention.
> Why btrfsctl add this conversion in the end?
>          if (ret)
>                   exit(0);
>          else
>                   exit(1);
> 
> Thanks
> Zhipeng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

