From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH] Btrfs-progs: fail gracefully on error from open_ctree()
Date: Mon, 12 Dec 2011 20:07:53 +0200
Message-ID: <20111212180753.GA19312@zambezi.lan>
References: <1320184042-5188-1-git-send-email-idryomov@gmail.com>
 <20111212144018.GB7322@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Hugo Mills <hugo@carfax.org.uk>
To: David Sterba <dave@jikos.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111212144018.GB7322@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 12, 2011 at 03:40:19PM +0100, David Sterba wrote:
> On Tue, Nov 01, 2011 at 11:47:22PM +0200, Ilya Dryomov wrote:
> > --- a/mkfs.c
> > +++ b/mkfs.c
> > @@ -1328,7 +1328,12 @@ int main(int ac, char **av)
> >  		fprintf(stderr, "error during mkfs %d\n", ret);
> >  		exit(1);
> >  	}
> > +
> >  	root = open_ctree(file, 0, O_RDWR);
> > +	if (!root) {
> > +		fprintf(stderr, "ctree init failed\n");
> > +		return -1;
> 
> I know you just moved the code, but this should be exit(1), same as the
> rest of the function does

I updated the patch.

Thanks,

		Ilya
