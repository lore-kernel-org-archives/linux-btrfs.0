Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:56227 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab2JXIVF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 04:21:05 -0400
Message-ID: <5087A4B9.8050109@huawei.com>
Date: Wed, 24 Oct 2012 16:20:09 +0800
From: Li Zefan <lizefan@huawei.com>
MIME-Version: 1.0
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
CC: <linux-btrfs@vger.kernel.org>, <jbacik@fusionio.com>
Subject: Re: [PATCH] btrfs: Return EINVAL when length to trim is less than
 FSB
References: <1350380076-15997-1-git-send-email-lczerner@redhat.com> <alpine.LFD.2.00.1210241015080.25196@dhcp-1-104.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.1210241015080.25196@dhcp-1-104.brq.redhat.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012/10/24 16:15, Lukáš Czerner wrote:
> On Tue, 16 Oct 2012, Lukas Czerner wrote:
> 
>> Date: Tue, 16 Oct 2012 11:34:36 +0200
>> From: Lukas Czerner <lczerner@redhat.com>
>> To: linux-btrfs@vger.kernel.org
>> Cc: jbacik@fusionio.com, Lukas Czerner <lczerner@redhat.com>
>> Subject: [PATCH] btrfs: Return EINVAL when length to trim is less than FSB
>>
>> Currently if len argument in btrfs_ioctl_fitrim() is smaller than
>> one FSB we will continue and finally return 0 bytes discarded.
>> However if the length to discard is smaller then file system block
>> we should really return EINVAL.
> 
> ping
> 

This patch has already sit in Josef's btrfs-next tree:

http://git.kernel.org/?p=linux/kernel/git/josef/btrfs-next.git;a=commit;h=cd50b6b30f09446eafdd715db6d59299fcc5b19a

