From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 05/21] Btrfs: add basic restriper infrastructure
Date: Tue, 1 Nov 2011 12:07:34 +0100
Message-ID: <20111101110734.GE12759@twin.jikos.cz>
References: <1314129722-31601-1-git-send-email-idryomov@gmail.com> <1314129722-31601-6-git-send-email-idryomov@gmail.com> <4EAFC526.4040701@gmx.net>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ilya Dryomov <idryomov@gmail.com>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>
To: Arne Jansen <sensille@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EAFC526.4040701@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2011 at 11:08:38AM +0100, Arne Jansen wrote:
> > +/*
> > + * Should be called with restripe_mutex held
> > + */
> > +int btrfs_restripe(struct restripe_control *rctl)
> > +{
...
> > +	if (rctl->data.target & BTRFS_BLOCK_GROUP_DUP) {
> > +		printk(KERN_ERR "btrfs: dup for data is not allowed\n");
> > +		ret = -EINVAL;
> > +		goto out;
> > +	}
> 
> It would be good to get these error messages somehow to the user,
> or at least give the user a hint to look in dmesg.

the restriper command ends with EINVAL which is in most cases returned
as a result of the ioctl and progs counterpart will

1117                         fprintf(stderr, "ERROR: error during restriping '%s' "
1118                                 "- %s\n", path, strerror(e));
1119                         return 19;

the hint should go there imho.


david
