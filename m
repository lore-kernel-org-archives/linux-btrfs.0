Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35222 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab2JaAoc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 20:44:32 -0400
Date: Wed, 31 Oct 2012 01:44:26 +0100
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: David Sterba <dave@jikos.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: make snapshot-aware defrag as a mount option
Message-ID: <20121031004426.GF3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1351333721-3220-1-git-send-email-bo.li.liu@oracle.com>
 <1351333721-3220-2-git-send-email-bo.li.liu@oracle.com>
 <20121030233146.GB3102@twin.jikos.cz>
 <5090721E.2090806@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5090721E.2090806@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 31, 2012 at 08:34:38AM +0800, Liu Bo wrote:
> Besides 'btrfs fi defrag', mounting with autodefrag may also do the same thing.

Ok, autodefrag, good point. Then I suggest to make the snapshot-aware a
mode of autodefrag, not a separate option (because it would make no
sense other than an alias for "autodefrag=snapshotaware")


david
