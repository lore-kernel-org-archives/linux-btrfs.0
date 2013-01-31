Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab3AaQwW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 11:52:22 -0500
Date: Thu, 31 Jan 2013 17:52:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Chen Yang <chenyang.fnst@cn.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, miaox@cn.fujitsu.com
Subject: Re: [PATCH] Btrfs-prog/send: fix wrong dump_fd check in
 cmd_send_start()
Message-ID: <20130131165220.GM30535@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <510A2791.1010607@cn.fujitsu.com>
 <510A2984.6010601@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <510A2984.6010601@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 31, 2013 at 04:21:24PM +0800, Chen Yang wrote:
> In cmd_send_start(), there is a check to make sure dump_fd is not a tty
> before parsing command options. So if we use the option "-f file",
> it doesn't work for the dump_fd has not been created. So fix it.

Good catch, thanks. I see that there's no special handling of the '-'
filename that usually means stdout. We may want to add this as a common
command line usage pattern.

david
