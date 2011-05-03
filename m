From: Bernhard Schmidt <berni@birkenwald.de>
Subject: Re: abysmal performance
Date: Tue, 03 May 2011 15:03:19 +0200
Message-ID: <4DBFFD17.8080702@birkenwald.de>
References: <1304088305-sup-3784@localhost> <1304089239-sup-5110@think> <BANLkTi=6YHDSmcg5DiHPiL1xWdT1nWobBg@mail.gmail.com> <20110430235539.6205.qmail@stuge.se> <ipolll$2h0$1@dough.gmane.org> <1304420831-sup-4737@think> <4DBFE75C.2000104@birkenwald.de> <1304422493-sup-6212@think> <4DBFEA48.3000406@birkenwald.de> <1304427015-sup-4772@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304427015-sup-4772@think>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> Ok, looks like we could be doing a little better job when compression is
> on to build out a bigger extent.  This shouldn't be causing trouble on
> an ssd at all but on your rotating disk it'll be slightly slower.
> 
> Still most of these extents are somewhat close together, this is roughly
> what mount -o ssd (which is enabled automatically when we detect a
> non-rotating drive) would try for.
> 
> The problematic files are going to have thousands of extents, this file
> should be fine.

Thanks, I'll check on my system with rotating disks at home when I get back.

Bernhard
