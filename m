Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dub004-omc3s23.hotmail.com ([157.55.2.32]:59865 "EHLO
	DUB004-OMC3S23.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932624AbaJXRzG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Oct 2014 13:55:06 -0400
Message-ID: <DUB118-W8DE2E384783A11BF1F307DA930@phx.gbl>
From: Jasper Verberk <jverberk@hotmail.com>
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: RE: Problem converting data raid0 to raid1: enospc errors during
 balance
Date: Fri, 24 Oct 2014 17:49:55 +0000
In-Reply-To: <D3C31CA0-D46E-47A6-8EAD-74DFDF549902@colorremedies.com>
References: <DUB118-W4605047D55E17E62C8F651DA930@phx.gbl>,<D3C31CA0-D46E-47A6-8EAD-74DFDF549902@colorremedies.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Did that, you can find the result in the pastebin.

http://paste.debian.net/128552/

----------------------------------------
> Subject: Re: Problem converting data raid0 to raid1: enospc errors during balance
> From: lists@colorremedies.com
> Date: Fri, 24 Oct 2014 11:11:21 -0600
> To: linux-btrfs@vger.kernel.org; jverberk@hotmail.com
>
>
> On Oct 24, 2014, at 7:32 AM, Jasper Verberk <jverberk@hotmail.com> wrote:
>>
>> [60104.040776] BTRFS info (device sdc): 1046 enospc errors during balance
>
>
> To get more information, remount with enospc_debug option, and try to convert again.
>
>> root@BlackMesa:/mnt# btrfs --version
>> Btrfs v3.14.1
>
> There are many fixes since this version, I suggest going to 3.17 which also has a lot of new fsck code in case that ends up being needed. You can try btrfs-image again. Then see if btrfs check (without --repair) shows anything suspicious.
>
>
> Chris Murphy
>
 		 	   		  