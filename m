Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i2.italiaonline.it ([212.48.25.194]:46686 "EHLO
	smtp-16.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752005AbaLISRs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 13:17:48 -0500
Message-ID: <54873D14.8000208@inwind.it>
Date: Tue, 09 Dec 2014 19:19:00 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: dsterba@suse.cz
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] Avoid to consider lvm snapshots when scanning devices.
References: <1417718382-6753-1-git-send-email-kreijack@inwind.it> <1417718382-6753-2-git-send-email-kreijack@inwind.it> <548506A3.3010409@cn.fujitsu.com> <5485BC81.5000906@gmail.com> <20141209102728.GA20595@twin.jikos.cz>
In-Reply-To: <20141209102728.GA20595@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/09/2014 11:27 AM, David Sterba wrote:
>> > Today the lvm-snapshot and btrfs behave very poor: it is not
>> > predictable which device is pick (the original or the snapshot). 
>> > These patch *avoid* most problems skipping the snapshots, which
>> > to me seems a reasonable default.
>> > For the other case the user is still able to mount any disks
>> > [combination] passing them directly via command line (
>> > mount /dev/sdX -o device=/dev/sdY,device=/dev/sdz...  );

> Beware that passing 'device' does not mean that btrfs will use that
> device to assemble the filesystem. It only says to scan the device the
> same way any preceding 'btrfs dev scan' would do.

I thought a bit about your sentence, but I was unable to understand
the difference. Could you describe a case where it is different ?

I have quite clear that "btrfs scan <dev>" and "mount -o device=<dev>"
do the same thing: these fill a table with the devices information 
grouped by fsid. Then the kernel uses this table as hint to pick 
the devices for a filesystem. So except some strange case 
(like device "hot" removed) this shouldn't make any difference... 
Or not ?

The point is that when a btrfs scan is ran asynchronously,
a snapshot "may" hide the origin volume. Where the word
"may" means that it is not predictable. Passing the device solve only
this point: it becomes predictable which device is used.


 
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
