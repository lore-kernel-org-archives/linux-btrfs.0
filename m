From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v8 2/8] btrfs: Cancel filesystem balance
Date: Wed, 29 Jun 2011 12:43:23 +0200
Message-ID: <20110629104323.GT12709@twin.jikos.cz>
References: <1309120615-18104-1-git-send-email-hugo@carfax.org.uk>
 <1309120615-18104-3-git-send-email-hugo@carfax.org.uk>
 <4E0ABF74.1070901@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hugo Mills <hugo@carfax.org.uk>,
	Btrfs mailing list <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dave@jikos.cz>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0ABF74.1070901@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 29, 2011 at 02:00:20PM +0800, Li Zefan wrote:
> Hugo Mills wrote:
> > @@ -2149,6 +2150,10 @@ int btrfs_balance(struct btrfs_root *dev_root)
> >  		       bal_info->completed, bal_info->expected);
> >  	}
> >  	ret = 0;
> > +	if (bal_info->cancel_pending) {
> > +		printk(KERN_INFO "btrfs: balance cancelled\n");
> > +		ret = -EINTR;
> > +	}
> 
> Why not detect if there's any pending signal in the while loop? so
> we can just use Ctrl+C to cancel balance.

Balance is capable of running in background, you could not send the
Ctrl-C to such process.


david
