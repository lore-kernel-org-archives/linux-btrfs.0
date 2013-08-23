Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44127 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3HWGiw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 02:38:52 -0400
Message-ID: <521704FA.60705@oracle.com>
Date: Fri, 23 Aug 2013 14:45:14 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: introduce BTRFS_IOC_CHECK_DEV_EXCL_OPS ioctl to
 check dev excl op
References: <1377090643-23658-1-git-send-email-anand.jain@oracle.com> <5214C78C.3030001@giantdisaster.de> <5215DF29.3030100@oracle.com> <5215E9A8.3060900@giantdisaster.de>
In-Reply-To: <5215E9A8.3060900@giantdisaster.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>   Further CHECK_DEV_EXCL_OPS will be useful to fix issues with
>>   other cross vol operations.
>
> Which issues? Please share the details.
> The other commands do not background and do report errors.

  I am assuming potentially required (to background) for balance,
  remove and resize.

Thanks, Anand
