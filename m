Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49171 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383AbaIFUF0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 6 Sep 2014 16:05:26 -0400
Message-ID: <540B6900.7000307@fb.com>
Date: Sat, 6 Sep 2014 16:05:20 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC 0/5] Scan all devices to build fs device list
References: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/03/2014 09:36 AM, Miao Xie wrote:
> This patchset implements device list automatic building function. As we
> know, currently we need scan the devices to build device list by a user tool
> before mounting the filesystem, especially mount the filesystem after
> we re-install btrfs module. It is not convenient. This patchset can improve
> that problem. With this patchset, we will scan all the devices in the
> system to build the device list if we find the number of the devices
> is not right when we mount the filesystem. By this way, we needn't scan
> the device by the user tool and reduce the mount failure probability due
> to the incomplete device list.

Thanks for working on these patches, but I really prefer that we do
these scans from userspace.  I know it introduces a few problems, but it
also solves a lot of complexity at the same time.  And udev already has
most of the info we need, so I think our time is best spent fixing any
problems with the udev integration.

-chris
