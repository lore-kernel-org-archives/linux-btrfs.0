From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Btrfs: pwrite blocked when writing from the mmaped
 buffer of the same page
Date: Tue, 7 Dec 2010 11:54:33 -0500
Message-ID: <20101207165433.GA976@infradead.org>
References: <1291708775-4484-1-git-send-email-xin.zhong@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Xin Zhong <xin.zhong@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291708775-4484-1-git-send-email-xin.zhong@intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

Care to write a xfstests test for this behaviour?

