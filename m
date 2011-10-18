From: Josef Bacik <josef@redhat.com>
Subject: Re: ls hangs filesystem
Date: Tue, 18 Oct 2011 10:04:47 -0400
Message-ID: <20111018140446.GC4276@localhost.localdomain>
References: <4E9D7E5A.2010403@webstarts.com>
 <20111018133137.GB4276@localhost.localdomain>
 <4E9D835F.1010706@webstarts.com>
 <20111018134926.GA24163@attic.humilis.net>
 <4E9D873C.8050801@webstarts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sander@humilis.net, Josef Bacik <josef@redhat.com>,
	linux-btrfs@vger.kernel.org
To: Jim <jim@webstarts.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E9D873C.8050801@webstarts.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 18, 2011 at 10:03:40AM -0400, Jim wrote:
> I am getting no output from echo 'w' > /proc/sysrq-trigger.  Ls is
> hung again so I can try any thing else you suggest to get data.

Do

echo 1> /proc/sys/kernel/sysrq

and then try doing the echo w thing.  Thanks,

Josef
