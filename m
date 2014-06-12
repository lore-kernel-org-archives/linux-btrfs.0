Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:58940 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbaFLBSp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Jun 2014 21:18:45 -0400
From: Russell Coker <russell@coker.com.au>
To: kreijack@inwind.it
Reply-To: russell@coker.com.au
Cc: systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Slow startup of systemd-journal on BTRFS
Date: Thu, 12 Jun 2014 11:18:37 +1000
Message-ID: <1751055.d79eDl77JG@xev>
In-Reply-To: <5398CA16.3030609@libero.it>
References: <5398CA16.3030609@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 11 Jun 2014 23:28:54 Goffredo Baroncelli wrote:
>         https://bugzilla.redhat.com/show_bug.cgi?id=1006386
> 
> suggested me that the problem could be due to a bad interaction between
> systemd and btrfs. NetworkManager was innocent.  It seems that
> systemd-journal create a very hight fragmented files when it stores its
> log. And BTRFS it is know to behave slowly when a file is highly
> fragmented. This had caused a slow startup of systemd-journal, which in
> turn had blocked the services which depend by the loggin system.

On my BTRFS/systemd systems I edit /etc/systemd/journald.conf and put 
"SystemMaxUse=50M".  That doesn't solve the fragmentation problem but reduces 
it enough that it doesn't bother me.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

