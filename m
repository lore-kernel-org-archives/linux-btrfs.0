From: Jeff Garzik <jeff@garzik.org>
Subject: Re: Notes on support for multiple devices for a single filesystem
Date: Wed, 17 Dec 2008 16:27:58 -0500
Message-ID: <49496EDE.5080101@garzik.org>
References: <1227183484.6161.17.camel@think.oraclecorp.com>	 <1228962896.21376.11.camel@think.oraclecorp.com>	 <20081211141436.030c2d65.sfr@canb.auug.org.au>	 <20081210200604.8e190b0d.akpm@linux-foundation.org>	 <1229006596.22236.46.camel@think.oraclecorp.com>	 <20081215210323.GB5000@webber.adilger.int>	 <20081217132343.GA14695@infradead.org>	 <20081217115325.3312858a.akpm@linux-foundation.org>	 <1229547485.27170.77.camel@think.oraclecorp.com> <ac3eb2510812171320i414d89d4x9840954275774d51@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>, adilger@sun.com,
	sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510812171320i414d89d4x9840954275774d51@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Kay Sievers wrote:
> Features like the very nice and useful directory-based snapshots would
> also not be possible with simple block-based multi-devices, right?

Snapshotting via block device has always been an incredibly dumb hack, 
existing primarily because filesystem-based snapshots did not exist for 
the filesystem in question.

Snapshots are better at the filesystem level because the filesystem is 
the only entity that knows when the filesystem is quiescent and 
snapshot-able.

ISTR we had to add ->write_super_lockfs() to hack in support for LVM in 
this manner, rather than doing it the right way.

	Jeff


