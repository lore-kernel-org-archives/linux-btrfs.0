Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33839 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbbFLW4e (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 18:56:34 -0400
Date: Fri, 12 Jun 2015 15:56:32 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Matt Robinson <git@nerdoftheherd.com>
Subject: Re: [RESEND][PATCH] btrfs: Align EOF length to block in extent_same
Message-ID: <20150612225632.GP18148@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20150610221355.GN18148@wotan.suse.de>
 <557B3E91.3060206@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <557B3E91.3060206@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 12, 2015 at 04:18:25PM -0400, Chris Mason wrote:
> Hi Mark,
> 
> This one conflicts with your btrfs: Handle unaligned length in
> extent_same, which is in integration now.  If we need both, can you
> please rework it?

They both fix the same bug, so we just need one of them. You can keep mine
in there if it's easiest or take Matt's if you like it better. Both were
tested the same way on my end too. Thanks Chris.
	--Mark

--
Mark Fasheh
