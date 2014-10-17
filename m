Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from okda.pipebreaker.pl ([176.56.236.173]:43028 "EHLO
	okda.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaJTQOG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 12:14:06 -0400
Received: from cl-79.waw-01.pl.sixxs.net
	([2001:6a0:200:4e::2] helo=mother.pipebreaker.pl ident=postfix)
	by okda.pipebreaker.pl with esmtps (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
	(Exim 4.80.1)
	(envelope-from <tomek@pipebreaker.pl>)
	id 1XgFHC-0005Pi-A7
	for linux-btrfs@vger.kernel.org; Mon, 20 Oct 2014 17:53:42 +0200
Date: Fri, 17 Oct 2014 19:29:32 +0200
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: unexplainable corruptions 3.17.0
Message-ID: <20141017172932.GA1094496@mother.pipebreaker.pl>
References: <20141016091726.GA582640@mother.pipebreaker.pl>
 <20141017080202.GA3604@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141017080202.GA3604@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 17, 2014 at 04:02:03PM +0800, Liu Bo wrote:
> 
> Does scrub work for you?
> 

  Scrub ended with not errors:
scrub status for a4f339d4-c129-4485-acc1-1233d29c665d
        scrub started at Fri Oct 17 10:04:24 2014 and finished after 31992 seconds
        total bytes scrubbed: 6.03TiB with 0 errors

I guess I'll have to check the patch Marc pointed out.

-- 
Tomasz Torcz               "Never underestimate the bandwidth of a station
xmpp: zdzichubg@chrome.pl    wagon filled with backup tapes." -- Jim Gray

