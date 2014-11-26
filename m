Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50088 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaKZTYV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 14:24:21 -0500
Date: Wed, 26 Nov 2014 11:24:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        XFS Developers <xfs@oss.sgi.com>
Subject: Re: [PATCH-v4 6/7] ext4: add support for a lazytime mount option
Message-ID: <20141126192420.GB20436@infradead.org>
References: <1416997437-26092-1-git-send-email-tytso@mit.edu>
 <1416997437-26092-7-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416997437-26092-7-git-send-email-tytso@mit.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The subject line seems incorrect, this seems to implement some form
of dirty inode writeback clustering.

