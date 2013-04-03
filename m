Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46879 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab3DCQ6P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2013 12:58:15 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr17so3858117wib.11
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Apr 2013 09:58:12 -0700 (PDT)
Message-ID: <515C5FB0.2060106@gmail.com>
Date: Wed, 03 Apr 2013 18:58:24 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] btrfs fi df doesn't show raid type after balance
References: <515BCAB5.30403@oracle.com>
In-Reply-To: <515BCAB5.30403@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/03/2013 08:22 AM, Anand Jain wrote:
> 
> 
> Did something break.. ? we are not reporting raid type after balance.
> 
> -----------
> # btrfs fi df /btrfs
> Data, RAID0: total=2.00GB, used=2.03MB
> Data: total=8.00MB, used=0.00
> System, RAID0: total=16.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID0: total=2.00GB, used=216.00KB
> Metadata: total=8.00MB, used=4.00KB
> 
> # btrfs bal /btrfs
> Done, had to relocate 5 out of 5 chunks
> 
> # btrfs fi df /btrfs
> Data: total=1.00GB, used=2.78MB
> System: total=4.00MB, used=4.00KB
> Metadata: total=1.00GB, used=276.00KB
> #
> -----------
> 
> btrfs-progs is at integration-20130321 and 3.8.0+

I already saw this. When the filesystem is empty a balance revert the
RAID mode to the single one. If the filesystem is not empty I was not
able to reproduce this.

> 
> Thakns
> Anand
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
