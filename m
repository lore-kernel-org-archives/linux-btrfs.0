Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:34331 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaIUN0P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Sep 2014 09:26:15 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
	Sun, 21 Sep 2014 07:26:15 -0600
Date: Sun, 21 Sep 2014 06:25:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Chris Mason <clm@fb.com>
Cc: Omar Sandoval <osandov@osandov.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Move BTRFS RCU string to common library
Message-ID: <20140921132556.GJ4723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1411116672.git.osandov@osandov.com>
 <20140919154546.GZ4723@linux.vnet.ibm.com>
 <541C5029.1070500@fb.com>
 <20140919160555.GD4723@linux.vnet.ibm.com>
 <541C5861.4040403@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <541C5861.4040403@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 19, 2014 at 12:22:57PM -0400, Chris Mason wrote:
> On 09/19/2014 12:05 PM, Paul E. McKenney wrote:
> > On Fri, Sep 19, 2014 at 11:47:53AM -0400, Chris Mason wrote:
> >>
> >>
> >> On 09/19/2014 11:45 AM, Paul E. McKenney wrote:
> >>> On Fri, Sep 19, 2014 at 02:01:28AM -0700, Omar Sandoval wrote:
> >>>> This patch series moves the generic RCU string library used internally by BTRFS
> >>>> to be accessible by anyone. It provides printk_in_rcu and
> >>>> printk_ratelimited_in_rcu to print these strings. In order to avoid a weird
> >>>> inconsistency between the two, the first patch fixes printk_ratelimited so it
> >>>> passes on the return value from printk.
> >>>>
> >>>> The second patch actually moves the RCU string library. Version 2 passes on the
> >>>> return values from printk{,_ratelimited} and fixes some style issues.
> >>>>
> >>>> Omar Sandoval (2):
> >>>
> >>> For the series:
> >>>
> >>> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >>
> >> Fine by me too, Paul, do you want to merge it in?
> > 
> > I would be happy to.
> > 
> > Are you thinking in terms of 3.18 or 3.19?  These look OK either way, but
> > thought I should check.
> 
> Either way is fine with me.  Actually this will have minor conflicts
> with my current branch headed for-next, so I can resolve and send as a
> stand alone pull.

There are no conflicts with RCU, just adding a file, so I am just as
happy to have you send this via your tree.

							Thanx, Paul

