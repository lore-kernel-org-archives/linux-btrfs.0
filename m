Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbbAOMgk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 07:36:40 -0500
Date: Thu, 15 Jan 2015 13:36:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Merlijn Wajer <merlijn@wizzup.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        dsterba@suse.cz, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] Restore backtrace functionality on glibc
Message-ID: <20150115123639.GF3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <54B65F5E.6020103@wizzup.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54B65F5E.6020103@wizzup.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 14, 2015 at 01:21:50PM +0100, Merlijn Wajer wrote:
> Josef, can you verify that this patch restores the backtrace functionality?

Worked for me, patch applied.

> I'm sorry that my previous patch broke the backtrace functionality -- I
> guess that sometimes trivial patches can still be wrong. :-)

Yeah :)
