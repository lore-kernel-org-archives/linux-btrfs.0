Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:59214 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755310AbaFLIQe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 04:16:34 -0400
Message-ID: <1402560684.28107.2.camel@localhost.localdomain>
Subject: Re: [PATCH 1/3] btrfs-progs: fix missing parity stripe for raid6 in
 chunk-recover
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Duncan <1i5t5.duncan@cox.net>
CC: <linux-btrfs@vger.kernel.org>
Date: Thu, 12 Jun 2014 16:11:24 +0800
In-Reply-To: <pan$b6f9d$aacea77$9bd67de4$294bec3e@cox.net>
References: <1402539901-22779-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <pan$b6f9d$aacea77$9bd67de4$294bec3e@cox.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-06-12 at 07:45 +0000, Duncan wrote:
> Gui Hecheng posted on Thu, 12 Jun 2014 10:24:59 +0800 as excerpted:
> 
> > When deal with the p & q stripes for data profile raid6, chunk-recover
> > forgets to insert them into the chunk record. Just insert them back
> > freely.
> > Also wrap the inert procedure into a new function, fill_chunk_up.
> 
> If there's a v2 anyway: s/inert/insert/ ?
Oh, yes, 'insert' is the right thing. Thanks very much! I'll send a v2.

-Gui
> (For a moment I was contemplating the reasons one might wrap a stub, 
> which is how I was translating inert procedure. Then it hit me... =:^)
> 


