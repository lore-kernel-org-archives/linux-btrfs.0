Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 12.mo4.mail-out.ovh.net ([178.33.104.253]:47642 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758444AbaJaOpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 10:45:05 -0400
Received: from mail639.ha.ovh.net (b6.ovh.net [213.186.33.56])
	by mo4.mail-out.ovh.net (Postfix) with SMTP id EBA80FF95FB
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Oct 2014 09:45:25 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: Quota question
From: Cyril Scetbon <cyril.scetbon@free.fr>
In-Reply-To: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr>
Date: Fri, 31 Oct 2014 09:45:23 +0100
Message-Id: <F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr>
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Besides the first question, I met an issue using parent groups (see http://pastebin.com/asT5ZFsi). I can't reproduce it all the time, but it seems to appear frequently. Is there any know BUG that can be the source of this error ? I'm using version 3.12 on Trusty

Thanks
-- 
Cyril SCETBON

> On 30 Oct 2014, at 19:37, Cyril Scetbon <cyril.scetbon@free.fr> wrote:
> 
> Hi,
> 
> At https://btrfs.wiki.kernel.org/index.php/Quota_support it's said that "Using btrfs subvolume delete will break qgroup unshared space usage". Does it mean that if the qgroup associated with the subvolume is attached to another qgroup, this other qgroup won't be able to correctly apply its quota ? If yes, is there a workaround for that ?
> 
> Thanks
> -- 
> Cyril SCETBON
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

