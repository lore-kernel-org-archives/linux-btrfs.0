Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:47873
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725AbaGDVG5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Jul 2014 17:06:57 -0400
Received: from outbound-edge-1.mail.thdo.gradwell.net (bonnie.gradwell.net [212.11.70.2])
	by outbound-queue-1.mail.thdo.gradwell.net (Postfix) with ESMTP id 7C054221F4
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Jul 2014 22:06:56 +0100 (BST)
Message-ID: <53B7176F.1020409@barrowhillfarm.org.uk>
Date: Fri, 04 Jul 2014 22:06:55 +0100
From: Bob Williams <linux@barrowhillfarm.org.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: A question about subvolumes
References: <53B6BC65.3080302@barrowhillfarm.org.uk> <53B710C9.9020601@libero.it>
In-Reply-To: <53B710C9.9020601@libero.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/07/14 21:38, Goffredo Baroncelli wrote:
> On 07/04/2014 04:38 PM, Bob Williams wrote:
>> I have a disc formatted as btrfs, on which is mounted /home.
>> 
>> /home/bob is a regular directory.
>> 
>> /home/bob/Documents is a btrfs subvolume
>> 
>> /home is btrfs root
>> 
>> If I do
>> 
>> # mv /home/bob /home/bob_original # btrfs subvolume create
>> /home/bob # mv /home/bob_original/* /home/bob/ # rm
>> /home/bob_original
>> 
>> will the original subvolume /home/bob/Documents survive this 
>> operation, and will it now exist as a subvolume under the new 
>> subvolume /home/bob?
> 
> Yes.
> 
> A subvolume is a way to partition a btrfs file-system. You can
> think a subvolume like a filesystem. For objects like files and
> directory a move command between *different* subvolumes is equal to
> a copy+remove. If fact is like you are moving data between
> different file-systems.
> 
> Instead moving a subvolume  in *its btrfs filesystem* is a cheap
> operation (is like moving a link); this is true even if you move a
> subvolume between different subvolumes.
> 
> To increase the speed when you move files between subvolumes (of
> the *same* btrfs filesystem), you could do a "cp --reflink" + "rm"
> instead of a "mv"; eg
> 
> # mv subvolume-A/* subvolume-B/
> 
> is equal to
> 
> # cp -rf  subvolume-A/* subvolume-B/ # rm -rf subvolume-A/*
> 
> but # cp --reflink -R  subvolume-A/* subvolume-B/ # rm -rf
> subvolume-A/
> 
> is faster  because "cp --reflink" shared the data between source
> and destination. This means that you are doing a copy (and a
> delete) of metadata only.
> 
> 
Thank you, Goffredo. As the current /home/bob is not a subvolume, but
a regular linux directory/folder, will the "cp --reflink" still carry
the same speed advantage?

In other words, using your example above, will this work:

	# cp --reflink -R normal_directory-A/* subvolume-B/
	# rm -rf normal_directory-A/


- -- 
Bob Williams
System:  Linux 3.11.10-17-desktop
Distro:  openSUSE 13.1 (x86_64) with KDE Development Platform: 4.13.2
Uptime:  06:00am up 5 days 20:14, 3 users, load average: 0.00, 0.04, 0.08
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlO3F24ACgkQ0Sr7eZJrmU5UaACfcxJObM9sEzaRIoDGBhXCsWXz
lb4An3OwTzXu/l4r/IhT1u+DbLcVPg3h
=S0Hg
-----END PGP SIGNATURE-----
