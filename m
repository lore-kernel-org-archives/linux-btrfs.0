Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail0200.smtp25.com ([174.37.170.200]:48833 "EHLO
	mail0200.smtp25.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594AbbLWAST (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Dec 2015 19:18:19 -0500
Received: from ccs.covici.com (localhost [127.0.0.1])
	by ccs.covici.com (8.14.9/8.14.8) with ESMTP id tBN0IH2N031667
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Dec 2015 19:18:17 -0500
From: covici@ccs.covici.com
cc: linux-btrfs@vger.kernel.org
Subject: Re: notify not being triggered in btrfs directory
In-reply-to: <29680.1450828473@ccs.covici.com>
References: <29680.1450828473@ccs.covici.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 22 Dec 2015 19:18:17 -0500
Message-ID: <31666.1450829897@ccs.covici.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think I fixed it,  I am using a daemon and had to restart and now its
working -- almost panicked there for a minute.

covici@ccs.covici.com wrote:

> Hi.  I am having a problem where I am watching some directories in a
> btrfs file system, but inotify is not being triggered -- is this a known
> issue?  I am using kernel 4.1.12-gentoo and programs 4.3.1.
> 
> Thanks in advance for any suggestions.
> 
> -- 
> Your life is like a penny.  You're going to lose it.  The question is:
> How do
> you spend it?
> 
>          John Covici
>          covici@ccs.covici.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Your life is like a penny.  You're going to lose it.  The question is:
How do
you spend it?

         John Covici
         covici@ccs.covici.com
