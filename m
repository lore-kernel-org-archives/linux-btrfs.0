From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Thu, 25 Aug 2011 02:06:32 -0400
Message-ID: <20110825060632.GA9933@infradead.org>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
 <1309275199-10801-5-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, xfs@oss.sgi.com,
	viro@ZenIV.linux.org.uk, dchinner@redhat.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1309275199-10801-5-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 28, 2011 at 11:33:19AM -0400, Josef Bacik wrote:
> This is a test to make sure seek_data/seek_hole is acting like it does on
> Solaris.  It will check to see if the fs supports finding a hole or not and will
> adjust as necessary.

Can you resend this with any updates that happened in the meantime?

Dave also still had some comments about semantics, so it might be worth
to incorporate that as well.

