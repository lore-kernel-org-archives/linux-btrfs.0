From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH] mkfs: Handle creation of filesystem larger than the first
 device
Date: Wed, 08 Feb 2012 17:01:15 -0500
Message-ID: <4F32F0AB.8030003@ubuntu.com>
References: <1327593785-23466-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.cz>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1327593785-23466-1-git-send-email-jack@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/26/2012 11:03 AM, Jan Kara wrote:
> make_btrfs() function takes a size of filesystem as an argument. It
> uses this value to set the size of the first device as well which
> is wrong for filesystems larger than this device. It results in
> 'attemp to access beyond end of device' messages from the kernel.
> So add size of the first device as an argument to make_btrfs().

I don't think this patch is correct.  Yes, the size switch only
applies to the first device, so it doesn't make any sense to try to
use a value larger than that device.  Attempting to do so probably
should be trapped and it should error out, and the man page should
probably clarify the fact that the size is only for the first device.

It looks like you think the size should somehow apply to multiple
devices or to the total fs size when creating on multiple devices, and
that just doesn't make sense.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPMvCrAAoJEJrBOlT6nu75A/IH/3Pn9MFhxXI1kTu1jriA/1ZA
IaCPkZbNFvS1DC5U8E75Ys4Qtn/SkwVOdGG8VCObfJKhhbWXEGKLdtllxV8WUkRM
QYN3rFeb3gLxb9UIcyyRC+RDtJtVzVXClFN7WYgA2QXmCyYdnV3axzvO/tkvADuq
Is28sKnYzV9poKTlghqFmEGmqcnTtfFKg9MC60wGDKEOMuAeijImGaAEp773G7+S
JSOOPcuDj/Lh7ZO+duR2ul+zUI9DWr2IbZM6zUxOoN2fZEJAwJLNPsU7rBDX8w+g
FVHFHrRv6wVGq0I7Dvb2flif5O0wSRA5yhK/7GanaVEMBKSV9A0c5qOE9LakL/s=
=X7QW
-----END PGP SIGNATURE-----
