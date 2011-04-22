From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Thu, 21 Apr 2011 21:23:50 -0600
Message-ID: <20110422032350.GF31296@parisc-linux.org>
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <EB7F482C-0195-4C63-9436-17B417C8DCD7@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	hch@infradead.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <EB7F482C-0195-4C63-9436-17B417C8DCD7@mit.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 21, 2011 at 04:45:54PM -0400, Theodore Tso wrote:
> 
> On Apr 21, 2011, at 3:42 PM, Josef Bacik wrote:
> 
> > +	case SEEK_DATA:
> > +	case SEEK_HOLE:
> > +		return -EINVAL;
> > 	}
> 
> Maybe we should be returning EOPNOTSUPP?

That's definitely wrong ... -ENOSYS might be better!

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
