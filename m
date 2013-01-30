Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:33606 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924Ab3A3SWQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 13:22:16 -0500
Date: Wed, 30 Jan 2013 13:22:13 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Mike Lowe <j.michael.lowe@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>, Sage Weil <sage@inktank.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "billk@iinet.net.au" <billk@iinet.net.au>
Subject: Re: corrupted file size on inline extent conversion?
Message-ID: <20130130182213.GI3660@localhost.localdomain>
References: <alpine.DEB.2.00.1301281602060.8729@cobra.newdream.net>
 <20130129145429.GD3660@localhost.localdomain>
 <08479684-218C-4B6E-8D76-DE39B36EE12E@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <08479684-218C-4B6E-8D76-DE39B36EE12E@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 30, 2013 at 11:17:25AM -0700, Mike Lowe wrote:
> Well I found this, so I think it's likely:
> 
> root@gwboss2:~# dmesg |grep bitten
> [ 3196.193238] this would have bitten us in the ass
> [ 3196.193784] this would have bitten us in the ass
> 

Well that makes me happy since I had almost talked myself out of this being a
possiblity.  How long did it take you to hit this problem before and how long
have you been running with this patch?  Thanks,

Josef
