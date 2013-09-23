Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:37724 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab3IWO5D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 10:57:03 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id BDFD17C067C
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 08:57:02 -0600 (MDT)
Date: Mon, 23 Sep 2013 10:57:00 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs: qgroup scan failed with -12
Message-ID: <20130923145700.GB18681@localhost.localdomain>
References: <20130923074344.60f629d7@wpkg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130923074344.60f629d7@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 23, 2013 at 07:43:44AM +0700, Tomasz Chmielewski wrote:
> Not sure if it's anything interesting - I had the following entry in
> dmesg a few days ago, on a server with 32 GB RAM. The system is still working fine.
> 

Can you try the patch here

https://bugzilla.kernel.org/attachment.cgi?id=107408&action=diff

and see if that helps?  Thanks,

Josef
