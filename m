Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:23147 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569Ab2GCTRW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2012 15:17:22 -0400
Message-ID: <4FF3453F.5090404@petaramesh.org>
Date: Tue, 03 Jul 2012 21:17:19 +0200
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS fsck apparent errors
References: <4FF30B55.6060205@petaramesh.org> <20120703152208.GA28701@carfax.org.uk>
In-Reply-To: <20120703152208.GA28701@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 03/07/2012 17:22, Hugo Mills a écrit :
> What you're seeing is the fact that you've still got the complete ext4
> filesystem and all of its data sitting untouched on the disk as well.
> The defrag will have taken a complete new copy of the data but not
> removed the ext4 copy. 
I though about that... However, I had "btrfs su del" the ext2_saved
subvolume, so it is expected to have been deleted...

If not, how could I possibly delete it, now that I can't see it anymore ?


>> It doesn't seem that btrfsck attempts to fix these errors in any
>> way... It just displays them.


>    Correct, by default it just checks the filesystem. Just to be sure:
> the filesystems in question weren't mounted, were they?
>
>  
No, the filesystems weren't mounted... If by default, btrfsck doesn't
fix, how could I ask it to fix ? "man btrfsck" or "btrfsck -h" do not
show any option, only a device name...

TIA.

Kind regards.

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

