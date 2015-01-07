Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53326 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbbAGOmy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jan 2015 09:42:54 -0500
Date: Wed, 7 Jan 2015 06:42:50 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Lennart Poettering <lennart@poettering.net>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: btrfs_inode_item's otime?
Message-ID: <20150107144250.GA2901@infradead.org>
References: <20150105172152.GB19126@gardel-login>
 <20150106182652.GE24104@twin.jikos.cz>
 <20150107135734.GA21327@gardel-login>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150107135734.GA21327@gardel-login>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 07, 2015 at 02:57:35PM +0100, Lennart Poettering wrote:
> Exposig this as xattr sounds great to me too.

NAK - exposing random stat data as xattr only creates problems.

Given that we don't seem to be able to get a new stat format anytime
soon we should add a generic ioctl to expose it, reading it from struct
kstat which all filesystem that support this attribute should fill out.
And there's quite a lot of them.
