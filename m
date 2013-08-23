Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.jellyfishnet.co.uk ([93.91.20.10]:21654 "EHLO
	mail2.jellyfishnet.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3HWJDZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 05:03:25 -0400
From: Mark Ridley <mark@backupsystems.co.uk>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Fri, 23 Aug 2013 10:03:22 +0100
Subject: Re: Samba strict allocate  = yes stops btrfs compression working
Message-ID: <CE3CE3BC.3C431%mark@backupsystems.co.uk>
In-Reply-To: <6t1iea-qg7.ln1@hurikhan77.spdns.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I tried defrag -c and it does nothing to files that have come in with
strict allocate = yes.

On 22/08/2013 19:29, "Kai Krakow" <hurikhan77+btrfs@gmail.com> wrote:

>Josef Bacik <jbacik@fusionio.com> schrieb:
>
>> Not sure what strict allocate = yes does, but I assume it probably does
>> fallocate() in which case yeah we aren't going to compress, we'll just
>> write
>> into the preallocated space.  We don't support compressed writes into
>> preallocated space ATM, and I'm not sure we ever will.  Thanks,
>
>Good to know, this renders btrfs as efficient storage backend for Windows
>file shares pretty useless. Does this also happen with compress-force?
>
>As a work-around one could write a cronjob that regularly defrags all
>files 
>changed since the last run with -c option...
>
>Thanks,
>Kai
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

