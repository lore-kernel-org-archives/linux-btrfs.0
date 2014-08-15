Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:52247 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaHOKAj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Aug 2014 06:00:39 -0400
Date: Fri, 15 Aug 2014 10:29:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: clm@fb.com, jbacik@fb.com, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffm@suse.com, fdmanana@suse.com,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v3 0/2] vfs / btrfs: add support for ustat()
Message-ID: <20140815092950.GZ18016@ZenIV.linux.org.uk>
References: <1408071538-14354-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1408071538-14354-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 14, 2014 at 07:58:56PM -0700, Luis R. Rodriguez wrote:

> Christoph had noted that this seemed associated to the problem
> that the btrfs uses different assignments for st_dev than s_dev,
> but much as I'd like to see that changed based on discussions so
> far its unclear if this is going to be possible unless strong
> commitment is reached.

Explain, please.  Whose commitment and commitment to what, exactly?
Having different ->st_dev values for different files on the same
fs is a bloody bad idea; why does btrfs do that at all?  If nothing else,
it breaks the usual "are those two files on the same fs?" tests...
