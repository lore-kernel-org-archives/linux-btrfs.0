Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:60862 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaELSPH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 May 2014 14:15:07 -0400
Message-ID: <5371105C.5030306@inwind.it>
Date: Mon, 12 May 2014 20:18:04 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: dsterba@suse.cz,
        =?windows-1252?Q?Tom=E1=9A_Pru=9Eina?= <pruzinat@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: Fwd: [suggestion] Add verbose notification about inode-cache
 rebuild to kernel log
References: <CACHxQ2tAU15z_pUEGBuGqYFR9n_fH9BeyA8=jYryRrb3H=zCYA@mail.gmail.com> <CACHxQ2sQH96Z==zqEaoEoOxc65k9TYD66yLXQzOYL1kxaPcrqw@mail.gmail.com> <20140509145118.GD5988@twin.jikos.cz> <536D1AA6.7050407@libero.it> <20140512143946.GD6917@suse.cz>
In-Reply-To: <20140512143946.GD6917@suse.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On 05/12/2014 04:39 PM, David Sterba wrote:
>> Because most modern hardware is 64 bit (with the exception of ARM ?),
>> > could be make sense to allow btrfs to work without inode_cache only on
>> > 64bit, loosing the possibility to be used on 32 bit system.
>> > 
>> > Instead when the inode_cache is used, btrfs still be compatible with
>> > both 32bit and 64bit systems.
> There are 32bit machines in use and inode_cache brings some
> compatibility assurance. Just that I would not recommend it to use by
> default.
> 
>> > How often a filesystem is moved between a 64bit and 32bit systems ?
> Not so often I'd say, but for example the block device on a 32bit
> machine can be exported via iscsi to a 64bit machine temporarily, then
> the changes made on the 64bit host can make it unusable.


To be clear, I would like to avoid inode_cache on 64bit machine.

In order to avoid the risk to exhaust the inode on 32bit and to be backward compatible with what already exists, we could add a flag to mkfs.btrfs to be only 64bit compatible and avoid inode_cache.

It it would be faster, I am sure that there are uses cases for that.

The major drawback that I see, is that it would be a code path less tested: I think that the 32bit system[*] would disappear soon

Finally I have a question: it is possible to disable inode_cache ? what means the flag "noinode_cache" ? It means disable the inode cache at all, or only avoid to store on disk the inode cache ?


[*] I means 32bit system were it is reasonable that btrfs would run.

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
