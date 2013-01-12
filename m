Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:45109
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753891Ab3ALRy0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Jan 2013 12:54:26 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: obscure out of space, df and fi df are way off
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAE5mzvgnEq6qFyJfujPLzG5wFRToYFWwFa-HpsCaotkz+kN5Zw@mail.gmail.com>
Date: Sat, 12 Jan 2013 10:54:23 -0700
Cc: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Message-Id: <5DA0AF7F-49B0-4FBC-9CFC-E47DEF6FB9CE@colorremedies.com>
References: <A2AC222E-2F40-4B0A-BFA7-C9D2D3A5B193@colorremedies.com> <CAE5mzvjGwnrYJUQJ97xuCm__hAE18cfLx8r5_NutFkA6dzONcQ@mail.gmail.com> <E3B2C3E3-7A06-4C19-AA66-5AFC3FC7D2C3@colorremedies.com> <CAE5mzvgnEq6qFyJfujPLzG5wFRToYFWwFa-HpsCaotkz+kN5Zw@mail.gmail.com>
To: cwillu <cwillu@cwillu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 12, 2013, at 12:48 AM, cwillu <cwillu@cwillu.com> wrote:
>>>> [root@localhost tmp]# btrfs fi df /mnt/sysimage
>>>> Data: total=2.69GB, used=2.69GB
>>>> System, DUP: total=8.00MB, used=4.00KB
>>>> System: total=4.00MB, used=0.00
>>>> Metadata, DUP: total=438.94MB, used=183.36MB
>>>> Metadata: total=8.00MB, used=0.00
> 
>> So if I assume 2.7GiB for data, and add up the left side of fi df I get 3224MB rounded up, which is neither 3.57GB or 3.57GiB. I'm missing 346MB at least. That is what I should have said from the outset.
> 
> 2.69 + (438.94 / 1000 *2) + (8.0 / 1000 / 1000 *2) + (4.0 / 1000 /
> 1000) + (8.0 / 1000 / 1000 *2)
> 3.567916
> 
> Looks like 3.57GB to me :p
> 
>> So is the Metadta DUP Total 438.94MB allocated value actually twice that, but only 438.94MB is displayed because that's what's available (since the metadata is duplicated)?
> 
> The capacity of the metadata group is 438.94; the actual size on disk
> is twice that.

OK, got it. 

However, this is a significant linguistic problem to use the presence of a qualifier on the words total and used in such a very non-obvious manner, to your point that it's obscure and a known sore spot. It constitutes a secret decoder ring. Look at it this way.

Case 1:
Metadata, DUP: total=438.94MB, used=183.36MB
Case 2:
Metadata: total=438.94MB, used=183.36MB

The df command means "file system disk space usage".  It doesn't mean "capacity of blah group". The capacity of the metadata group is a matter of trivia. I think in a df command, the numeric values need to be true to the command. And to do that, the values in case 1 should be twice that of the values in case 2.

But this isn't just a sore spot here, this is a concern in the broader conversation of how to show used and free space on Btrfs in general, in particular as it gets raid5/6, and eventually per subvolume (and per file?) data profiles.

There is a long history of showing literal file sizes, rather than their resource allocation. I think that's the problem.

ls -l will show me a 500000000 byte sparse file of zeros as being 500000000 bytes. That's true, but I'll argue pretty much all users of computers, most of the time, want to know the resource allocation of the file. That sparse file has a very different resource allocation than 477MiB.

Likewise a non-zero file of the same size, compressed vs not-compressed? It's 477MiB of data in either case, if that's what's meant by "file size" but clearly the resource allocation "file size" is different, compressed or not compressed.

If the file's data profile is raid0, raid1, raid5, or raid6, those are four different amounts of resource consumption by the same file. Yet ls -lh will show me 477 MiB in any case. ls -ls tries to do better in the compression case, but it fails in the raid case.

OK, I've diverted. Thank you for the explanation.


> I tend to go with "any filesystem smaller than 32GB", but a more
> accurate rule is probably along the lines of "any filesystem that you
> expect to normally run within half a gb of full".

Both are good rules of thumb. Thanks.

Chris Murphy

