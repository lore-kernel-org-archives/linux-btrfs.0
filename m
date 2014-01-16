Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33704 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbaAPCJL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 21:09:11 -0500
Message-ID: <52D73F9F.6030909@cn.fujitsu.com>
Date: Thu, 16 Jan 2014 10:10:39 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Vladi Gergov <vladi@aresgate.net>, linux-btrfs@vger.kernel.org
Subject: Re: 2 year old raid1 issue chunk-recovery help
References: <20140115194008.GA5425@gypsyops.denof.sin>
In-Reply-To: <20140115194008.GA5425@gypsyops.denof.sin>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On wed, 15 Jan 2014 11:40:09 -0800, Vladi Gergov wrote:
> Hi, in 2010 i had an issue with my raid1 when one drive failed and i
> added another drive to the array and tried to rebuild. Here is what bug
> I hit according to Chris Mason
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg06868.html
> 
> I have since updated to lastes btrfs-tools 3.12 + kernel 3.13-rc7 and
> attempted an chunk recovery which failed with this
> http://bpaste.net/show/168445/
> 
> If anyone can help me get at least some of the data off this bad boy it
> would be great! I am cc'ing Miao since his name was thrown under the bus
> in irc :). Thanks in advance!
> 

Chunk recover command can only recover the case that the devices are good, only
the chunk tree is corrupted. So it is not suitable to fix your issue.

I think you can try the replace function if you can mount the device successfully,
just like:
 # mount <dev> -o degraded <mnt>
 # btrfs replace start missing <new_dev>

Thanks
Miao
