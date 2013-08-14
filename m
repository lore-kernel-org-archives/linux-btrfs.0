Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:51001 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab3HNTdj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 15:33:39 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id AD1927C04E9
	for <linux-btrfs@vger.kernel.org>; Wed, 14 Aug 2013 13:33:39 -0600 (MDT)
Date: Wed, 14 Aug 2013 15:33:37 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: tim <tim@klingt.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: BUG at fs/btrfs/file.c:870
Message-ID: <20130814193337.GC26269@localhost.localdomain>
References: <kugg05$88d$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <kugg05$88d$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 14, 2013 at 07:50:05PM +0200, tim wrote:
> hi all,
> 
> trying to reproduce [1], i've came across another btrfs bug:
> 

You hit the strangest things.  I'm going to sit down and write a bunch of unit
tests for this function to verify it is working properly.  Thanks,

Josef
