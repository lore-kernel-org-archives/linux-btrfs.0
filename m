Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fieldses.org ([174.143.236.118]:36857 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbaBXUXK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 15:23:10 -0500
Date: Mon, 24 Feb 2014 15:23:04 -0500
To: Christoph Hellwig <hch@infradead.org>
Cc: "J. Bruce Fields" <bfields@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 5/9] dcache: d_obtain_alias callers don't all want
 DISCONNECTED
Message-ID: <20140224202304.GA25916@fieldses.org>
References: <20140218202652.GA12374@fieldses.org>
 <1392755345-12830-1-git-send-email-bfields@redhat.com>
 <1392755345-12830-5-git-send-email-bfields@redhat.com>
 <20140221014414.GC24522@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140221014414.GC24522@infradead.org>
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 20, 2014 at 05:44:14PM -0800, Christoph Hellwig wrote:
> >  
> > -	return d_obtain_alias(inode);
> > +	return d_obtain_alias_root(inode);
> 
> Can we call this d_obtain_root or similar, please?

Yes, I like d_obtain_root better, done.

I'll send out the updated series sometime.

--b.
