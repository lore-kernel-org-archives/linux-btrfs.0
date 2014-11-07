Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27710 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751569AbaKGUXS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Nov 2014 15:23:18 -0500
Date: Fri, 7 Nov 2014 15:21:29 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH v5] Move BTRFS RCU string to common library
To: Omar Sandoval <osandov@osandov.com>
CC: Josef Bacik <jbacik@fb.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, <linux-kernel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, Omar Sandoval <osandov@osandov.com>
Message-ID: <1415391689.9491.0@mail.thefacebook.com>
In-Reply-To: <1415391451-19108-1-git-send-email-osandov@osandov.com>
References: <1415391451-19108-1-git-send-email-osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, Nov 7, 2014 at 3:17 PM, Omar Sandoval <osandov@osandov.com> 
wrote:
> The RCU-friendly string API used internally by BTRFS is generic 
> enough for
> common use. This doesn't add any new functionality, but instead just 
> moves the
> code and documents the existing API.
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> ---
> Chris, could you take a look at this again? It's just been rebased 
> and should
> be good to go. Thanks!

Thanks Omar, I'm pulling this into a branch for the next merge window.  
Looks good to me.

-chris


