Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869AbaCNOjG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 10:39:06 -0400
Date: Fri, 14 Mar 2014 15:39:03 +0100
From: David Sterba <dsterba@suse.cz>
To: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs: Cleanup the btrfs_workqueue related function
 type
Message-ID: <20140314143903.GE32719@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1394079657-24937-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394079657-24937-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 06, 2014 at 04:19:50AM +0000, quwenruo@cn.fujitsu.com wrote:
> @@ -23,11 +23,13 @@
>  struct btrfs_workqueue;
>  /* Internal use only */
>  struct __btrfs_workqueue;
> +struct btrfs_work;
> +typedef void (*btrfs_func_t)(struct btrfs_work *arg);

I don't see what's wrong with the non-typedef type, CodingStyle
discourages from using typedefs in general (Chapter 5).

The name btrfs_func_t is a generic, if you really need to use a typedef
here, please change it to something closer to the workqueues, eg.
btrfs_work_func_t.
