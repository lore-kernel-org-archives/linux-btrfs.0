Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33018 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaI0Ho5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Sep 2014 03:44:57 -0400
Received: by mail-pa0-f46.google.com with SMTP id kq14so1389652pab.33
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Sep 2014 00:44:57 -0700 (PDT)
Date: Sat, 27 Sep 2014 00:45:59 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Joe Perches <joe@perches.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Return a value from printk_ratelimited
Message-ID: <20140927074559.GA30196@molino.home.network>
References: <cover.1411796033.git.osandov@osandov.com>
 <a4437b89bc5684ea1d6f978039bd255d1f5b26f9.1411796033.git.osandov@osandov.com>
 <1411796891.21874.14.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1411796891.21874.14.camel@joe-AO725>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 26, 2014 at 10:48:11PM -0700, Joe Perches wrote:
> I'd prefer to keep it the way it is actually.
> 
> I've submitted several patches to convert the int return
> to void for printk derived functions recently.

Alright, it doesn't seem like anyone feels strongly for keeping the return
values, so I'll go ahead and submit a v4 that doesn't modify printk_ratelimited
and doesn't return anything from the printk functions in rcustring.h unless
there are any objections.

-- 
Omar
