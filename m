Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:45207 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab2INMza (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 08:55:30 -0400
Message-ID: <5053293B.6010400@oracle.com>
Date: Fri, 14 Sep 2012 20:55:23 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] Btrfs: kill obsolete arguments in btrfs_wait_ordered_extents
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com> <1347613087-3489-5-git-send-email-bo.li.liu@oracle.com> <20120914124516.GK12994@localhost.localdomain>
In-Reply-To: <20120914124516.GK12994@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/14/2012 08:45 PM, Josef Bacik wrote:
> On Fri, Sep 14, 2012 at 02:58:07AM -0600, Liu Bo wrote:
>> nocow_only is now an obsolete argument.
>>
> 
> Why is it obsolete, it looks like it's being used to me?  Thanks,
> 

All of its callers use 0 as nocow_only now.

thanks,
liubo

> Josef
> 

