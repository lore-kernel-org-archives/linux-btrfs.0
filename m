Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753471Ab3BAMcB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Feb 2013 07:32:01 -0500
Date: Fri, 1 Feb 2013 13:31:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>,
        miaox@cn.fujitsu.com
Subject: Re: [PATCH] Btrfs-prog/send: fix wrong dump_fd check in
 cmd_send_start()
Message-ID: <20130201123157.GA23239@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <510A2791.1010607@cn.fujitsu.com>
 <510A2984.6010601@cn.fujitsu.com>
 <20130131165220.GM30535@twin.jikos.cz>
 <510B2F59.7010600@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <510B2F59.7010600@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 01, 2013 at 10:58:33AM +0800, Chen Yang wrote:
> > Good catch, thanks. I see that there's no special handling of the '-'
> > filename that usually means stdout. We may want to add this as a common
> > command line usage pattern.
> > 
> We can touch a file name "-", so I think special handling of the '-' is unnecessary.

I want to avoid creating a file named '-'. It would work the same way as
'cat -' etc.

david
