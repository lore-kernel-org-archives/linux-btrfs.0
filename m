Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:53697 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394Ab2IZPXR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Sep 2012 11:23:17 -0400
Date: Wed, 26 Sep 2012 17:23:14 +0200
From: David Sterba <dave@jikos.cz>
To: ching <lsching17@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: typo in inode.c
Message-ID: <20120926152313.GB14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5062EB9F.4080507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5062EB9F.4080507@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 26, 2012 at 07:48:47PM +0800, ching wrote:
> There is a typo (?) in inode.c (git)

What's the top commit and what git tree?

This has been fixed in 3.6-rc4 via
287082b0bd10060e9c6b32ed9605174ddf2f672a

david
