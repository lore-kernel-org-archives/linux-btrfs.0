From: Sander <sander@humilis.net>
Subject: Re: ls hangs filesystem
Date: Tue, 18 Oct 2011 16:08:49 +0200
Message-ID: <20111018140849.GA27152@attic.humilis.net>
References: <4E9D7E5A.2010403@webstarts.com>
 <20111018133137.GB4276@localhost.localdomain>
 <4E9D835F.1010706@webstarts.com>
 <20111018134926.GA24163@attic.humilis.net>
 <4E9D873C.8050801@webstarts.com>
 <20111018140446.GC4276@localhost.localdomain>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jim <jim@webstarts.com>, sander@humilis.net,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111018140446.GC4276@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Josef Bacik wrote (ao):
> On Tue, Oct 18, 2011 at 10:03:40AM -0400, Jim wrote:
> > I am getting no output from echo 'w' > /proc/sysrq-trigger.  Ls is
> > hung again so I can try any thing else you suggest to get data.
> 
> Do
> 
> echo 1> /proc/sys/kernel/sysrq
> 
> and then try doing the echo w thing.  Thanks,

Jim, sorry if I'm stating the obvious here, but the output will be in
dmesg (and syslog if possible).

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
