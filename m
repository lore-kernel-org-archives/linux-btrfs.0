From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/2] fs: add a DCACHE_NEED_LOOKUP flag for d_flags V2
Date: Mon, 23 May 2011 12:13:07 -0400
Message-ID: <4DDA8793.3010906@redhat.com>
References: <1305913471-3150-1-git-send-email-josef@redhat.com> <20110522021130.GI19987@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger@dilger.ca, hch@lst.de
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110522021130.GI19987@ZenIV.linux.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/21/2011 10:11 PM, Al Viro wrote:
> On Fri, May 20, 2011 at 01:44:30PM -0400, Josef Bacik wrote:
>> +		if (unlikely(d_need_lookup(dentry))) {
>> +			if (nameidata_dentry_drop_rcu(nd, dentry))
>> +				return -ECHILD;
>> +			dput(dentry);
>> +			dentry = NULL;
>> +			goto retry;
> 
> Yecchhh...  How about simple goto unlazy; here instead and doing the rest
> there?  Especially since you have the same kind of thing elsewhere in the
> same sucker.  It had been bloody painful to untangle that thing; let's not
> add to the rat's nest that still remains...

This is where I was a little confused, which is why I added this code.  It
seems that having goto unlazy; will mean that we will come down to this
section

if (unlikely(status  <= 0 )) {
	if (status < 0) {
		dput(dentry);
		return status;
	}
        if (!d_invalidate(dentry)) {
		dput(dentry);
		dentry = NULL;
		need_reval = 1;
		goto retry;
	}
}

and d_invalidate will unhash us so we won't find our new dentry in the cache
which makes this whole exercise useless.  Is there a different way you'd
like
this cleaned up?  Thanks,

Josef

