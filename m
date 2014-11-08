Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay0229.hostedemail.com ([216.40.44.229]:36197 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752857AbaKHAsS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 19:48:18 -0500
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
	by smtpgrave07.hostedemail.com (Postfix) with ESMTP id DA91511A030
	for <linux-btrfs@vger.kernel.org>; Sat,  8 Nov 2014 00:39:19 +0000 (UTC)
Message-ID: <1415407155.23530.24.camel@perches.com>
Subject: Re: [PATCH v5] Move BTRFS RCU string to common library
From: Joe Perches <joe@perches.com>
To: Chris Mason <clm@fb.com>
Cc: Omar Sandoval <osandov@osandov.com>, Josef Bacik <jbacik@fb.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Date: Fri, 07 Nov 2014 16:39:15 -0800
In-Reply-To: <1415391689.9491.0@mail.thefacebook.com>
References: <1415391451-19108-1-git-send-email-osandov@osandov.com>
	 <1415391689.9491.0@mail.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2014-11-07 at 15:21 -0500, Chris Mason wrote:
> 
> On Fri, Nov 7, 2014 at 3:17 PM, Omar Sandoval <osandov@osandov.com> 
> wrote:
> > The RCU-friendly string API used internally by BTRFS is generic 
> > enough for
> > common use. This doesn't add any new functionality, but instead just 
> > moves the
> > code and documents the existing API.
> > 
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> > ---
> > Chris, could you take a look at this again? It's just been rebased 
> > and should
> > be good to go. Thanks!
> 
> Thanks Omar, I'm pulling this into a branch for the next merge window.  
> Looks good to me.

rcustring.h should probably #include any #include dependencies
it has.  types.h, printk.h, etc...


