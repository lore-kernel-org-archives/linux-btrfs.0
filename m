Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from upton.red.cert.org ([192.88.209.60]:34179 "EHLO
	upton.red.cert.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3LQP6V (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 10:58:21 -0500
From: Michael Welsh Duggan <mwd@cert.org>
To: dsterba@suse.cz
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        miaox@cn.fujitsu.com
Subject: Re: [PATCH] Btrfs-progs: receive: fix the case that we can not find subvolume
References: <1387271629-11315-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<20131217150919.GP6498@twin.jikos.cz>
Date: Tue, 17 Dec 2013 10:40:41 -0500
In-Reply-To: <20131217150919.GP6498@twin.jikos.cz> (David Sterba's message of
	"Tue, 17 Dec 2013 16:09:19 +0100")
Message-ID: <tntbo0fcwp2.fsf@watermonitor.yellow.cert.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba <dsterba@suse.cz> writes:

> On Tue, Dec 17, 2013 at 05:13:49PM +0800, Wang Shilong wrote:
>> If we change our default subvolume, btrfs receive will fail to find
>> subvolume. To fix this problem, i have two ideas.
>> 
>> 1.make btrfs snapshot ioctl support passing source subvolume's objectid
>
>> 2.when we want to using interval subvolume path, we mount it other place
>> that use subvolume 5 as its default subvolume.
>
> 3. Tell the user to mount the toplevel subvol by himself and run receive
>    again

Ugh.  I hope that would be considered a short-term hack waiting for a
better solution, perhaps requiring a kernel upgrade.  From a user's
perspective there is no reason this should be necessary, and requiring
this would be extraordinarily surprising.  "Why is btrfs unable to find
my snapshot?  It's right there!"  Moreover, this used to work just fine
in previous versions of btrfs-progs.

>> We'd better use the second approach because it won't bother kernel change.
>
> I don't think that the silent mount is the right way to fix it, that way
> the btrfs tool tooks responsibility not to break anything.  Like the
> unhandled umount failure below. I think admins and power users do not
> like to see some random tool mess with the system like this.
>
>> @@ -199,6 +200,10 @@ static int process_snapshot(const char *path,
>> const u8 *uuid, u64 ctransid,
>>  	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
>>  	struct btrfs_ioctl_vol_args_v2 args_v2;
>>  	struct subvol_info *parent_subvol = NULL;
>> +	char *dev = NULL;
>> +	char tmp_name[15] = "btrfs-XXXXXX";
>> +	char tmp_dir[30] = "/tmp";
>
> Mounting valuable data under /tmp is dangerous, what if some /tmp
> cleaner starts to remove old files. I've seen that happen in practice.

Agreed.  If you _were_ to continue to implement it like this, you should
include code to respect the TMPDIR envvar at the very least.

-- 
Michael Welsh Duggan
(mwd@cert.org)
