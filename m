Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:47146 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbcFULqy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 07:46:54 -0400
Subject: Re: [PATCH v2 2/2] btrfs: wait for bdev put
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1465901726-15490-2-git-send-email-anand.jain@oracle.com>
 <1466504648-2937-1-git-send-email-anand.jain@oracle.com>
Cc: clm@fb.com, dsterba@suse.com, xiaolong.ye@intel.com
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <5769292C.6030208@applied-asynchrony.com>
Date: Tue, 21 Jun 2016 13:46:52 +0200
MIME-Version: 1.0
In-Reply-To: <1466504648-2937-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/21/16 12:24, Anand Jain wrote:
> From: Anand Jain <Anand.Jain@oracle.com>
> 
> Further to the commit
>      bc178622d40d87e75abc131007342429c9b03351
>      btrfs: use rcu_barrier() to wait for bdev puts at unmount
> 
> This patch implements a method to time wait on the __free_device()
> which actually does the bdev put. This is needed as the user space
> running 'btrfs fi show -d' immediately after the replace and
> unmount, is still reading older information from the device.
> 
>  mail-archive.com/linux-btrfs@vger.kernel.org/msg54188.html
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> [updates: bc178622d40d87e75abc131007342429c9b03351]
> ---
> v2: Also to make sure bdev_closing is set it needs rcu_barrier(),
>     restored rcu_barrier().

Looks like this one works reliably again. ;)
Tested with a slow disk, no long unmounts or timeout messages.

Tested-by: Holger Hoffstätte <holger.hoffstaette@applied-asynchrony.com>

thanks!
Holger

