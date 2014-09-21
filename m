Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay0118.hostedemail.com ([216.40.44.118]:37306 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751204AbaIUPxJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Sep 2014 11:53:09 -0400
Message-ID: <1411314785.2952.8.camel@joe-AO725>
Subject: Re: [PATCH v2 1/2] Return a value from printk_ratelimited
From: Joe Perches <joe@perches.com>
To: paulmck@linux.vnet.ibm.com, Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>, Omar Sandoval <osandov@osandov.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Date: Sun, 21 Sep 2014 08:53:05 -0700
In-Reply-To: <20140921132512.GI4723@linux.vnet.ibm.com>
References: <cover.1411116672.git.osandov@osandov.com>
	 <3629aa32fd3e434e41e5e5f4a97ab50adb8edcdc.1411116672.git.osandov@osandov.com>
	 <20140919132123.418b276f@gandalf.local.home>
	 <1411150553.24444.29.camel@joe-AO725>
	 <20140921132512.GI4723@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2014-09-21 at 06:25 -0700, Paul E. McKenney wrote:
> On Fri, Sep 19, 2014 at 11:15:53AM -0700, Joe Perches wrote:
> > On Fri, 2014-09-19 at 13:21 -0400, Steven Rostedt wrote:
> > > On Fri, 19 Sep 2014 02:01:29 -0700
> > > Omar Sandoval <osandov@osandov.com> wrote:
> > > 
> > > > printk returns an integer; there's no reason for printk_ratelimited to swallow
> > > > it.
> > 
> > Except for the lack of usefulness of the return value itself.
> > See: https://lkml.org/lkml/2009/10/7/275
> 
> When printk()'s return value is changed to void, then yes, we should
> clearly change this code to match that.
> 
> So, I have to ask...  What happened to the patch later in that series
> that was to remove the uses of the printk() return value?

I don't know.

Last I recall via searching emails, Alan Jenkins was going to do
something with it. (I've added his old email to this reply, but
I doubt still works)

I remember checking whether or not the removing the return value
reduced the code size on x86 (it did not), and forgot about it.

I don't know if removing the printk return value reduces overall
image size in any arch, so I didn't pursue it.

