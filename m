Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay0217.hostedemail.com ([216.40.44.217]:56547 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751156AbaI0FsQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Sep 2014 01:48:16 -0400
Message-ID: <1411796891.21874.14.camel@joe-AO725>
Subject: Re: [PATCH v3 1/2] Return a value from printk_ratelimited
From: Joe Perches <joe@perches.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Date: Fri, 26 Sep 2014 22:48:11 -0700
In-Reply-To: <a4437b89bc5684ea1d6f978039bd255d1f5b26f9.1411796033.git.osandov@osandov.com>
References: <cover.1411796033.git.osandov@osandov.com>
	 <a4437b89bc5684ea1d6f978039bd255d1f5b26f9.1411796033.git.osandov@osandov.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-09-26 at 22:36 -0700, Omar Sandoval wrote:
> printk returns an integer; there's no reason for printk_ratelimited to swallow
> it.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---

I'd prefer to keep it the way it is actually.

I've submitted several patches to convert the int return
to void for printk derived functions recently.


