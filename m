Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:15830 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab3KMBej (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 20:34:39 -0500
Message-ID: <5282D64E.5080703@cn.fujitsu.com>
Date: Wed, 13 Nov 2013 09:30:54 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: remove unused function btrfs_get_inode_ref_index()
References: <1384255924-15851-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20131112160242.GC9132@twin.jikos.cz>
In-Reply-To: <20131112160242.GC9132@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/13/2013 12:02 AM, David Sterba wrote:
> On Tue, Nov 12, 2013 at 07:32:03PM +0800, Wang Shilong wrote:
>> Since commit d52be818e6(Btrfs: simplify unlink reservations),
>> btrfs_get_inode_ref_index() is no loner called.
>>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> http://www.spinics.net/lists/linux-btrfs/msg26646.html
Oops, i didn't notice there has been patch in flight, will resend it
with original author.

Thanks,
Wang
> Reviewed-by: David Sterba <dsterba@suse.cz>
>

