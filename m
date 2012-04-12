From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] fs: make i_generation a u64
Date: Thu, 12 Apr 2012 15:49:56 -0400
Message-ID: <20120412194955.GO1924@localhost.localdomain>
References: <1334176968-8687-1-git-send-email-josef@redhat.com>
 <20120412194217.GC26332@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, viro@ZenIV.linux.org.uk
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120412194217.GC26332@thunk.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2012 at 03:42:17PM -0400, Ted Ts'o wrote:
> On Wed, Apr 11, 2012 at 04:42:48PM -0400, Josef Bacik wrote:
> > Btrfs stores generation numbers as 64bit numbers, which means we have to
> > carry around a u64 in our incore inode in addition to setting i_generation.
> > So convert to a u64 so btrfs can kill it's incore generation.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> 
> Why is btrfs using a 64-bit generation number, out of curiosity?  The
> only user of the inode generation number as far as I can tell is NFS,
> and even NFSv4 is using a 32-bit generation number....
> 

It's just tied to our transaction id #'s which are 64bit, no super awesome
reason or anything.  Thanks,

Josef
