Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab2FLSID (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 14:08:03 -0400
Date: Tue, 12 Jun 2012 14:08:01 -0400
From: Josef Bacik <josef@redhat.com>
To: Zach Brown <zab@zabbo.net>
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
        wfg@linux.intel.com
Subject: Re: [PATCH] Btrfs: use rcu to protect device->name V2
Message-ID: <20120612180800.GE1565@localhost.localdomain>
References: <1339421426-1921-1-git-send-email-josef@redhat.com>
 <4FD65ECA.1030502@zabbo.net>
 <20120612134318.GD1565@localhost.localdomain>
 <4FD77D52.8000203@zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FD77D52.8000203@zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 12, 2012 at 10:33:06AM -0700, Zach Brown wrote:
> 
> >#define device_name_printk(dev, level, fmt, ...) do {		\
> >	struct rcu_string *name;				\
> >								\
> >	rcu_read_lock();					\
> >	name = rcu_dereference(dev->name);			\
> >	printk(level "%s: " fmt, name->str, ##__VA_ARGS__);	\
> >	rcu_read_unlock();					\
> >	} while (0)
> 
> Right, that has the same problem of limiting flexibility in the device
> name args.  That's why I gave that example of a specific macro for
> dereferencing a device name arg's rcu_string.
> 
> Does this diff make it more clear?  It's generated on your patch, only
> build tested..
> 

Ah ok I like that better than what I had, I'll do that, thanks,

Josef
