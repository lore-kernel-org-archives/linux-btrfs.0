From: Josef Bacik <josef@redhat.com>
Subject: Re: ls hangs filesystem
Date: Tue, 18 Oct 2011 10:09:12 -0400
Message-ID: <20111018140911.GD4276@localhost.localdomain>
References: <4E9D7E5A.2010403@webstarts.com>
 <20111018133137.GB4276@localhost.localdomain>
 <4E9D835F.1010706@webstarts.com>
 <20111018134926.GA24163@attic.humilis.net>
 <4E9D873C.8050801@webstarts.com>
 <20111018140446.GC4276@localhost.localdomain>
 <4E9D885E.4000602@webstarts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, sander@humilis.net,
	linux-btrfs@vger.kernel.org
To: Jim <jim@webstarts.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E9D885E.4000602@webstarts.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 18, 2011 at 10:08:30AM -0400, Jim wrote:
> Yes, I had thought of that as well but still no output.  Ls has been
> hung for about 30 min now and shows as D+ in ps.  Do you think it
> would get us any information if I forced a reboot and redid the
> entire sequence running sysrq-trigger right after starting ls?

Maybe sysrq+t will get it?  Thanks,

Josef
