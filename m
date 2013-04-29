Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:63786 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab3D2RbP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Apr 2013 13:31:15 -0400
Message-ID: <517EAE61.8030207@giantdisaster.de>
Date: Mon, 29 Apr 2013 19:31:13 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/5] Btrfs: fill UUID tree initially
References: <cover.1366384796.git.sbehrens@giantdisaster.de> <4199ee363b2c956e7ebdfcc9733546f3e8b88bdd.1366384796.git.sbehrens@giantdisaster.de> <20130429151220.GS16427@twin.jikos.cz>
In-Reply-To: <20130429151220.GS16427@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 29 Apr 2013 17:12:20 +0200, David Sterba wrote:
> On Fri, Apr 19, 2013 at 05:41:06PM +0200, Stefan Behrens wrote:
[...]
>> +	up(&fs_info->uuid_scan_sem);
> 
> Does lockdep need to be instructed that a semaphore is released in a
> different thread it's been taken? Not sure if this wasn't for mutexes.

Not for semaphores.


I'm also working on handling the case that the filesystem is mounted
with an old kernel (what Josef and you have said in #btrfs).

Thanks for your review comments to the 4 patches, David! All of them
make sense and I will change it according to your comments.

