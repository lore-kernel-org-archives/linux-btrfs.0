From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] btrfs: fix directory offsets for '.' and '..' entries
Date: Sun, 11 Sep 2011 17:06:25 -0400
Message-ID: <20110911210624.GA17583@infradead.org>
References: <1315773216-8490-1-git-send-email-notasas@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Grazvydas Ignotas <notasas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1315773216-8490-1-git-send-email-notasas@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 11, 2011 at 11:33:36PM +0300, Grazvydas Ignotas wrote:
> Currently getdents syscall returns wrong offset for '.' directory entry,
> which confuses some programs like wine. This can be observed with an
> example program getdents(2) manpage:

Can you submit a patch to add your testcase to xfstests?

