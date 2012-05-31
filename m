Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726Ab2EaPEg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 May 2012 11:04:36 -0400
Date: Thu, 31 May 2012 10:31:48 -0400
From: Josef Bacik <josef@redhat.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: Update mtab if necessary when device was
 deleted in btrfs
Message-ID: <20120531143148.GA2080@localhost.localdomain>
References: <4FC747CF.2040703@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FC747CF.2040703@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 31, 2012 at 06:28:31PM +0800, Miao Xie wrote:
> Now if we remove the device that is specified when mounting, btrfs will update
> the mount information in /proc, such as the information in /proc/mounts. So
> in order to guarantee the consistency between /etc/mtab and the mount
> information in /proc, we must update /etc/mtab. This patch does it.
> 
> This patch need libmount and libmount-devel(version >= 2.19) packages to
> compile.
> 

Does this work well with say Fedora where /etc/mtab is just a symlink to
/proc/mounts?  Thanks,

Josef
