Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:53909 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab2ITTDK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 15:03:10 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx2.fusionio.com with ESMTP id CGPJum3Eoevv1isM (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 20 Sep 2012 13:03:09 -0600 (MDT)
Date: Thu, 20 Sep 2012 15:03:06 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: ENOSPC design issues
Message-ID: <20120920190306.GG2272@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm going to look at fixing some of the performance issues that crop up because
of our reservation system.  Before I go and do a whole lot of work I want some
feedback.  I've done a brain dump here

https://btrfs.wiki.kernel.org/index.php/ENOSPC

This has an explanation of how our reservation system currently works and the
problems I think there are with it, and the solutions I'm going to try.  If
somebody has any better ideas please put them on that page along with your IRC
nick so I can find you and we can chat about your idea.  Once we have a few
things we all agree on I'll start hammering away at them.  Some of these things
I'm going to go ahead and do because they are just correct, but the bigger
things such as the flusher thread I'd like some more input on.  Any crazy ideas
welcome, but if your idea involves completely scrapping the current system it
will have to be an awesome idea since I don't really want to spend the next year
fixing early enospc problems again.  Thanks,

Josef
