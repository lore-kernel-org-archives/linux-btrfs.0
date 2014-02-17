Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42456 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754609AbaBQWOj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Feb 2014 17:14:39 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs "possible irq lock inversion dependency detected"
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140217200951.GB20312@optiplex>
Date: Mon, 17 Feb 2014 15:14:34 -0700
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, Dave Jones <davej@redhat.com>,
        trinity@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <4F3CC8F0-C37E-4448-AF65-796E643A301B@colorremedies.com>
References: <20140217200951.GB20312@optiplex>
To: Tommi Rantala <tt.rantala@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 17, 2014, at 1:09 PM, Tommi Rantala <tt.rantala@gmail.com> wrote:

> Hello,
> 
> Saw this while fuzzing the kernel with Trinity.
> 
> Tommi
> 
> 
> [  396.136048] =========================================================
> [  396.136048] [ INFO: possible irq lock inversion dependency detected ]
> [  396.136048] 3.14.0-rc3 #1 Not tainted
> [  396.136048] ---------------------------------------------------------
> [  396.136048] kswapd0/1482 just changed the state of lock:
> [  396.136048]  (&delayed_node->mutex){+.+.-.}, at: [<ffffffff8147b83b>] __btrfs_release_delayed_node+0x4b/0x1e0
> [  396.136048] but this lock took another, RECLAIM_FS-unsafe lock in the past:
> [  396.136048]  (&found->groups_sem){+++++.}

Looks like this is the same thing previously report on Btrfs list with 3.14.0-rc1 here:
https://bugzilla.redhat.com/show_bug.cgi?id=1062439

Which points to this:
https://bugzilla.redhat.com/show_bug.cgi?id=1062833#c24

Which points to this patch:
http://marc.info/?l=linux-netdev&m=139233546723342&q=raw


Chris Murphy