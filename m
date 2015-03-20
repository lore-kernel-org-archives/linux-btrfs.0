Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-04v.sys.comcast.net ([96.114.154.163]:35676 "EHLO
	resqmta-po-04v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132AbbCTBtd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 21:49:33 -0400
Message-ID: <550B7CAC.6030005@comcast.net>
Date: Thu, 19 Mar 2015 18:49:32 -0700
From: don fisher <hdf3@comcast.net>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: nube trying to backup my systems
References: <550B5C63.6010401@comcast.net> <CAJCQCtRj6MWc=YzvEepjiZTQYrN7CKbO0EivotZNjS218Gz56Q@mail.gmail.com>
In-Reply-To: <CAJCQCtRj6MWc=YzvEepjiZTQYrN7CKbO0EivotZNjS218Gz56Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> # btrfs sub list /
> ID 257 gen 1703 top level 5 path root
> ID 258 gen 1662 top level 5 path home
> ID 259 gen 1681 top level 5 path boot
> ID 262 gen 1629 top level 257 path var/lib/machines
>
> To mount machines, either
> subvol=root/var/lib/machines
> OR
> subvolid=262
>
> Why root/var/lib/machines? Because var/lib/machines is created inside
> subvol 257, a.k.a. root, therefore the path relative to the top level
> 5 subvolume is root/var/lib/machines. It might be easier to figure
> this out for a while to use -a switch.
>
> # btrfs sub list -a /mnt/btraid0/
> ID 257 gen 1705 top level 5 path <FS_TREE>/root
> ID 258 gen 1662 top level 5 path <FS_TREE>/home
> ID 259 gen 1681 top level 5 path <FS_TREE>/boot
> ID 262 gen 1705 top level 257 path root/var/lib/machines

The use of the IDs worked. I did not know where they came from, or if 
they would be repeatable across boots. So I assumed ID => UUID. My 
bad:-( My rot is mounted at /usr11. I tried:

UUID=26d63d99-92f4-4a49-878b-236f5e88af69 /usr11/srv btrfs 	 
subvol=usr11/srv 	0 0

but /usr11/srv did not mount. I replaced the number and it did mount. 
Would like to use string like you suggested since they are more 
understandable. Do you see what I did wrong? Any thoughts on stability 
of the IDs across boots?

Thanks,
Don
