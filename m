Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18734 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaF3PHN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jun 2014 11:07:13 -0400
Message-ID: <53B17D0E.2050302@oracle.com>
Date: Mon, 30 Jun 2014 23:06:54 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: fix null pointer dereference in clone_fs_devices
 when name is null
References: <1404119568-4097-1-git-send-email-Anand.Jain@oracle.com> <53B135B2.5060405@cn.fujitsu.com>
In-Reply-To: <53B135B2.5060405@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> The primary reason of this problem is that we didn't scan the system and
> find all the devices in the filesystem, if we scan the system, we can
> mount the filesystem successfully, needn't mount it with degraded option.
> so I think the right way to fix is to scan the system and find the device
> that is not registered into the fs device list.

Thanks for commenting. Right. But I am testing the error
scenario. that is, when one of the disk is missing in the system.

Thanks, Anand
