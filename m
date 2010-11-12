From: Sander <sander@humilis.net>
Subject: Re: [PATCH v2 2/2] Cancel filesystem balance.
Date: Fri, 12 Nov 2010 10:07:55 +0100
Message-ID: <20101112090755.GA16221@attic.humilis.net>
References: <cover.1289522188.git.hugo@carfax.org.uk>
 <9b18b334410714aba2867f96e949f19243536ddc.1289522188.git.hugo@carfax.org.uk>
 <4CDC9971.6080903@cn.fujitsu.com>
 <4CDCC258.1050402@csamuel.org>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Li Zefan <lizf@cn.fujitsu.com>, Hugo Mills <hugo@carfax.org.uk>,
	linux-btrfs@vger.kernel.org,
	Goffredo Baroncelli <kreijack@libero.it>,
	Chris Mason <chris.mason@oracle.com>,
	liubo <liubo2009@cn.fujitsu.com>
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CDCC258.1050402@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Samuel wrote (ao):
> On 12/11/10 12:33, Li Zefan wrote:
> 
> > Is there any blocker that prevents us from canceling balance
> > by just Ctrl+C ?
> 
> Given that there's been at least 1 report of it taking 12 hours
> to balance a non-trivial amount of data I suspect putting this
> operation into the background by default and having the cancel
> option might be a better plan.
> 
> Thoughts ?

My humble opinion: I very much like the way mdadm works, with the
progress bar in /proc/mdstat if an array is rebuilding for example.

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
