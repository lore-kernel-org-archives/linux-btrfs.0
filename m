Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35345 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab3BUPwQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 10:52:16 -0500
Date: Thu, 21 Feb 2013 23:50:53 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Subject: Re: Another defrag question
Message-ID: <20130221155052.GA4628@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <51264146.3070504@petaramesh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <51264146.3070504@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 21, 2013 at 04:46:14PM +0100, Swâmi Petaramesh wrote:
> Hi again,
> 
> Having numerous snapshots, I prefer to ask rather than take the risk of
> exploding my storage space, better safe than sorry ;-)
> 
> "man btrfs" states :
> 
> « NOTE: defragmenting with kernels up to 2.6.37 will unlink COW-ed
> copies of data, don't use it if  you  use  snapshots,  have 
> deduplicated  your  data  or  made  copies with cp --reflink. »
> 
> I use :
> # uname -r
> 3.5.0-24-generic
> 
> ...So should I expect that defraging my BTRFS will be smart enough not
> to uncow my snapshots ? Is it actually able to defrag both the file and
> its snapshots altogether, keeping all this as a single physical copy of
> the defragged data ?

Well, there is already a patch which addresses your concern and it's
'snapshot-aware defrag' feature and now in v6, it's not merged yet.

thanks,
liubo

> 
> TIA.
> 
> -- 
> Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
> Ne cherchez pas : Je ne suis pas sur Facebook.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
