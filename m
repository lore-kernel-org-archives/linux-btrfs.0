Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38823 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532AbbFJCti (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jun 2015 22:49:38 -0400
Date: Wed, 10 Jun 2015 10:49:28 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Trollkarlen Marklund <robbelibobban@gmail.com>
Cc: =?utf-8?B?IuKAnGxpbnV4LWJ0cmZzQHZnZXIua2VybmVsLm9yZ+KAnSI=?=
	<linux-btrfs@vger.kernel.org>
Subject: Re: superblock recovery raid0
Message-ID: <20150610024927.GB2849@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20EA23B4-B6B7-45A8-B045-917BEA32F0E2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20EA23B4-B6B7-45A8-B045-917BEA32F0E2@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 09, 2015 at 10:39:49AM +0200, Trollkarlen Marklund wrote:
> 
> Hi!
> 
> I have a two disk in raid0 where one of the disks have failed. Approximately  17Mb cant be read from the disk, due to hardware issues. I made a clone of the disk but all 3 superblocks are in the non-readable areas :( 
> 
> So my question is, is there any tool to recreate the superblock from the content of the disk and the superblock from the non-failing disk in the array ?
> Any other suggestions is also welcome so solve the situation.

Have you tried to mount that non-failing disk?  Both of disks have their own superblock sections.

Thanks,

-liubo
> 
> 
> /R --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
