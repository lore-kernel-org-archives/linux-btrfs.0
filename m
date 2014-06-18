Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbaFRPwW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 11:52:22 -0400
Date: Wed, 18 Jun 2014 17:52:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3] btrfs-progs: Improve the parse_size() error message.
Message-ID: <20140618155220.GX1903@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1402628157-22320-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1402628157-22320-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 13, 2014 at 10:55:57AM +0800, Qu Wenruo wrote:
> v3:
>    Don't reparse size twice
>    Better u64 overflow check

Thanks. I've tested the limits, overflow checks and negative numbers,
works fine.
