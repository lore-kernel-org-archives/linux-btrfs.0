Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:52027 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3FENgx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Jun 2013 09:36:53 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E83D29A0691
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Jun 2013 07:36:52 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, Sage Weil <sage@inktank.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130605125440.GA29248@localhost.localdomain>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <alpine.DEB.2.00.1306042056350.19491@cobra.newdream.net>
 <20130605125440.GA29248@localhost.localdomain>
Message-ID: <20130605133650.4088.67669@localhost.localdomain>
Subject: Re: v3.9 bug at /fs/btrfs/free-space-cache.c:1567 after powercycle
Date: Wed, 5 Jun 2013 09:36:50 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Josef Bacik (2013-06-05 08:54:40)
> On Tue, Jun 04, 2013 at 09:59:05PM -0600, Sage Weil wrote:
> > Hi-
> > 
> > I'm pretty reliably triggering the following bug after powercycling an 
> > active btrfs + ceph workload and then trying to remount.  Is this a known 
> > issue?
> > 
> 
> Yeah sorry it's fixed in 3.10, I really need to send the patch back to stable.
> Thanks,

Do we need more than: 

commit b50c6e250ef91313518dbca96663578237ba8d3c
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Thu Apr 25 15:55:30 2013 -0400

    Btrfs: deal with free space cache errors while replaying log

commit 09a2a8f96e3009273bed1833b3f210e2c68728a5
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Fri Apr 5 16:51:15 2013 -0400

    Btrfs: fix bad extent logging

commit cc95bef635a649d595cf8d1cd4fcff5b6bf13023
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Thu Apr 4 14:31:27 2013 -0400

    Btrfs: log ram bytes properly

-chris

