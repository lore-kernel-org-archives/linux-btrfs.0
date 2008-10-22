From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 14:27:59 +0200
Message-ID: <20081022142759.ac33a16c.skraw@ithnet.com>
References: <20081021132322.271ad728.skraw@ithnet.com>
	<48FDD710.5050702@hp.com>
	<20081021190136.89b2c6af.skraw@ithnet.com>
	<20081021171513.GA8799@infradead.org>
	<48FE11F9.7040700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Christoph Hellwig <hch@infradead.org>, jim owens <jowens@hp.com>,
	linux-btrfs@vger.kernel.org
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FE11F9.7040700@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 21 Oct 2008 13:31:37 -0400
Ric Wheeler <ricwheeler@gmail.com> wrote:

> [...]
> If you have remapped a big chunk of the sectors (say more than 10%), you 
> should grab the data off the disk asap and replace it. Worry less about 
> errors during read, writes indicate more serious errors.

Ok, now for the bad news: money is invented.
If you replace a disk before real failure you won't get replacement from the
manufacturer. That may sound irrelevant to someone handling 5 disks, but is
significant if handling 500 or more. The replacement rate is indeed much
higher than people think from their home pcs.

> [...]
> ric

-- 
Regards,
Stephan
