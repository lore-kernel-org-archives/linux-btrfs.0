Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:38956 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbbDTOZ3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 10:25:29 -0400
Date: Mon, 20 Apr 2015 14:25:27 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: sri <toyours_sridhar@yahoo.co.in>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send to file differences
Message-ID: <20150420142527.GJ18187@carfax.org.uk>
References: <loom.20150420T160700-483@post.gmane.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NPWyolIJAVLYbHY6"
In-Reply-To: <loom.20150420T160700-483@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NPWyolIJAVLYbHY6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 20, 2015 at 02:15:47PM +0000, sri wrote:
> Hi,
> 
> I have a subvolume with only one file (file.txt) with 5Mb size.
> under /btrfs/subvol1/
> 1)
> I have created 1st snapshot /btrfs/snap1_subvol1. Then I ran "btrfs 
> send" and given -f out1.img
> 
> size of out1.img is 5Mb.
> 
> 2)
> Next, I have appended 1Mb data to file.txt
> 
> And again created snapshot /btrfs/snap2_subvol2. And rand "btrfs send" 
> out put to file out2.img
> 
> 3)
> After that I ran "btrfs send -p  /btrfs/snap1_subvol1 
> /btrfs/snap2_subvol1 -f outwith_poption.img.
> 
> Beween out1.img and out2.img there is difference of 1Mb
> 
> I would like to know what is the difference between out2.img and 
> outwith_poption.img ?
> 
> When I do btrfs send to a file, is there a way to send only changes to 
> new file i.e. for step 2 and step 1, out2.img is 6Mb and out1.img is 
> 5Mb.

   Basically, do exactly what you did with step 3. -p is the base
subvolume, and only the differences from that are sent.

   Hugo.

> can I get difference if the file and use it as input to btrfs receive 
> option if I want to recover incremental recover i.e out1.img + 1Mb ??
> 
> Here with my steps I can give only out2.img which is of 6Mb or out1.img 
> which is of 5Mb.
> So for incremetal backup, it consumes total of 11Mb.
> I want a way to reduce it to total of 6Mb but there should a way to 
> recover from fist snapshot dump and second snapshot dump as well.

-- 
Hugo Mills             | UDP jokes: It's OK if no-one gets them.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--NPWyolIJAVLYbHY6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJVNQxXAAoJEFheFHXiqx3kvL8QAKS1sPSH0w5eVXuGzqhEXo+T
GobixsVQAZT0583+iWt32HFAkEXDDRU05WxecizN9yeUxuyRzH5hkb7jgRUC/nts
O8vv8xU7wvTq4bX425cjdIw+x1x830HG946Hc46sagjZW83Sw5CG/QDrYVRuC6u6
cFqWNOFQkzplW99NeO7A9iPICGk/tLfAZlIRRVHa0DSpM5hfkZ2HMN6VFodEv+CJ
+LQ5LCBaHlWuudJlWainH1sjxH8AQbh+01h8dgvgHde2/u5oWzubAMUt2XaBijZj
LU8MZMwx4NelmIy4Hci1/Ogjpd5t4iDWCIsJVTG3CLAcRT2cVXI931y+0H+lLoZB
l4RwWRShjuwhVm3xBJXjz1njocHdk29+w1ADeH/l6MvXTd/8JE3CXoFcxt2wsDlG
hBEOoBphdlQ6ShyNexQNBNJ3baEP+GeschTn9/p+EWRY+nuzEKUZOvcAHhFB9HuK
O/I0l0A1Ps6RZ04hq1E+N51Z2kNrFEJTL0X/vU7r56ydawniB/c6NELF/2YQeDyg
AEjGirfdqEeGvoF+6xq/FPTuxmEJGw2yWEFYohk8JHdm0G10hmb45mD3JiU/354l
jTIsQk1IIDpoQStrXcq6NkqCp0MRkIh7q16LnreCqV3S7t/HNayitF0K6ZclgGS5
Ru3WCp02NogPLsmhpLTa
=nACi
-----END PGP SIGNATURE-----

--NPWyolIJAVLYbHY6--
