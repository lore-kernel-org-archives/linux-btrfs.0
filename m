Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43400 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751766AbbAOAel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Jan 2015 19:34:41 -0500
Message-ID: <54B70B1F.5050105@cn.fujitsu.com>
Date: Thu, 15 Jan 2015 08:34:39 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/4] btrfs-progs: Enhance btrfs-find-root.
References: <1415771534-7979-1-git-send-email-quwenruo@cn.fujitsu.com> <1415771534-7979-2-git-send-email-quwenruo@cn.fujitsu.com> <20150114175830.GX3685@twin.jikos.cz>
In-Reply-To: <20150114175830.GX3685@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 2/4] btrfs-progs: Enhance btrfs-find-root.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年01月15日 01:58
> On Wed, Nov 12, 2014 at 01:52:12PM +0800, Qu Wenruo wrote:
>> Enhance btrfs-find-root in the following way:
>> 1. Use existing or lightly modified btrfs infrastructure
>>     Don't use btrfs-find-root local defined open_ctree or csum check.
>>     Slightly modify open_ctree() and csum_tree_block() to provide the
>>     chunk-only open_ctree and suprress error output for csum_tree_block()
>>
>> 2. Output the trees in an ascending order of generation
>>     Normally, end user running btrfs-find-root is hoping to find out a
>>     recently new old root.
>>     So output the search result in an ascending order of generation.
>>
>> 3. Hide the obviously not tree root node/leaf
>>     Only output the node/leaf with the highest level among its generation
>>     to simplify the output.
> Can you please split this patch into logical and possibly independent
> parts? There are cleanups, core functionality changes and new option(s)
> added.
OK, I'll try to split them into more reasonable parts.

Thanks,
Qu
