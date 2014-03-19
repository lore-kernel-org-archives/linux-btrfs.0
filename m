Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49557 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381AbaCSIoG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Mar 2014 04:44:06 -0400
Date: Wed, 19 Mar 2014 16:43:56 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Another crash when deleting a large number of snapshots
Message-ID: <20140319084355.GD21531@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAC+fKQUPg7kwNgW+0E1h4uVTuDvp9ki=X4Ht=w3EVDQopdFDoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAC+fKQUPg7kwNgW+0E1h4uVTuDvp9ki=X4Ht=w3EVDQopdFDoA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 19, 2014 at 08:52:37AM +0100, Juan Orti Alcaine wrote:
> This kind of crashes happens me very often when I delete a large
> number (+200) of snapshots at once.
> There is a very high IO for a while, and after that, the system
> freezed at intervals. I had to reboot the system to get it responsive
> again.
> 
> Versions used:
> kernel-3.13.6-200.fc20.x86_64
> btrfs-progs-3.12-1.fc20.x86_64
> 
> The log:
> http://ur1.ca/gvr3j

Not sure if this has been fixed...

Can you try btrfs-next or compile the kernel with CONFIG_DEBUG_SPINLOCK=y?

thanks,
-liubo
