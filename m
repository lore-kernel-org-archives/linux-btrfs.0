Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35232 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab2ITOPJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Sep 2012 10:15:09 -0400
Date: Thu, 20 Sep 2012 16:15:04 +0200
From: David Sterba <dave@jikos.cz>
To: Wade Cline <clinew@linux.vnet.ibm.com>
Cc: linux-btrfs@vger.kernel.org, cmm@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] Btrfs-progs: Fix compiler warnings on PPC64.
Message-ID: <20120920141504.GP17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1347492116-16317-1-git-send-email-clinew@linux.vnet.ibm.com>
 <20120914135919.GN17430@twin.jikos.cz>
 <505365A9.2080900@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505365A9.2080900@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 10:13:13AM -0700, Wade Cline wrote:
> By the time kerncompat.h is included, u64 is almost always defined to
> the non-compatible value. So either kerncompat.h needs to be defined as the
> -first-

This makes most sense to me.

Although the include files should go in the order 1. system 2. local,
and kernecompat.h is local, it's special in it's own way and i don't see
any problem with that.

david
