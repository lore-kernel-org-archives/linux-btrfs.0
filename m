Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:19579 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab2JIDqG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Oct 2012 23:46:06 -0400
Message-ID: <50739E0C.9070300@cn.fujitsu.com>
Date: Tue, 09 Oct 2012 11:46:20 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Chen Yang <chenyang.fnst@cn.fujitsu.com>
Subject: Re: [RFC][PATCH] Btrfs-progs, btrfsck: add block group check function
References: <501A530D.2020107@cn.fujitsu.com> <20121003002156.GI3214@shiny>
In-Reply-To: <20121003002156.GI3214@shiny>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2 Oct 2012 20:21:56 -0400, Chris Mason wrote:
> On Thu, Aug 02, 2012 at 04:14:37AM -0600, Miao Xie wrote:
>> From: Chen Yang <chenyang.fnst@cn.fujitsu.com>
>>
>> This patch adds the function to check correspondence between block group,
>> chunk and device extent.
> 
> Excellent, thank you.  Could you please put this into a git tree?  I'm
> having trouble with whitespace (tabs -> spaces) in the patch.

You can pull it by

	git://github.com/miaoxie/btrfs-progs.git block-group-check

I have re-based it on the latest tree

Thanks
Miao
