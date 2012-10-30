Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:56234 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740Ab2J3QjI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 12:39:08 -0400
Date: Tue, 30 Oct 2012 17:38:57 +0100
From: David Sterba <dave@jikos.cz>
To: ching <lsching17@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Why btrfs inline small file by default?
Message-ID: <20121030163857.GA3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <508FB45B.9040101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <508FB45B.9040101@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 30, 2012 at 07:04:59PM +0800, ching wrote:
> I am testing my btrfs root partition with "max_inline=0", and 64k leaf
> size for weeks and it seems that it is fine.

Related to inlining itself, ext4 and xfs are receiving inline data
support, so it would make sense to introduce a per-file attribute, eg.
FS_NOINLINE_FL that would get set on directories and inherited into
newly created files with the expected outcome.

One of the reasons why is to give a way to user to avoid potential
performance hits, eg. when frequently switching from inline to
non-inline (provided that this is known to happen). Nice to have IMHO,
but more evaluation of real-world use cases where it hurts would be
desirable.

david
