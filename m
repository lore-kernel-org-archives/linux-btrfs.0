From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH V2] Removing a subvolume by an ordinary user
Date: Sun, 17 Oct 2010 17:53:44 +0200
Message-ID: <201010171753.45661.kreijack@libero.it>
References: <201010112008.31736.kreijack@libero.it> <1286859944.3013.10.camel@localhost>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1286859944.3013.10.camel@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, 12 October, 2010, Ian Kent wrote:
> On Mon, 2010-10-11 at 20:08 +0200, Goffredo Baroncelli wrote:
[...]
> > +	ret = btrfs_unlink_subvol(trans, root, dir,
> > +				dest->root_key.objectid,
> > +				dentry->d_name.name,
> > +				dentry->d_name.len);
> > +	BUG_ON(ret);
> 
> Is it really a good idea to add even more dead end BUG_ON() calls
> instead of handling errors when they happen?
> 

I agree with your comment, I copied these lines from the ioctl DESTROY_SUBVOL.
Unfortunately I don't have the know-how to handle an error at this level. So I 
can only leave the code as the original one.

[...]

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
