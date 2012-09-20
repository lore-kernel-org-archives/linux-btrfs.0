Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:60891 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab2ITMJU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 08:09:20 -0400
Date: Thu, 20 Sep 2012 14:09:14 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V4 5/7] Btrfs-progs: restructure list_subvolumes
Message-ID: <20120920120914.GK17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <50584E6D.8000602@cn.fujitsu.com>
 <505855C9.9010207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505855C9.9010207@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 18, 2012 at 07:06:49PM +0800, Miao Xie wrote:
> The current code of list_subvols() has very bad scalability, if we want to
> add new filter conditions or new sort methods, we have to modify lots of code.

I've briefly skimmed through the patch, not a short one, IMO the right
way to go.

david
