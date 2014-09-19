Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:29261 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751103AbaISBbP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 21:31:15 -0400
Message-ID: <1411090230.28980.6.camel@localhost.localdomain>
Subject: Re: fs corruption report
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Zooko Wilcox-OHearn <zooko@leastauthority.com>
CC: Marc Dietrich <marvin24@gmx.de>, <linux-btrfs@vger.kernel.org>
Date: Fri, 19 Sep 2014 09:30:30 +0800
In-Reply-To: <CAM_a8JzKth0_zG6cGoQeWHB3Dpro42wfEtS5QJXtFZT1xNoZYQ@mail.gmail.com>
References: <CAM_a8JxJBFQykuF13UF1Fi9jbM-=yromXbQ5PrWM5JPR7u6pXA@mail.gmail.com>
	 <CAM_a8Jy3kwxtDvJ36T0hVrGRBbOK34MOEqZY0GhUUyAUHJMnCw@mail.gmail.com>
	 <1411011561.22018.3.camel@localhost.localdomain>
	 <5786662.mcQW9aUYte@fb07-iapwap2>
	 <CAM_a8JzKth0_zG6cGoQeWHB3Dpro42wfEtS5QJXtFZT1xNoZYQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-09-18 at 12:47 +0000, Zooko Wilcox-OHearn wrote:
> Thank you! I will try to restore using this patch.
> 
> What branch of what btrfs tools git repo should I apply the patch to?
> 
> Regards,
> 
> Zooko

At least I think the following repo/v3.17.x branch has all
restore-related patches included.

git://github.com/kdave/btrfs-progs.git

This is a mirror of the latest devel repo that I am on.

-Gui




