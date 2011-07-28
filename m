From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH 1/4] xfstests: Add support for btrfs in 062
Date: Thu, 28 Jul 2011 19:51:26 +0200
Message-ID: <4E31A19E.3040404@giantdisaster.de>
References: <cover.1311776403.git.sbehrens@giantdisaster.de> <d42f34a30289157f262ffe31760a54cc1b5d3d4b.1311776403.git.sbehrens@giantdisaster.de> <20110728084504.GA3407@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110728084504.GA3407@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 7/28/2011 10:45 AM, Christoph Hellwig wrote:
> On Thu, Jul 28, 2011 at 10:27:58AM +0200, Stefan Behrens wrote:
>> Added btrfs to the list of supported filesystems for this test.
>> Remove output of mkfs since this is specific to mkfs.xfs and now filtered
>> out.
> 
> Why can't it be generic?  Any reason this one doesn't work on e.g. ext2
> or reiserfs?

The only reason for not making the tests 015, 062, 083, 117, 120 and
192 "_supported_fs generic" was to keep the effect of the changes
minimal.
But I agree that they are generic ones and I have now changed it
accordingly in the revised patch series that I will send soon.
Thanks for your comments!
