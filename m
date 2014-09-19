Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay0109.hostedemail.com ([216.40.44.109]:42605 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757150AbaISSYR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 14:24:17 -0400
Received: from smtprelay.hostedemail.com (ff-bigip1 [10.5.19.254])
	by smtpgrave04.hostedemail.com (Postfix) with ESMTP id 07C71B276A
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 18:16:08 +0000 (UTC)
Message-ID: <1411150553.24444.29.camel@joe-AO725>
Subject: Re: [PATCH v2 1/2] Return a value from printk_ratelimited
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Omar Sandoval <osandov@osandov.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Date: Fri, 19 Sep 2014 11:15:53 -0700
In-Reply-To: <20140919132123.418b276f@gandalf.local.home>
References: <cover.1411116672.git.osandov@osandov.com>
	 <3629aa32fd3e434e41e5e5f4a97ab50adb8edcdc.1411116672.git.osandov@osandov.com>
	 <20140919132123.418b276f@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-09-19 at 13:21 -0400, Steven Rostedt wrote:
> On Fri, 19 Sep 2014 02:01:29 -0700
> Omar Sandoval <osandov@osandov.com> wrote:
> 
> > printk returns an integer; there's no reason for printk_ratelimited to swallow
> > it.

Except for the lack of usefulness of the return value itself.
See: https://lkml.org/lkml/2009/10/7/275


