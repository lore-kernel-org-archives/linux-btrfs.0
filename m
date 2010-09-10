From: Simon Kirby <sim@hostway.ca>
Subject: Re: 2.6.35.4 fumble-spolision
Date: Fri, 10 Sep 2010 09:50:32 -0700
Message-ID: <20100910165032.GA8590@hostway.ca>
References: <20100910001703.GF26862@hostway.ca> <20100910004909.GX3227@think> <20100910075417.GA28151@hostway.ca> <AANLkTinDu0Rw+E+0-D1u3ZCXtUtd=G0Y0R3Aa=UCg_8W@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: "Yan, Zheng " <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinDu0Rw+E+0-D1u3ZCXtUtd=G0Y0R3Aa=UCg_8W@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 10, 2010 at 04:21:16PM +0800, Yan, Zheng  wrote:

> > ? ? ? ? ? ? ? ?tree block key (5643880 60 602) level 0
> > ? ? ? ? ? ? ? ?tree block backref root 853
> > failed to find block number 1923814297600
> > Abort
> 
> How large is the FS ? Is it possible to run btrfs-image and send the
> output file to us?

It's 3 TB.  I was running btrfs-image since last night but my ssh got
disconnected before it finished.  I'm running it again in screen now, but
the image it made before was 3.8 GB.  Would this be useful to you?

We have a number of file systems of this size, and they normally look
something like this (note compress-force is being used also):

Data: total=2.87TB, used=2.09TB
Metadata: total=44.13GB, used=27.04GB
System: total=12.00MB, used=368.00KB

Simon-
