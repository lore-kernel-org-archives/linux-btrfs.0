Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:49537 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab3ITTey convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 15:34:54 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A01C37C04E9
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Sep 2013 13:34:53 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, <stable@vger.kernel.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <1379694879-29402-1-git-send-email-dsterba@suse.cz>
CC: David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fusionio.com>,
        <linux-btrfs@vger.kernel.org>
References: <1379694879-29402-1-git-send-email-dsterba@suse.cz>
Message-ID: <20130920193451.29199.26900@localhost.localdomain>
Subject: Re: Handful of btrfs fixes for 3.11.x stable
Date: Fri, 20 Sep 2013 15:34:51 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting David Sterba (2013-09-20 12:34:39)
> Hi stable team,
> 
> please add the following commits to 3.11 tree, they fix user visible problems,
> were tested and are now present in 3.12-rc1.
> 
> 3d05ca371200b3366530621abf73769024581b79
> b13a004528c3e5eb060a26eee795f5a0da7bfe9f
> 7ef67ffda91cc0c56f33937bfdf1d057b9ee96ca
> ca6d07c1d74bf7ba3083bc31a9aeeaa1d0ad86aa

Thanks Dave, I'll pull these into a -stable tree and send a pull
request.

-chris
