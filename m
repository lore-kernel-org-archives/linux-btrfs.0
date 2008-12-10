From: calin <calin@splitreflection.com>
Subject: Re: Selective Compression/Encryption
Date: Tue, 09 Dec 2008 16:03:04 -0800
Message-ID: <1228867384.2131@splitreflection.com>
References: <20081209145952.GA30494@tux64-03>	<f058a9c30812090745v15b5f983u468b560ae791dc37@mail.gmail.com>	<200812091722.21567.mail@earthworm.de>	<20081209180951.GA6551@tux64-03> <20081210000512.7be20413@diego-desktop>     <493F043B.50804@hp.com>
Reply-To: calin@splitreflection.com
Mime-Version: 1.0
Content-Type: text/plain
Cc: Lee Trager <lt73@cs.drexel.edu>,
	Christian Hesse <mail@earthworm.de>, miguel.filipe@gmail.com,
	linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>, Diego Calleja <diegocg@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <493F043B.50804@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

> While I have not gotten far enough to prove it is feasible...
> 
> My idea on controlling features like compression is that
> the default mode is inherited from the parent in the
> directory tree.  Thus you can turn it on/off at whatever
> granularity you want.
> 

That seems like the ideal solution to me.  Similar to how default ACLs work.

-John
