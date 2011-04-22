From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Fri, 22 Apr 2011 00:47:40 -0400
Message-ID: <20110422044740.GA17795@infradead.org>
References: <1303414954-3315-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@infradead.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1303414954-3315-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

We'll also need:

 - a patch to lseek(2) to document the new flags
 - some testcases for xfstests, specially dealing with things that
   were problematic in FIEMAP, e.g. data in delalloc extents, making
   sure stuff in unwrittent extents partially converted actually gets
   copied, etc.
