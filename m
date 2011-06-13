From: Andreas Philipp <philipp.andreas@gmail.com>
Subject: Re: strange filefrag output on btrfs
Date: Mon, 13 Jun 2011 17:16:42 +0200
Message-ID: <4DF629DA.4050300@gmail.com>
References: <4DF38C23.7010603@gmail.com> <20110613115018.GT12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110613115018.GT12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 13.06.2011 13:50, David Sterba wrote:
> On Sat, Jun 11, 2011 at 05:39:15PM +0200, Andreas Philipp wrote:
>> On one of my btrfs volumes I see a strange output from filefrag when
>> run against a particular large (~8GB) file. filefrag and filefrag -v
>> give me a different number of extents, see below.
>>
>> aph@thor /mnt/nutshell $ sudo filefrag -v funtoo.img | grep extents
>> funtoo.img: 2624 extents found
>> aph@thor /mnt/nutshell $ sudo filefrag funtoo.img | grep extents
>> funtoo.img: 2653 extents found
>
> is the file open and being written to? did you run sync before the first
> command?
The file is not open. Yes, I have run sync before the first command.
Now, I tested again with a copy of file but the results is more or
less the same.

aph@thor /mnt/nutshell $ cp funtoo.img funtoo.1.img
aph@thor /mnt/nutshell $ sync
aph@thor /mnt/nutshell $ sudo filefrag -v funtoo.img funtoo.1.img |
grep extents
funtoo.img: 2624 extents found
funtoo.1.img: 57 extents found
aph@thor /mnt/nutshell $ sudo filefrag funtoo.img funtoo.1.img | grep
extents
funtoo.img: 2653 extents found
funtoo.1.img: 311 extents found

Thanks,
Andreas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
 
iQIcBAEBAgAGBQJN9inZAAoJEJIcBJ3+XkgiADgP/1+B26+vvEhb2cFy64gCh9c1
eeJJXgZgQsMkq4ScTwmdgBkG49XtFRao+IAJLT8NEEYfWK2s/e7COK5KvjqHQP6T
Z64TKo/SKD3YaskszZEO30fM/A9pXcsDDRaCgOXJosCjRfl2vNyxvSMjnRRGEGGL
F4qI9sr9pkZrqbzwIrhPFBm1etkwMOOrXyqByg/VQoNxTts6xZ9hz0l42qOhrjXW
EZ1zLRrDqd0HTBPmrkntG4yACBW4/eJf0vPPn7cNRFf1a6ts9UTAgEOkobgP4tho
D+mGle5bPElyB72tcQ2jutk9+qr89VrUjrNHNHU3QAI9ZtvWLeHIS1P2PkiXk/s2
xQKL83V8QGoeK8BQTB2exMf7cBrgoVs4IfTcXaQyperFRFTYtjQ78J8p2iPvwTKY
6/4LkHkIEPJO3IZ81TFv1Vm5wefGqMWnpTRgvzLv52UlbNEkdcvdNM5IWGiIhFD6
cVQohZuHaTidhn2ancBVd3qE3oYMiBQknvKG39seUw8zTRixz7Ac+/uF7kcQSP6U
4RatjRADGN99Kt4ydwpZbIBiDQxttR+Js/sv8E8skqll96LeT+DVzMh2JRx+iy93
eatIlrTIgoPfi3Oo+NUXczMfamYfG7UcVhBUxDlQUTtKPAhPHmXvE9pkjqIJ5sxD
3mkSkEZ6ZXGujyIPXnfQ
=Yx0a
-----END PGP SIGNATURE-----

