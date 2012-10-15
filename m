Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42642 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754680Ab2JOU2V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 16:28:21 -0400
Received: by mail-wi0-f172.google.com with SMTP id hq12so2607001wib.1
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2012 13:28:20 -0700 (PDT)
MIME-Version: 1.0
Reply-To: dakinsh00@staff.nctschools.org
In-Reply-To: <20121015201717.GR25498@carfax.org.uk>
References: <CAAuL=cqf2yU0ofXpZc-N1y9FtL2h7OmRU8S03hyzs=MsyFFj7w@mail.gmail.com>
 <20121015201717.GR25498@carfax.org.uk>
From: Shawn Dakin <dakinsh00@staff.nctschools.org>
Date: Mon, 15 Oct 2012 16:27:59 -0400
Message-ID: <CAAuL=cogLsjmGcW5BiPx14P_tjzQCxXfeKXvP4jnQA6DkvfP4w@mail.gmail.com>
Subject: Re: Can not Mount btrfs No Space left
To: Hugo Mills <hugo@carfax.org.uk>,
        Shawn Dakin <dakinsh00@staff.nctschools.org>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo,
Thanks, I had not thought of that.
It does mount fine ro so I can access the files.
Any ideas on getting access to delete a few log files or snapshots so
I can mount the volume rw?
If not I will just copy it off onto another, but that will be time consuming.


On Mon, Oct 15, 2012 at 4:17 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Oct 15, 2012 at 03:52:15PM -0400, Shawn Dakin wrote:
>> I have a btrfs volume that will not mount due to "No space on device"
>> I would gladly free up some space if I could only mount the volume.
>> Does anyone have a trick to getting this volume back up and running?
>> Any help would be great!!
>
>    Start with a 3.6 kernel (which has lots of ENOSPC fixes in it). Try
> mounting with -o ro, which won't allow you to modify anything but may
> show you if the FS is at least mountable in that state (and will give
> you the capability to copy the data elsewhere in extremis). If you're
> lucky, that mount may then allow you to mount it again without the -o
> ro.
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>        --- Great oxymorons of the world, no. 6: Mature Student ---



-- 
Shawn Dakin (CNE)
Director of Technology
Newcomerstown Schools

659 S. Beaver St.
Newcomerstown Oh, 43832
Office 740-498-4999
Cell 740-227-0339
