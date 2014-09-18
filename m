Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64832 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757177AbaIRDkB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 23:40:01 -0400
Message-ID: <1411011561.22018.3.camel@localhost.localdomain>
Subject: Re: fs corruption report
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Zooko Wilcox-OHearn <zooko@leastauthority.com>
CC: Marc Dietrich <marvin24@gmx.de>, <linux-btrfs@vger.kernel.org>
Date: Thu, 18 Sep 2014 11:39:21 +0800
In-Reply-To: <CAM_a8Jy3kwxtDvJ36T0hVrGRBbOK34MOEqZY0GhUUyAUHJMnCw@mail.gmail.com>
References: <CAM_a8JxJBFQykuF13UF1Fi9jbM-=yromXbQ5PrWM5JPR7u6pXA@mail.gmail.com>
	 <1409192882.1582.13.camel@localhost.localdomain>
	 <1484373.Oezxgh4u8P@ax5200p> <5322846.kPR8ohTNYd@ax5200p>
	 <CAM_a8Jy3kwxtDvJ36T0hVrGRBbOK34MOEqZY0GhUUyAUHJMnCw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2014-09-01 at 15:25 +0000, Zooko Wilcox-OHearn wrote:
> I'm more than happy to try out patches and even focus my own brain on
> diagnosing it, if I can. I'm hoping to regain access to some of my
> files on my btrfs partition, and also I would enjoy helping get this
> improved. :-)
> 
> So if you want me to try an experiment, just email me. Unfortunately I
> can't just give you a copy of the partition, since it has confidential
> information on it.
> 
> Regards,
> 
> Zooko

Hi, Zooko, Marc,
I'm glad that I could send some feedbacks,
The following piece deals with the lzo decompress problem with restore

https://patchwork.kernel.org/patch/4928831/

Hope that it helps.

-Gui

