Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46682 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756880Ab2FABnM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 21:43:12 -0400
Message-ID: <4FC81DDA.70004@cn.fujitsu.com>
Date: Fri, 01 Jun 2012 09:41:46 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: Update mtab if necessary when device was
 deleted in btrfs
References: <4FC747CF.2040703@cn.fujitsu.com> <20120531143148.GA2080@localhost.localdomain>
In-Reply-To: <20120531143148.GA2080@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 31 May 2012 10:31:48 -0400, Josef Bacik wrote:
> On Thu, May 31, 2012 at 06:28:31PM +0800, Miao Xie wrote:
>> Now if we remove the device that is specified when mounting, btrfs will update
>> the mount information in /proc, such as the information in /proc/mounts. So
>> in order to guarantee the consistency between /etc/mtab and the mount
>> information in /proc, we must update /etc/mtab. This patch does it.
>>
>> This patch need libmount and libmount-devel(version >= 2.19) packages to
>> compile.
>>
> 
> Does this work well with say Fedora where /etc/mtab is just a symlink to
> /proc/mounts?  Thanks,

Yes, if /etc/mtab is not a regular file, we will skip the update. And I have
do some test for it and all of them passed.

This patch can not work well on your machine?

Thanks
Miao
