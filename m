Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob11.myregisteredsite.com ([209.17.115.49]:57362 "EHLO
	atl4mhob11.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758948AbaDKOLG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 10:11:06 -0400
Received: from mailpod1.hostingplatform.com (atl4obmail04pod1.mgt.hosting.qts.netsol.com [10.30.71.116])
	by atl4mhob11.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id s3BEB3dC002999
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Apr 2014 10:11:03 -0400
Message-ID: <5347F828.9090306@chinilu.com>
Date: Fri, 11 Apr 2014 07:11:52 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: How to make BTRFS crawl
References: <4171851.75rN5oGIof@zafu>
In-Reply-To: <4171851.75rN5oGIof@zafu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well, Akonadi brought my system to its knees long before I converted to 
btrfs, so somehow I am not surprised.  I have kept akonadi disabled ever 
since.for everything except a portion of Thunderbird and that ONLY with 
sql-lite. Mysql will kill it in no time.  So I am not sure that btrfs is 
the root of the problem here.  Just my two cents, perhaps others have 
different experience with akonadi.


On 04/11/2014 02:42 AM, Swâmi Petaramesh wrote:
> Hi,
>
> I was asked about situations "use cases" that would cause BTRFS to slow down
> to a crawl.
>
> And it's exactly what happened to me yesterday when I was trying, on the
> contrary, to speed it up.
>
> So here's the recipe for getting a "slow to the point it is unusable" BTRFS.
>
>
> 1/ Perform a clean, fresh install of a recent distro with a 3.13 kernel (i.e.
> Fedora 20) and a BTRFS root filesystem.
>
> 2/ Choose the version with a KDE interface
>
> 3/ Configure fstab mountpoints using such options (space_cache will have been
> manually activated once):
>
> / btrfs   subvol=FEDORA,noatime,compress=lzo,autodefrag
>
> /home btrfs   subvol=HOME,noatime,compress=lzo,autodefrag
>
>
> 4/ Use "chattr +C" to make the following directories NOCOW (move the old
> directory elsewhere, create a new dir, make it nocow, copy files from the old
> one so they are recreated with nocow, check permissions...):
>
> - /home/yourself/.cache
> - /home/yourself/.local/share/akonadi
>
> 5/ Use IMAP mail in Kmail. Seriously process your email (it will be stored
> using akonadi mysql)
>
> 6/ Surf normally the web using Firefox
>
> 7/ Install SuSE "snapper" package that will perform a FS snapshot every hour.
> Configure it so it will snapshot both the root FS subvol and the /home subvol
>
> 8/ Use the system for 24 hours and you will know that "hardly usable" means...
> Especially every hour-on-the-hour when Kmail or Firefox will try to access
> files that have been recently snapshotted... Your system will be dead with
> saturated HD access for several *minutes*
>
> ...Hope this may help hunting this down...
>
> Kind regards.
>

