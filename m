Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:10646 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752492Ab3BAC7k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 21:59:40 -0500
Message-ID: <510B2F59.7010600@cn.fujitsu.com>
Date: Fri, 01 Feb 2013 10:58:33 +0800
From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, miaox@cn.fujitsu.com
Subject: Re: [PATCH] Btrfs-prog/send: fix wrong dump_fd check in cmd_send_start()
References: <510A2791.1010607@cn.fujitsu.com> <510A2984.6010601@cn.fujitsu.com> <20130131165220.GM30535@twin.jikos.cz>
In-Reply-To: <20130131165220.GM30535@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Thu, Jan 31, 2013 at 04:21:24PM +0800, Chen Yang wrote:
>> In cmd_send_start(), there is a check to make sure dump_fd is not a tty
>> before parsing command options. So if we use the option "-f file",
>> it doesn't work for the dump_fd has not been created. So fix it.
> 
> Good catch, thanks. I see that there's no special handling of the '-'
> filename that usually means stdout. We may want to add this as a common
> command line usage pattern.
> 
> david
> 
We can touch a file name "-", so I think special handling of the '-' is unnecessary.

