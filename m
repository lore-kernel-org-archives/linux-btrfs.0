Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.97.166]:51233 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917AbaKUEfp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 23:35:45 -0500
Date: Fri, 21 Nov 2014 09:35:43 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Boris Chernov <aqs1024@hotmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Changing label few times killed filesystem?
Message-ID: <20141121093543.6685cbe5@natsu>
In-Reply-To: <BLU436-SMTP7537F1DDEF63F43667E45CAB770@phx.gbl>
References: <BLU436-SMTP7537F1DDEF63F43667E45CAB770@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 21 Nov 2014 01:27:17 +0000
Boris Chernov <aqs1024@hotmail.com> wrote:

> 
>      I have changed file system label few times in total. When I tried 
> to mount it after that, it became not mountable:
> 
> # mount /dev/sdb1 /mnt
> mount: Not a directory

I'd say that implies something is wrong with your /mnt, rather than /dev/sdb1.
Before mounting try things like "ls -la /mnt/", "umount /mnt", etc.
Or simply mounting somewhere else other than /mnt/

-- 
With respect,
Roman
