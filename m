Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:53553 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364Ab2ISQBr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 12:01:47 -0400
Date: Wed, 19 Sep 2012 12:01:45 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: "free space cache generation" ?
Message-ID: <20120919160109.GC2272@localhost.localdomain>
References: <50597CD5.5060001@petaramesh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <50597CD5.5060001@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 19, 2012 at 02:05:41AM -0600, Swâmi Petaramesh wrote:
> Hi there,
> 
> I noticed my syslog is filling up with tons of:
> 
> btrfs: free space inode generation (0) did not match free space cache 
> generation (25326)
> 

Yeah I need to just put those under a DEBUG ifdef, they aren't a big deal, just
letting you know that the on disk cache is invalid and it will have to put it
together ye olde fashioned way.  Thanks,

Josef
