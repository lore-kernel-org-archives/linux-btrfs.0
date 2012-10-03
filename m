Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35004 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590Ab2JCUnj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 16:43:39 -0400
Received: by wgbdr13 with SMTP id dr13so6466774wgb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 13:43:38 -0700 (PDT)
Date: Wed, 3 Oct 2012 23:43:35 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Goffredo Baroncelli <kreijack@gmail.com>,
        linux-btrfs@vger.kernel.org, Roman Mamedov <rm@romanrm.ru>,
        =?utf-8?Q?S=C3=A9bastien?= Maury <sebastien.maury@inserm.fr>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 1/2] Update btrfs filesystem df command
Message-ID: <20121003204335.GE2890@zambezi.lan>
References: <1349284952-6865-1-git-send-email-kreijack@inwind.com>
 <1349284952-6865-2-git-send-email-kreijack@inwind.com>
 <20121003203400.GD2890@zambezi.lan>
 <20121003203852.GE25498@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121003203852.GE25498@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 03, 2012 at 09:38:52PM +0100, Hugo Mills wrote:
> On Wed, Oct 03, 2012 at 11:34:00PM +0300, Ilya Dryomov wrote:
> > On Wed, Oct 03, 2012 at 07:22:31PM +0200, Goffredo Baroncelli wrote:
> [snip]
> > > +static const char * const cmd_disk_free_usage[] = {
> > > +	"btrfs filesystem df [-d|-s][-k] <path> [<path>..]",
> > > +	"Show space usage information for a mount point(s).",
> > > +	"",
> > > +	"-k\tSet KB (1024 bytes) as unit",
> > > +	"-s\tShow the summary section only",
> > > +	"-d\tShow the detail section only",
> > > +	NULL
> > > +};
> > > +
> > > +static int cmd_disk_free(int argc, char **argv)
> > > +{
> > > +
> > > +	int 	flags=DF_SHOW_SUMMARY|DF_SHOW_DETAIL|DF_HUMAN_UNIT;
> > > +	int	i, more_than_one=0;
> > > +
> > > +	optind = 1;
> > > +	while(1){
> > > +		char	c = getopt(argc, argv, "dsk");
> > > +		if(c<0)
> > > +			break;
> > > +		switch(c){
> > > +			case 'd':
> > > +				flags &= ~DF_SHOW_SUMMARY;
> > > +				break;
> > > +			case 's':
> > > +				flags &= ~DF_SHOW_DETAIL;
> > > +				break;
> > > +			case 'k':
> > > +				flags &= ~DF_HUMAN_UNIT;
> > > +				break;
> > > +			default:
> > > +				usage(cmd_disk_free_usage);
> > > +		}
> > > +	}
> > > +
> > > +	if( !(flags & (DF_SHOW_SUMMARY|DF_SHOW_DETAIL)) ){
> > > +		fprintf(stderr, "btrfs filesystem df: it is not possible to specify -s AND -d\n");
> > 
> > This doesn't look right at all.  You are adding two switches and
> > specifying both of them is an error?  A little too much for a command
> > whose job is to do some basic math and pretty-print the result.
> > 
> > How about displaying just the summary by default and then adding a
> > *single* switch (-v or whatever) for summary+details?
> 
>    I'd prefer to see both sections by default. The reason for this is
> that without both sections, people tend to get confused because they
> don't know they're looking at half the story (e.g. some numbers change
> twice as fast as they think they should).

If we want both sections by default, there is no need for any switches
whatsoever, I think.

Thanks,

		Ilya
