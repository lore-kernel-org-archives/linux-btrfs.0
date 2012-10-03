Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57307 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab2JCUiz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 16:38:55 -0400
Date: Wed, 3 Oct 2012 21:38:52 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Goffredo Baroncelli <kreijack@gmail.com>, linux-btrfs@vger.kernel.org,
        Roman Mamedov <rm@romanrm.ru>,
        =?iso-8859-1?Q?S=E9bastien?= Maury <sebastien.maury@inserm.fr>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 1/2] Update btrfs filesystem df command
Message-ID: <20121003203852.GE25498@carfax.org.uk>
References: <1349284952-6865-1-git-send-email-kreijack@inwind.com>
 <1349284952-6865-2-git-send-email-kreijack@inwind.com>
 <20121003203400.GD2890@zambezi.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ryJZkp9/svQ58syV"
In-Reply-To: <20121003203400.GD2890@zambezi.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ryJZkp9/svQ58syV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 03, 2012 at 11:34:00PM +0300, Ilya Dryomov wrote:
> On Wed, Oct 03, 2012 at 07:22:31PM +0200, Goffredo Baroncelli wrote:
[snip]
> > +static const char * const cmd_disk_free_usage[] = {
> > +	"btrfs filesystem df [-d|-s][-k] <path> [<path>..]",
> > +	"Show space usage information for a mount point(s).",
> > +	"",
> > +	"-k\tSet KB (1024 bytes) as unit",
> > +	"-s\tShow the summary section only",
> > +	"-d\tShow the detail section only",
> > +	NULL
> > +};
> > +
> > +static int cmd_disk_free(int argc, char **argv)
> > +{
> > +
> > +	int 	flags=DF_SHOW_SUMMARY|DF_SHOW_DETAIL|DF_HUMAN_UNIT;
> > +	int	i, more_than_one=0;
> > +
> > +	optind = 1;
> > +	while(1){
> > +		char	c = getopt(argc, argv, "dsk");
> > +		if(c<0)
> > +			break;
> > +		switch(c){
> > +			case 'd':
> > +				flags &= ~DF_SHOW_SUMMARY;
> > +				break;
> > +			case 's':
> > +				flags &= ~DF_SHOW_DETAIL;
> > +				break;
> > +			case 'k':
> > +				flags &= ~DF_HUMAN_UNIT;
> > +				break;
> > +			default:
> > +				usage(cmd_disk_free_usage);
> > +		}
> > +	}
> > +
> > +	if( !(flags & (DF_SHOW_SUMMARY|DF_SHOW_DETAIL)) ){
> > +		fprintf(stderr, "btrfs filesystem df: it is not possible to specify -s AND -d\n");
> 
> This doesn't look right at all.  You are adding two switches and
> specifying both of them is an error?  A little too much for a command
> whose job is to do some basic math and pretty-print the result.
> 
> How about displaying just the summary by default and then adding a
> *single* switch (-v or whatever) for summary+details?

   I'd prefer to see both sections by default. The reason for this is
that without both sections, people tend to get confused because they
don't know they're looking at half the story (e.g. some numbers change
twice as fast as they think they should).

   I think supplying both options should probably show both sections
again, and make it not an error to do so, but I'm happy either way.

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
  --- "He's a nutcase, you know. There's no getting away from it -- ---  
                     he'll end up with a knighthood"                     

--ryJZkp9/svQ58syV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUGyiXL9z9OVl50rAAQImOw/+JcglvzKn8hCyC05/hwHCILdcaIyL2Voa
qjX9Rs6ZgbkVclM9I7ujttwz3Xedbtx/C5Gm0FTVl8Kl1s33koVvi+4WBFpCLpe+
LPZO0OUBBH/LytfMQ1FNGhLZUNu4iIWh8lylaeXIsQCQzzJpr0vYKZku18dPNJi8
ITXHuQIp7LYjWl3gioDWQMb6x7vtP5mFKd4B8t15djypzu+rfhu29RV2CtGH8Cij
S7GjsrON4RWaMZfCPXlR9oVI2cVZChOrdskFvVoD/n2F/A5TxNYRjv0YGJUucqWp
6EyWnJoUENz4pyQX/zH6xySdmziJC/He7R02xtdo/bD6ie1VR2I+/xHSmoiBQXlt
feV0d9uJkl7gFNCv5RR8EFr49ReAH27oagjbyqty1U+lwtnwC9n+FsEmqvSFGRCV
HMqlY5XWMJjER4Z7c0gBokfnSIdAhXrwLD346qrbGQ4EeEubvvUsYHR3qLwqUzU8
psL7k7/anQWzUW0NRETEbNutMTG3/LnnI61fMDLVq72Q4y9peXpmIL7CNf3cU+xC
CoyN7WMQEd7EwxO3IwO+e5VRjiUmvX439NrvajD+65t0sIILcvQD7JpV5McKabx8
YqZSSKSSRKBUmSQTMwRwY8k5efcbp276OlykMSfSuLjuyFW5wS5LPnkSkuOpBi4B
ehesahrTxiE=
=xCB5
-----END PGP SIGNATURE-----

--ryJZkp9/svQ58syV--
