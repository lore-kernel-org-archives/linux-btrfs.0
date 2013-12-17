Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40956 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab3LQP1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 10:27:45 -0500
Received: by mail-pa0-f46.google.com with SMTP id kl14so4551598pab.5
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 07:27:45 -0800 (PST)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs-progs: receive: fix the case that we can not find subvolume
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20131217150919.GP6498@twin.jikos.cz>
Date: Tue, 17 Dec 2013 23:27:40 +0800
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        miaox@cn.fujitsu.com, mwd@md5i.com
Message-Id: <724F048F-D53A-40E0-882E-FD9D8C909E40@gmail.com>
References: <1387271629-11315-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20131217150919.GP6498@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi dave,

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
>   again

If we really don't want to bother kernel change, i think we can add a option for btrfs receive(for example -f)
to force tool to resolve such ENOENT and at the same time, we output something like:

fprintf(stderr, "Default subvolume is changed,¡­¡­¡­.")

if -f is not assigned, we will fail here.

> 
>> We'd better use the second approach because it won't bother kernel change.
> 
> I don't think that the silent mount is the right way to fix it, that way
> the btrfs tool tooks responsibility not to break anything.  Like the
> unhandled umount failure below. I think admins and power users do not
> like to see some random tool mess with the system like this.

> 
>> @@ -199,6 +200,10 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
>> 	char uuid_str[BTRFS_UUID_UNPARSED_SIZE];
>> 	struct btrfs_ioctl_vol_args_v2 args_v2;
>> 	struct subvol_info *parent_subvol = NULL;
>> +	char *dev = NULL;
>> +	char tmp_name[15] = "btrfs-XXXXXX";
>> +	char tmp_dir[30] = "/tmp";
> 
> Mounting valuable data under /tmp is dangerous, what if some /tmp
> cleaner starts to remove old files. I've seen that happen in practice.

Agree with  this.

> 
>> @@ -269,10 +308,14 @@ static int process_snapshot(const char *path, const u8 *uuid, u64 ctransid,
>> 		fprintf(stderr, "ERROR: creating snapshot %s -> %s "
>> 				"failed. %s\n", parent_subvol->path,
>> 				path, strerror(-ret));
>> -		goto out;
>> 	}
>> 
>> +out_umount:
>> +	umount(tmp_dir);
> 
> umount fails for whatever reason,

will fix it.

> 
>> +	rmdir(tmp_dir);
> 
> at least this does not delete the files recursively.

Why we need delete the files recursively here,
I only create dir ,something like /tmp/btrfs-XXXXX, and i only want to delete the temp dir
btrfs-XXXX here¡­

Thanks,
Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

