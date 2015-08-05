Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbbHEROO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 5 Aug 2015 13:14:14 -0400
Date: Wed, 5 Aug 2015 19:13:53 +0200
From: David Sterba <dsterba@suse.com>
To: Martin <sha256sum@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Why subvolume and not just volume?
Message-ID: <20150805171353.GH31669@twin.jikos.cz>
Reply-To: dsterba@suse.com
References: <CAK4jXzy8OpRMnF=hYEamZVxiumH9Xn_8uDo_xOQhYfLf3cA9dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAK4jXzy8OpRMnF=hYEamZVxiumH9Xn_8uDo_xOQhYfLf3cA9dA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 05, 2015 at 09:06:40AM +0200, Martin wrote:
> Also, what is the penalty of a subvolume compared to a directory? From
> a design perspective, couldn't all directories just be subvolumes?

They could, but this would bring severe performance drop.

* creating a subvolume implies a transaction commit
* the subvolumes act like a mountpoint boundary so it needs to resolve
  the next subvolume root before directory traversal can descend to it

You can try to create a deep hierarchy of directories and then do the
same with subvolumes. The difference is too big for practical purposes.
