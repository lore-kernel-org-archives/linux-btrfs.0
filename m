Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18889 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3IMKtX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 06:49:23 -0400
Message-ID: <5232EDA6.6060902@oracle.com>
Date: Fri, 13 Sep 2013 18:49:10 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] btrfs-progs: use kernel for mounted and lblkid
 to scan disks
References: <1377851756-4009-1-git-send-email-anand.jain@oracle.com> <1378460273-20647-1-git-send-email-anand.jain@oracle.com> <1378460273-20647-2-git-send-email-anand.jain@oracle.com> <20130912163629.GD6810@twin.jikos.cz>
In-Reply-To: <20130912163629.GD6810@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> Thanks for implementing it! I found a few things to fix, comments below.
>
> I wonder if we should keep --all-devices as a last resort fallback eg.

  Any idea whats the real use of --all-devices option anyway
  I am unsure. Anyway will restore --all-devices so now.

  all other suggestion were considered as well.

> I see this warning and there are no mounted filesystems listed in the
> output:
>
> $ ./btrfs fi show
> ERROR: scan kernel failed, -1
>

when does this happen ? I can't reproduce it.

Thanks, Anand
