Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41085 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750978AbcFVH3q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 03:29:46 -0400
Subject: Re: [PATCH] btrfs: fix disk_i_size update bug when fallocate() fails
To: Christoph Hellwig <hch@infradead.org>
References: <1466560621-18133-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
 <20160622062403.GA16380@infradead.org>
CC: <linux-btrfs@vger.kernel.org>
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Message-ID: <576A3E0A.6020101@cn.fujitsu.com>
Date: Wed, 22 Jun 2016 15:28:10 +0800
MIME-Version: 1.0
In-Reply-To: <20160622062403.GA16380@infradead.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

On 06/22/2016 02:24 PM, Christoph Hellwig wrote:
> On Wed, Jun 22, 2016 at 09:57:01AM +0800, Wang Xiaoguang wrote:
>> And below test case can reveal this bug:
> Please wire this up for xfstests, thanks!
OK.

Regards,
Xiaoguang Wang
>
>



