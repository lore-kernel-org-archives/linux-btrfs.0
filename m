Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55050 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180Ab3ILMxr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Sep 2013 08:53:47 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 81A067C067A
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Sep 2013 06:53:47 -0600 (MDT)
Date: Thu, 12 Sep 2013 08:53:45 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Anand Jain <anand.jain@oracle.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: extent data disk byte 0
Message-ID: <20130912125345.GF2446@localhost.localdomain>
References: <5231A598.1050306@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5231A598.1050306@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 12, 2013 at 07:29:28PM +0800, Anand Jain wrote:
> 
> 
>  In the item 7 below, any idea why would the disk byte be 0 ?
>  (its not an inline extent)
> 

It's a hole.

Josef
