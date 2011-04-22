From: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Fri, 22 Apr 2011 15:10:01 -0500
Message-ID: <20110422200945.GA15387@elie>
References: <1303414954-3315-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@infradead.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1303414954-3315-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Josef Bacik wrote:

> This just gets us ready to support the SEEK_HOLE and SEEK_DATA flags.  Turns out
> using fiemap in things like cp cause more problems than it solves, so lets try
> and give userspace an interface that doesn't suck.  So we have

That's easy to believe, but could you elaborate?  What problem does
using fiemap cause?  I assume the answer is somewhere in somewhere in
the thread

 http://thread.gmane.org/gmane.comp.file-systems.xfs.general/37895/focus=24404

but it would be nice to have a summary in the commit log for
posterity.

Thanks for working on this.
