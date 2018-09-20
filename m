Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:40957 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731675AbeITMGP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Sep 2018 08:06:15 -0400
Received: from t460-skr.localnet ([194.94.224.254]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0M9Jss-1fwmWK0hQs-00CgpU for
 <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2018 08:24:26 +0200
From: Stefan K <shadow_7@gmx.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs filesystem show takes a long time
Date: Thu, 20 Sep 2018 08:24:25 +0200
Message-ID: <2057542.pIGOqnJYbl@t460-skr>
In-Reply-To: <20180914112530.GV2154@twin.jikos.cz>
References: <3275334.7C4KuSQybz@t460-skr> <20180914112530.GV2154@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> You may try to run the show command under strace to see where it blocks.
any recommendations for strace options?


On Friday, September 14, 2018 1:25:30 PM CEST David Sterba wrote:
> Hi,
> 
> thanks for the report, I've forwarded it to the issue tracker
> https://github.com/kdave/btrfs-progs/issues/148
> 
> The show command uses the information provided by blkid, that presumably
> caches that. The default behaviour of 'fi show' is to skip mount checks,
> so the delays are likely caused by blkid, but that's not the only
> possible reason.
> 
> You may try to run the show command under strace to see where it blocks.
> 
