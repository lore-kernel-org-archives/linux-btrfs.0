Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56205 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbaGDORs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Jul 2014 10:17:48 -0400
Date: Fri, 4 Jul 2014 16:17:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v4] btrfs-progs: Add minimum device size check
Message-ID: <20140704141746.GP1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1404458957-23621-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1404458957-23621-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 04, 2014 at 03:29:17PM +0800, Qu Wenruo wrote:
> v4: Fix a variant reuse bug which causes mkfs.btrfs use wrong first device.

Can you please send this incremental change only? The v3 patch is deep
in the v3.15.x branch that's supposed to comprise patches for the 3.15
release. The diff between v3 and v4 is pretty small, such mistakes
happen, no big deal (unlike rebasing a branch that was public for some
time already).

Thanks.
