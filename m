From: Tore Anderson <tore.anderson@redpill-linpro.com>
Subject: Re: Crash in __btrfs_reserve_extent
Date: Thu, 06 Aug 2009 19:15:35 +0200
Message-ID: <4A7B0FB7.2010401@redpill-linpro.com>
References: <200908061657.50989.Dessa@gmake.de> <20090806152058.GF3655@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: =?ISO-8859-1?Q?Robert_F=F6rster?= <Dessa@gmake.de>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090806152058.GF3655@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

* Josef Bacik

> Alrighty, so btrfs-show says you have used up all of your disk, but
> for some reason statfs is saying you havent.  Can you cd into / and
> run
> 
> du -h -s
> 
> and then wait a very long time and then tell me what it comes back
> with :). That will tell us for sure what the hell is going on.  Thank
> you,

I think this needs to be "du -h -s -x" (otherwise you'll include space
used by files on other file systems as well).

Best regards,
-- 
Tore Anderson
Redpill Linpro AS - http://www.redpill-linpro.com/
Tel: +47 21 54 41 27
