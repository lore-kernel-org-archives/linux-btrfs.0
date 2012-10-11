Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:59980 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab2JKSwM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 14:52:12 -0400
Date: Thu, 11 Oct 2012 14:51:54 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Priebe <s.priebe@profihost.ag>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <JBacik@fusionio.com>
Subject: Re: use_block_rsv problems with 3.6.1
Message-ID: <20121011185154.GA5755@localhost.localdomain>
References: <50771184.2060807@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50771184.2060807@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 11, 2012 at 12:35:48PM -0600, Stefan Priebe wrote:
> Hello,
> 
> on i've seen the following backtrace a lot on 3.6.1:
> [ 2231.644332] use_block_rsv: 1451 callbacks suppressed
> [ 2231.645249] btrfs: block rsv returned -28

Yeah this is the last deep dark corner of ENOSPC, we don't quite hold enough
reserved to handle deleting lots of csums.  Technically this is supposed to be
taken care of by ye olde global block rsv, but in some cases it's not enough.
On the bright side if you are just seeing the warnings then we're able to find
space somewhere and you are a-ok, but it is kind of annoying.  Once I finish my
fsync stuff I'll go back to this problem and try and figure out a real solution.
Thanks,

Josef
