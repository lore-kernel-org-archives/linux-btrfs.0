From: Chris Samuel <chris@csamuel.org>
Subject: Re: [PATCH v2 2/2] Cancel filesystem balance.
Date: Fri, 12 Nov 2010 15:28:08 +1100
Message-ID: <4CDCC258.1050402@csamuel.org>
References: <cover.1289522188.git.hugo@carfax.org.uk> <9b18b334410714aba2867f96e949f19243536ddc.1289522188.git.hugo@carfax.org.uk> <4CDC9971.6080903@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org,
	Goffredo Baroncelli <kreijack@libero.it>,
	Chris Mason <chris.mason@oracle.com>,
	liubo <liubo2009@cn.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4CDC9971.6080903@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/11/10 12:33, Li Zefan wrote:

> Is there any blocker that prevents us from canceling balance
> by just Ctrl+C ?

Given that there's been at least 1 report of it taking 12 hours
to balance a non-trivial amount of data I suspect putting this
operation into the background by default and having the cancel
option might be a better plan.

Thoughts ?

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
