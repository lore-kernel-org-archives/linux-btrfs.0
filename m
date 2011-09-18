From: Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/7] BTRFS: Fix lseek return value for error
Date: Sat, 17 Sep 2011 18:46:08 -0700
Message-ID: <20110918014608.GA16198@alboin.amr.corp.intel.com>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
 <1316128013-21980-2-git-send-email-andi@firstfloor.org>
 <20110916154815.GA27150@infradead.org>
 <4E7439EB.7080100@oracle.com>
 <41C7FF67-8658-4E7F-BB50-E9AAEA1F755C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "jeff.liu@oracle.com" <jeff.liu@oracle.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <andi@firstfloor.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <41C7FF67-8658-4E7F-BB50-E9AAEA1F755C@dilger.ca>
List-ID: <linux-btrfs.vger.kernel.org>

> > with an additional improvement if the offset is larger or equal to the
> > file size, return -ENXIO in directly:
> > 
> >                if (offset >= inode->i_size) {
> >                        mutex_unlock(&inode->i_mutex);
> >                        return -ENXIO;
> >                }
> 
> Except that is wrong, because it would then be impossible to write sparse files. 

And also i_size must be always read with i_size_read()

Anyways clearly there's a problem in btrfs land with merging fixes in time.
Is anyone collecting patches while Chris is gone?

-Andi

