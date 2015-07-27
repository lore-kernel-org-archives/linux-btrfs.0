Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw11a.wadns.net ([196.220.39.53]:47658 "EHLO fw11a.wadns.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbbG0Wjc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jul 2015 18:39:32 -0400
Message-ID: <55B6AF40.5040107@swiftspirit.co.za>
Date: Tue, 28 Jul 2015 00:22:56 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Omar Sandoval <osandov@fb.com>, dsterba@suse.com, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] btrfs: add replace missing and replace RAID 5/6 to
 profile configs
References: <cover.1437683940.git.osandov@fb.com> <6d332e954da29e8418689cb49294a68da2fa5376.1437683940.git.osandov@fb.com> <20150724120946.GT6306@twin.jikos.cz> <20150724175043.GA14974@huxley.DHCP.TheFacebook.com>
In-Reply-To: <20150724175043.GA14974@huxley.DHCP.TheFacebook.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 2015/07/24 07:50 PM, Omar Sandoval wrote:
> On Fri, Jul 24, 2015 at 02:09:46PM +0200, David Sterba wrote:
>> On Thu, Jul 23, 2015 at 01:51:50PM -0700, Omar Sandoval wrote:
>>> +			# We can't do replace with these profiles because they +
>>> # imply only one device ($SCRATCH_DEV), and we need to +			#
>>> keep $SCRATCH_DEV around for _scratch_mount +			# and
>>> _check_scratch_fs. +			local unsupported=( +				"single" +
>>> "dup"
>> 
>> DUP does imply single device, but why does 'single' ?
> 
> It does not, I apparently forgot that you could use single to 
> concatenate multiple devices. I'll fix that in v2.
> 
> Thanks for reviewing!
> 
Late to the party. DUP *implies* single device but there are cases
where dup is used on a multi-device fs. Even if the use-cases aren't
good or intended to be long-term, they are still valid, right?


- -- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (MingW32)

iQEcBAEBAgAGBQJVtq9AAAoJEE+uni74c4qN5eYIAJAGznsi3RD1tchbSLwhMXJk
bJJ4ORB9taLXHykSfYTsHIaUoVpcVR6tT/I1jz5070DY3mKkQ16a8nwtSxPba4Lv
QiS8YRegFiHMYzZbH1T7Tnm6R9g/RZsaU7GS3JhP9HUYG7hIWGRRuoiOjYn/hoLw
uMXuIFOkPKGYDgyAhDIp3KDYlBjMHT6Oun7CcpvTjXiOnzJFFp3MSt3b6mmmdMVV
YKWpWyKVh7qlENEoqKb4exqr1WGYKU+kBLXRs4wdm3xb66EcWYs0Er1u6v+K1trx
nryFrfUxYtMJsSuR9ZJm88DOsXKAuX1LEdRKVOlq7krsIK8HlTizccMXAl10gKk=
=ndkL
-----END PGP SIGNATURE-----
