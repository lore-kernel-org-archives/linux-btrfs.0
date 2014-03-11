Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17811 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718AbaCKNdv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Mar 2014 09:33:51 -0400
Message-ID: <531F10B7.8010309@fb.com>
Date: Tue, 11 Mar 2014 09:33:43 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Lists <lists@benjamindsmith.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Testing BTRFS
References: <loom.20140306T191655-366@post.gmane.org>	<pan$ee422$4703cdfd$58fec22b$1a891275@cox.net>	<loom.20140307T144540-512@post.gmane.org> <pan$72cea$1961f20d$d4386bc$889c1510@cox.net> <531E5B44.6030502@benjamindsmith.com>
In-Reply-To: <531E5B44.6030502@benjamindsmith.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/10/2014 08:39 PM, Lists wrote:
> I'd like to begin testing BTRFS. We'd probably begin roll out in 6 
> months to a year if testing goes well.
> 
> We're currently using CentOS6/64 everywhere, are aware of BTRFS
> being a "Technology preview" in RHEL 7beta and would like to begin
> testing production-level load testing. We generate about 10 GB of
> distinct data daily that is stored redundantly by default on a
> combination of ZFS and Ext4.
> 
> Is there a "recommended way" to do this? Is it anywhere as easy as 
> ZFSonLinux yum install?
> 
> 

There is way too much churn for any "enterprise" distro to be able to
keep up with bugfixes and stuff.  You are best off rolling your own
kernel based on the stable series if you want to think about using
btrfs in production.  Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHxCtAAoJEANb+wAKly3BdJ8QAK5hYoNtJT/UEkpKakpNoXfV
q6lg2NVPT6EeHzcMhTRS+VTOJ/bjvfwX0qDxRkjvo73F+nkQYcrO78cEMvPqtwTq
HKxrGMibCtt5PlzzcbKqSc1VGIDFEkD2z7fr5y2n4V+E5x0EPCFxU6VOjXgqXyEZ
8tKW24oxLAwbWBvyiaKrB/gWm47Aw6p2pVWgWrqMjMFUaNQBoisAU+1Ezn0Xjg6w
4wazfGqUkUZ3pMcZr5IMQ9X+p+FUid7JWcdNwPjIsPMQhP7mkIK0Mq8eDu6ijVv2
nI52pZuYaZs3+7OlkEoHRssnAwIWUwUq9UQwRjl4WK8FrpgdyYe0n2zlZIWGinvF
qZRMmB5PtM+SYT9Wt5OPAgZxb/ivc9Vz7ACG4edNSBqZ1D7+52aazT4JY0fqWGGU
8vapdKUmyXPQT9MphvHUEqnJtA/K9ek8Frt+f304KCcl/0IEESAoo3InlS7Hw45D
ANEO4ZCwaUp/WjhqvwuvhYrqn8ENsbCm31RYAvAGEOoROzwXEnbl/Nv4DaKa+Q7b
I6uSpyS60cNA2wmKm3wzFGpvSkP8PMzA1zSepK/yJ9p3PxUdxUpY1OqYc8y7gqOf
+ACNUuNMbNwAhMb9udEZzuBZojX3/vVPlqOWLPYDr3fVCrDIwuSKtloao+czkrpo
sxJbe80q3rqtw+p0pStO
=n1mD
-----END PGP SIGNATURE-----
