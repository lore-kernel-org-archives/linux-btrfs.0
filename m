Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:56720 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab2JEUcp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Oct 2012 16:32:45 -0400
Date: Fri, 5 Oct 2012 22:32:39 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: cleanup pages properly when ENOMEM in compression
Message-ID: <20121005203238.GB15720@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1349459359-2298-1-git-send-email-jbacik@fusionio.com> <20121005200617.GA15720@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121005200617.GA15720@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 05, 2012 at 10:06:17PM +0200, David Sterba wrote:
> Also, faili (how do you pronounce that?) is initialized to 0, the while
> loop will always fire (and burn a page), initialize it to -1.

My oversight sorry, it takes a different codepath and this will not
happen.

david
