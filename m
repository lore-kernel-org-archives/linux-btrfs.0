From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: How to get the default subvolume?
Date: Fri, 08 Jul 2011 12:01:38 +0200
Message-ID: <4E16D582.6050808@gmail.com>
References: <20110708095802.GA11513@yangyi-dev.bj.intel.com> <20110708095802.GA19280@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, Yi Yang <yi.y.yang@intel.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110708095802.GA19280@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 08.07.2011 11:58, Hugo Mills wrote:
> On Fri, Jul 08, 2011 at 05:58:02PM +0800, Yi Yang wrote:
>> I know I can set the default subvolume for a btrfs fs using
>>
>> sudo btrfs subvolume set-default 256 /btrfs/mnt
>>
>> But after that, how can get the default subvolume name? In my opinion,
>> btrfs-progs should provide "btrfs subvolume get-default /btrfs/mnm" to
get
>> the default subvolume id and name, I think it is very easy to do this in
>> btrfs-progs and btrfs kernel space.
>
> I don't think the current btrfs-progs will do it. As you pointed
> out though, it's pretty easy to write the code to get the information
> (I implemented it for btrfs-gui without any additional kernel code,
> for example). We just need someone to implement it. :)
>
> I'd do it myself, but there's about a dozen things higher up my
> priority list right now.
>
Well, I'd be happy to try it. If it's fine, I will try to follow the
implementation from btrfs-gui.
 
Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJOFtWBAAoJEJIcBJ3+Xkgi/loP/jBB2BnrDvdRrN+gxP5XcCr8
62ZgP2XxO/MrIH5Xc4iNfUlMF8Fnttjr8LvjpbP3Q2Vfb2ogPPf6ALpBxtCOhaHJ
yAFE4CvGon7f2sTGZO2EJxf4eSSoFUd19je+knPZOdyIDhc1lhXVp4LBeoPKySRe
GDBQtv1uqYx79hD24R5vU5uK1xMDTVE5HHCy8jZtoaVGU4YO87u7vFfNJKqAmS/W
tZbT3wkrod/HHo8sxS4ZKzPx1c0Ph/F3g/P8SWSHW5dmK/dSadRVe+Io09tyd6uu
GfGMMtEs6lVjHq/gn4ebDZwk3pFmCACnCxk6cE5imGWOIvftLMCFRZkFS41BVn7s
pAz+JEp7NaICKo3rbFlEZdvteBB0AaJTCeo2wAP0xD6aBEdT5MhxHZQCGi6PeRDn
2GTqw2gT+urTVa7Rr6O2PIQlC0mjFit6dVYcFzPIP/X+cXozDnuNeUmPD10VlEjN
PHIOJjNX3Zod8KknQc/NX0kn3TcHZptX0EWJhtnC0X4kHMxZOUrfnlIMTjCP23pX
TA4Zjc68fe5mDm75PnbT6h4QoLa5h3j8TWf8fYYFBC/FOcb4NFm4iJEA6AG7CS1l
MExGgd619NWUXHDpjjhTTzerBHF+1D5XPNc0lnb7WNkjzfBQD5JfkFzCp3lzTylU
dpaD5umGdM+1DlrD8NP/
=vM5/
-----END PGP SIGNATURE-----

