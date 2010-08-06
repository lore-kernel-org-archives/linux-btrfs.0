From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH 3/6 - direct-io: do not merge logically non-contiguous
 requests
Date: Fri, 6 Aug 2010 08:03:58 -0400
Message-ID: <20100806120358.GA31601@infradead.org>
References: <4C5BE8DB.5030503@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, hch@infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C5BE8DB.5030503@linux.vnet.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

Something is deeply wrong here.  Raw block device access has a 1:1
mapping between logical and physical block numbers.  They really should
never be non-contiguous.
