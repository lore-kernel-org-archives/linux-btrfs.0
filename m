Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from okda.pipebreaker.pl ([176.56.236.173]:38785 "EHLO
	okda.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbbEIJlN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 9 May 2015 05:41:13 -0400
Received: from pipebreaker.pl
	([2001:470:71:68d::1] helo=mother.pipebreaker.pl ident=postfix)
	by okda.pipebreaker.pl with esmtps (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
	(Exim 4.84)
	(envelope-from <tomek@pipebreaker.pl>)
	id 1Yr0at-0008VZ-Q9
	for linux-btrfs@vger.kernel.org; Sat, 09 May 2015 10:58:47 +0200
Date: Sat, 9 May 2015 10:58:44 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs changes (issues?) on OS upgrade
Message-ID: <20150509085844.GA839393@mother.pipebreaker.pl>
References: <1798034232.614027.1431151384353.JavaMail.apache@nm33.abv.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1798034232.614027.1431151384353.JavaMail.apache@nm33.abv.bg>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 09, 2015 at 09:03:04AM +0300, Милен Христов wrote:
> 
> 1. Before the upgrade, the size of the entire array was reported as 9TB
> (roughly), both on the server (I use conky to monitor server status) and via
> samba on Windows clients. After the upgrade, the size is reduced to 4.55 TB
> which seems to better reflect what the actual usable space is, but is
> unexpected to me (I read some articles on the web about the difficulties in
> calculating free space on a btrfs filesystem). Is this expected?  > 

  This was changed in kernel 3.17:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ba7b6e62f420f5a8832bc161ab0c7ba767f65b3d
  Maybe your "before" ubuntu used older version?

-- 
Tomasz Torcz                Only gods can safely risk perfection,
xmpp: zdzichubg@chrome.pl     it's a dangerous thing for a man.  -- Alia

