Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:56640 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2HBQSN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Aug 2012 12:18:13 -0400
Received: from 89-156-116-126.rev.numericable.fr ([89.156.116.126] helo=[192.168.0.10])
	by licorne.daevel.fr with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <btrfs.list@daevel.fr>)
	id 1Swy6F-0000I7-FA
	for linux-btrfs@vger.kernel.org; Thu, 02 Aug 2012 18:18:11 +0200
Message-ID: <501AA842.5080300@daevel.fr>
Date: Thu, 02 Aug 2012 18:18:10 +0200
From: Olivier Bonvalet <btrfs.list@daevel.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:5038 (linux 3.4.7)
References: <501987FF.9080304@daevel.fr> <20120802132259.GO17430@twin.jikos.cz> <501A836F.90506@daevel.fr> <20120802135354.GQ17430@twin.jikos.cz>
In-Reply-To: <20120802135354.GQ17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/08/2012 15:53, David Sterba wrote:
> On Thu, Aug 02, 2012 at 03:41:03PM +0200, Olivier Bonvalet wrote:
>> Yes... it's a copy from my /var/log/kern.log. Is it really "disabled" ?
>
> I was mistaken, it really is enabled unconditionally in ctree.h:55.
> Josef says that the V0 extent refs are not used for a long time, so the
> question is how did they appear in your filesystem. Did you switch to a
> new kernel from a very old one?
>
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

mmm I have upgraded that system every two months, but the first setup is 
from april 2011 I think.

Should I start a "scrub" on all that systems installed a long time ago ?
