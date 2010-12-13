From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: RE: [PATCH] Btrfs: pwrite blocked when writing from the mmaped
 buffer of the same page
Date: Mon, 13 Dec 2010 16:26:04 +0800
Message-ID: <1865303E0DED764181A9D882DEF65FB68594D08540@shsmsx502.ccr.corp.intel.com>
References: <1291708775-4484-1-git-send-email-xin.zhong@intel.com>
 <20101207165433.GA976@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101207165433.GA976@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have sent my test case to xfs mailing list (No. 248). 
Please help to review it. Thanks!

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org] 
Sent: Wednesday, December 08, 2010 12:55 AM
To: Zhong, Xin
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: pwrite blocked when writing from the mmaped buffer of the same page

Care to write a xfstests test for this behaviour?

