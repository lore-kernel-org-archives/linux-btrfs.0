Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:57172 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbaJNTPt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 15:15:49 -0400
Received: by mail-wg0-f52.google.com with SMTP id a1so11543849wgh.11
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Oct 2014 12:15:48 -0700 (PDT)
Date: Tue, 14 Oct 2014 12:15:42 -0700
From: Zach Brown <zab@zabbo.net>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC 1/1 linux-next] btrfs: don't opencode zero_user_segment
Message-ID: <20141014191542.GB6838@lenny.home.zabbo.net>
References: <1413308774-9985-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413308774-9985-1-git-send-email-fabf@skynet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 14, 2014 at 07:46:14PM +0200, Fabian Frederick wrote:
> use function defined in include/linux/highmem.h
> Note that this reverts 2 last function call order

And adds a BUG_ON(PAGE_CACHE_SIZE > PAGE_SIZE).  We can take bets on
whether that will ever trigger.

- z
