Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756474AbbHZOpE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 10:45:04 -0400
Date: Wed, 26 Aug 2015 16:44:28 +0200
From: David Sterba <dsterba@suse.cz>
To: =?utf-8?B?6rCV7IOB7Jqw?= <kenneth.kang@lge.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: FW: btrfs-progs: android build
Message-ID: <20150826144428.GY10756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <003201d0d02c$3349fe10$99ddfa30$@lge.com>
 <003f01d0d02c$96c92f10$c45b8d30$@lge.com>
 <20150806143839.GK31669@twin.jikos.cz>
 <001b01d0d33e$8043bb60$80cb3220$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <001b01d0d33e$8043bb60$80cb3220$@lge.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 10, 2015 at 04:30:58PM +0900, 강상우 wrote:
> I change the code that you are suggest.

Well, it's still not exactly what I expected. I'll add the makefile bits
from you patch and do the wrappers and ifdefs myself. It's not always
straightfowratd how to do it so I'll need to experiment a bit.
