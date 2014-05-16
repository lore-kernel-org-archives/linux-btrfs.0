Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaEPQh3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 12:37:29 -0400
Date: Fri, 16 May 2014 18:37:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: add missing help option for rescue
 super-recover
Message-ID: <20140516163727.GC6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1400117349-2851-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1400117349-2851-2-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1400117349-2851-2-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 15, 2014 at 09:29:08AM +0800, Gui Hecheng wrote:
> Add '-h' option for help for super-recover,
> update the manpage at the same time.

We don't have the short option for help, a few patches have been already
rejected to change that.
