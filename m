Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60124 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2F2KVp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jun 2012 06:21:45 -0400
Received: by eeit10 with SMTP id t10so1307914eei.19
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jun 2012 03:21:44 -0700 (PDT)
Date: Fri, 29 Jun 2012 13:21:41 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Alexander Block <ablock84@googlemail.com>
Subject: Re: [PATCH 1/3] Btrfs-progs: add support to set subvolume/snapshot
 readonly
Message-ID: <20120629102141.GA1877@zambezi.lan>
References: <1340964038-32584-1-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1340964038-32584-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2012 at 06:00:36PM +0800, Liu Bo wrote:
> Setting subvolume/snapshot readonly has been missing for a long time.
> 
> With this patch, we can set a subvolume/snapshot readonly via:
> 
> o    btrfs subvolume set-ro <path>

Alexander's 'btrfs property' patches do exactly this, but in a much more
generic and extensible way.  'btrfs property' subgroup provides a
uniform interface for getting and setting properties of filesystem
objects in general, not only those of subvolumes and snapshots.  It
provides a much better user interface, and it also allows us to easily
rethink kernel-user interface for generic get/set in future.

Thanks,

		Ilya
