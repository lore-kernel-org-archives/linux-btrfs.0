Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758536Ab3HISDd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 14:03:33 -0400
Date: Fri, 9 Aug 2013 11:03:31 -0700
From: Zach Brown <zab@redhat.com>
To: anand jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: introduce btrfs filesystem show --kernel
Message-ID: <20130809180331.GA12314@lenny.home.zabbo.net>
References: <1370876190-16520-1-git-send-email-anand.jain@oracle.com>
 <1375949227-23729-1-git-send-email-anand.jain@oracle.com>
 <1375949227-23729-3-git-send-email-anand.jain@oracle.com>
 <20130808180816.GW12314@lenny.home.zabbo.net>
 <5204CB14.3020207@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5204CB14.3020207@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >Right?
> 
>  Yes !
>  For the no option - what I like is more an intelligent way
>  of listing all btrfs - mounted and unmounted by appropriately
>  reading from the kernel and disks respectively.

Great!

It'll be good to get this fixed.  I stumbled across this behaviour of
btrfs fi show lying to me just yesterday.

- z
