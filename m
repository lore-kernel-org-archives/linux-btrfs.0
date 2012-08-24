Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:44410 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab2HXNfx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 09:35:53 -0400
Date: Fri, 24 Aug 2012 15:33:48 +0200
From: David Sterba <dave@jikos.cz>
To: Robert Buhren <robert@robertbuhren.de>
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org,
        Alexander Block <ablock84@googlemail.com>,
        Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH] Btrfs-progs: replace find_mount_root from send code
Message-ID: <20120824133348.GY17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5028D57F.5090803@robertbuhren.de>
 <1345463835-26636-1-git-send-email-list.btrfs@jan-o-sch.net>
 <5035EFDE.4090404@robertbuhren.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5035EFDE.4090404@robertbuhren.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 23, 2012 at 10:54:54AM +0200, Robert Buhren wrote:
> I'm on linux-3.6-rc2 and btrfs-progs from git.

Please try it with Chris' for-linus branch, it contains a fair portion
of send-related fixes and from brief look they may be related to the
errors you see.

david
