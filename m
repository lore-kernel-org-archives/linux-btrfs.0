Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:18621 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3DYPE7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 11:04:59 -0400
Message-ID: <51794601.2030009@jan-o-sch.net>
Date: Thu, 25 Apr 2013 17:04:33 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
CC: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        wangshilong1991@gmail.com, dsterba@suse.cz
Subject: Re: [PATCH v3 2/3] Btrfs: rescan for qgroups
References: <1366716411-9750-1-git-send-email-list.btrfs@jan-o-sch.net> <1366716411-9750-3-git-send-email-list.btrfs@jan-o-sch.net> <5177BB51.8030400@cn.fujitsu.com> <5177F83E.20003@jan-o-sch.net> <517891E8.3060807@cn.fujitsu.com>
In-Reply-To: <517891E8.3060807@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, April 25, 2013 at 04:16 (+0200), Wang Shilong wrote:
> I just have an example in my mind, considering the following example:
>                   
>                       qgroup(1/1)
>                         /      \
>                        /        \
> 		   subv(257)   snapshot(260)              			
>                      |         /
>                      |        /  
> 		shared_extent
> 
> For the above example, your code can make qgroup(1/1)'s exclusive correct?
> 
> In your second step, you update every qgroup's referenced correct. But you only
> updte every qgroup's refcnt only once, so in your last step, you won't update qgroup
> (1/1)'s exlusive...Or am i missing someting ^_^

You're absolutely right. Will be fixed in v4. I only don't see how that could
possibly pass my previous tests.

Thanks,
-Jan
