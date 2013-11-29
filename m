Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:35951 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab3K2TJh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Nov 2013 14:09:37 -0500
Message-ID: <5298E66A.9050606@inwind.it>
Date: Fri, 29 Nov 2013 20:09:30 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] BTRFS-PROG: recursively subvolume snapshot and delete
References: <1384621747-25441-1-git-send-email-kreijack@inwind.it> <20131128183122.GL25312@twin.jikos.cz> <52979821.60401@gmail.com> <20131129180745.GQ25312@suse.cz>
In-Reply-To: <20131129180745.GQ25312@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-11-29 19:07, David Sterba wrote:
> On Thu, Nov 28, 2013 at 08:23:13PM +0100, Goffredo Baroncelli wrote:
>> Definetely you are right. In fact this is true also for other tools like
>> tar: they complaint if you remove/move/rename a file during the copy. We
>> can work to increase the robustness of the process, to avoid strange
>> behaviour when a subvolume is removed/moved/renamed.
>>
>> Anyway I am more afraid that we can't mix recursive and readonly snapshot.
> 
> Agreed, this would eg. need to toggle RO/RW status when needed, but this
> does not sound very clean.

IIRC the RO flags is mandatory for the send/receive; this basically
means that we wouldn't be able to use a recursive snapshot with
send/receive.

> 
>> Implementing the atomic recursive snapshot in the kernel, is out of my
>> possibility; anyway basically this means that the filesystem is frozen
>> until all the snapshot are done, which requires a finite time. In case
>> of a high number of subvolumes this could be a problem.
> 
> High number of subvolumes to snapshot atomically will always be
> problematic and a lazy userspace-based recursive snapshot might be
> actually better regarding the impact on the rest of the system, but
> without guaranteed atomicity.
> 
> But, I don't want to kill the whole idea just because there's some
> scenario that's possible but hard to handle.
> 
> david
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
