Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:35456 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbbLBGZi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2015 01:25:38 -0500
From: Russell Coker <russell@coker.com.au>
To: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Bug/regression: Read-only mount not read-only
Date: Wed, 2 Dec 2015 17:25:32 +1100
Cc: Chris Mason <clm@fb.com>, Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
References: <20151128134634.GF24333@carfax.org.uk> <20151201190018.GD8918@ret.masoncoding.com> <565DEF65.4080900@redhat.com>
In-Reply-To: <565DEF65.4080900@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Message-Id: <201512021725.32750.russell@coker.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2 Dec 2015 06:05:09 AM Eric Sandeen wrote:
> yes, xfs does; we have "-o norecovery" if you don't want that, or need
> to mount a filesystem with a dirty log on a readonly device.

That option also works with Ext3/4 so it seems to be a standard way of dealing 
with this.  I think that BTRFS should do what Ext3/4 and XFS do in this 
regard.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/
