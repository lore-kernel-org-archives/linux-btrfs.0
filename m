Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59429 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112Ab3FCVwR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jun 2013 17:52:17 -0400
Date: Mon, 3 Jun 2013 13:49:30 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] introduce list_for_each_entry_del
Message-ID: <20130603204930.GA28299@infradead.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370280485-10047-1-git-send-email-joern@logfs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I can't say I like the structure.

A list_pop that removes and entry from the head or returns NULL if the
list is empty would lead to nice while loops that are obviously
readable instead.

