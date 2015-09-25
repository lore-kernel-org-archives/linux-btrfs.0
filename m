Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from portkey.s.itsis.si ([78.47.12.76]:60531 "EHLO
	portkey.s.itsis.si" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258AbbIYOe3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 10:34:29 -0400
Received: by ioii196 with SMTP id i196so112863052ioi.3
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 07:34:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150925135134.GF3749@carfax.org.uk>
References: <4362384.AA8xu4anSN@hoefnix>
	<3800342.Pn9bHBFuTx@hoefnix>
	<20150925135134.GF3749@carfax.org.uk>
Date: Fri, 25 Sep 2015 16:34:16 +0200
Message-ID: <CAEp_DRCiMRzuX8m9JoNO=8rtSWSP_Vqs4LfVW7JppDa2c4e_7w@mail.gmail.com>
Subject: Re: Latest kernel to use?
From: Bostjan Skufca <bostjan@a2o.si>
To: Hugo Mills <hugo@carfax.org.uk>, Sjoerd <sjoerd@sjomar.eu>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25 September 2015 at 15:51, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Fri, Sep 25, 2015 at 03:36:18PM +0200, Sjoerd wrote:
>> Thanks all for the feedback. Still doubting though to go for 4.2.1 or not.
>> Main reason is that I am currently running 4.1.7 on my laptop which seems to
>> work fine and had some issues with the 4.2.0 kernel. No issues I thing that
>> were btrfs related, but more related to my nvidia card. Anyway switching back
>> to 4.1.7 resolved those, so I am a bit holding back to try the 4.2.1 version
>> ;)
>> Anyway I'll see and can always revert back if I don't like it ;)
>
>    If 4.1.7 is working OK for you, stick with it. It's getting much
> less important now, as btrfs matures, to keep up with the _very_
> latest. Purely on gut feeling about issues we see on IRC and here,
> 3.19 or later would be reasonable at the moment.

Similar here: I am sticking with 3.19.2 which has proven to work fine
for me (backup systems with btrfs on lvm, lots of snapshots/subvolumes
and occasional rebalance, no fancy/fresh stuff like btrfs-raid, online
compression or subvolume quota, though this last one is tempting in my
use case).

b.
