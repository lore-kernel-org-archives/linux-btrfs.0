Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:42212 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbbFLIfN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 04:35:13 -0400
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: kernel crashes with btrfs and busy database IO - how to debug?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 12 Jun 2015 17:35:11 +0900
From: Tomasz Chmielewski <tch@virtall.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <557A8691.6070908@cn.fujitsu.com>
References: <ae9b9ca434c98509ca6c1ba6dbd84b63@admin.virtall.com>
 <557A8691.6070908@cn.fujitsu.com>
Message-ID: <73cb882c23a71c9039a0e7bbfddfab64@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-06-12 16:13, Qu Wenruo wrote:

>> Remote syslog does not capture anything.
> No backtrace?

No (nothing saved on disk, don't have VNC access).

The only way to capture anything is:

while true; do dmesg -c ; done

but that's usually incomplete.


> Without backtrace, it's much harder to debug for us.
> It's quite possible that some codes go mad and pass a NULL pointer,
> and then wait_event() is called on the NULL->some_member.
> 
> Anyway, backtrace is needed to debug this.
> 
> If syslog can't help, what about kdump + crash to get the backtrace?

I'll try to get a kdump + crash.

-- 
Tomasz Chmielewski
http://wpkg.org

