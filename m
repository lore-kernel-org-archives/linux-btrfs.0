Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60677 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbaGPF3Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 01:29:25 -0400
Date: Tue, 15 Jul 2014 22:29:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: viro@zeniv.linux.org.uk, clm@fb.com, jbacik@fb.com,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffm@suse.com, fdmanana@suse.com,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC 0/2] vfs / btrfs: add support for ustat()
Message-ID: <20140716052919.GA3486@infradead.org>
References: <1405465625-1122-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1405465625-1122-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Isn't this the problem again the btrfs uses different assignments for
st_dev than s_dev?  I don't even want to think about a mess like this
before that is fixed.

