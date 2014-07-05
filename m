Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:38077
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751316AbaGELnP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Jul 2014 07:43:15 -0400
Received: from outbound-edge-1.mail.thdo.gradwell.net (bonnie.gradwell.net [212.11.70.2])
	by outbound-queue-1.mail.thdo.gradwell.net (Postfix) with ESMTP id 29DDE22375
	for <linux-btrfs@vger.kernel.org>; Sat,  5 Jul 2014 12:43:14 +0100 (BST)
Message-ID: <53B7E4D1.9070803@barrowhillfarm.org.uk>
Date: Sat, 05 Jul 2014 12:43:13 +0100
From: Bob Williams <linux@barrowhillfarm.org.uk>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: A question about subvolumes
References: <53B6BC65.3080302@barrowhillfarm.org.uk> <53B710C9.9020601@libero.it> <53B7176F.1020409@barrowhillfarm.org.uk> <53B79AE4.3030404@libero.it>
In-Reply-To: <53B79AE4.3030404@libero.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/07/14 07:27, Goffredo Baroncelli wrote:
> On 07/04/2014 11:06 PM, Bob Williams wrote:
>> On 04/07/14 21:38, Goffredo Baroncelli wrote:
> 
>> 
>> Thank you, Goffredo. As the current /home/bob is not a
>> subvolume, but a regular linux directory/folder, will the "cp
>> --reflink" still carry the same speed advantage?
>> 
>> In other words, using your example above, will this work:
>> 
>> # cp --reflink -R normal_directory-A/* subvolume-B/ # rm -rf 
>> normal_directory-A/
> 
> Yes.
> 
> If you want to move (or copy) files between subvolume, cp
> --reflink is faster.
> 
> 
> I have to point out that the "--reflink" is only an internal 
> detail. The two file are logically separated: if you after the
> copy change the source, the destination is unaffected.
> 
Many thanks. Conversion of /home/bob to a subvolume completed
uneventfully. :-) And very quickly, considering it is ~500GB. I have
made a note of that --reflink option.

Bob
- -- 
Bob Williams
System:  Linux 3.11.10-17-desktop
Distro:  openSUSE 13.1 (x86_64) with KDE Development Platform: 4.13.2
Uptime:  06:00am up 6 days 20:14, 4 users, load average: 0.02, 0.18, 0.25
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlO35NAACgkQ0Sr7eZJrmU6YWgCgiriAUJF8Ee01ckev67fBTe6P
/WIAnjs2DnzqPU+nUFhCiyN4K212n893
=gSrD
-----END PGP SIGNATURE-----
