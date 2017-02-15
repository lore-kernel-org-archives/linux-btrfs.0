Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34.italiaonline.it ([212.48.25.162]:49200 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752141AbdBOSeK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 13:34:10 -0500
From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: stat(2) returning device ID not existing in mountinfo
Reply-To: kreijack@inwind.it
References: <1474057691.16275.16.camel@xiaoka.com>
 <d5df5a17-fb7f-80a2-9308-66fe0e5335f3@suse.com>
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
Cc: Tomasz Sterna <tomek@xiaoka.com>,
        Bernhard Voelker <mail@bernhard-voelker.de>, findutils-patches@gnu.org
Message-ID: <925b4337-2de3-32fc-624f-ed67dd0eb8f2@libero.it>
Date: Wed, 15 Feb 2017 19:25:57 +0100
MIME-Version: 1.0
In-Reply-To: <d5df5a17-fb7f-80a2-9308-66fe0e5335f3@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(Resended because I don saw it in the mailing lists)

-----
Hi,

I want to highlight this bug another time.

I encountered this bug, when I was looking to a problem with find. I my machine find took an huge quantity of memory (up to 3GB) when used by updatedb.

	http://lists.gnu.org/archive/html/findutils-patches/2016-12/msg00000.html

The root of the problem was a leak memory in find. What was strange however is that the findutils developers weren't unable to reproduce this bug. They find the leak, but not a so high memory usage.

After some email, it was discovered that find (when used in updatedb) checks if the filesystem is changed during the tree walking. They checked the device-id returned by stat against the one returned by mountinfo.

For btrfs these differ, and the check is repeat each time. Because the memory leak was per "filesystem check", using find on a btrfs filesystem caused a huge leak.

I hope that some btrfs developer could address this, because I suspect that a lot of tools compare the device id returned by /proc/self/mountinfo against the one returned by stat(2).


BR
G.Baroncelli




On 2016-09-20 15:15, Jeff Mahoney wrote:
> On 9/16/16 4:28 PM, Tomasz Sterna wrote:
>> Hi.
>>
>> I have spotted an issue with stat(2) call on files on btrfs.
>> It is giving me dev_t st_dev number that does not correspond to any
>> mounted filesystem in proc's mountinfo.
> 
> That's by design.  Your particular file system may only use one device
> but, internally, btrfs uses virtualized storage that may be spread
> across multiple devices.  To make things more complicated, snapshots
> mean that:
> 
> sled1a:/mnt # btrfs sub list .
> ID 257 gen 14 top level 5 path a
> ID 258 gen 14 top level 5 path b
> 
> sled1a:/mnt # ls -laRi
> .:
> total 16
> 256 drwxr-xr-x 1 root root   4 Sep 20 09:08 .
> 256 drwxr-xr-x 1 root root 220 Sep 16 09:49 ..
> 256 drwxr-xr-x 1 root root   8 Sep 14 10:24 a
> 256 drwxr-xr-x 1 root root   8 Sep 14 10:24 b
> 
> ./a:
> total 4112
> 256 drwxr-xr-x 1 root root       8 Sep 14 10:24 .
> 256 drwxr-xr-x 1 root root       4 Sep 20 09:08 ..
> 257 -rw-r--r-- 1 root root 4194304 Sep 14 10:24 file
> 
> ./b:
> total 4112
> 256 drwxr-xr-x 1 root root       8 Sep 14 10:24 .
> 256 drwxr-xr-x 1 root root       4 Sep 20 09:08 ..
> 257 -rw-r--r-- 1 root root 4194304 Sep 14 10:24 file
> 
> Under normal circumstances those are two files with the same st_dev and
> the same inode number.  That would normally correspond to a hard link,
> but the files do not (necessarily) correspond to the same file.
> 
> ... but because we use anonymous device numbers for each subvolume, we
> have different device numbers for each one.
> 
> sled1a:/mnt # stat --format "%n st_dev=%d" {a,b}/file
> a/file st_dev=69
> b/file st_dev=70
> 
> It's a pretty big usability wart that we don't consistently report the
> device number.  We do it correctly in stat() but there are other places
> in the code that assume that inode->i_sb->s_dev will work.  In the SUSE
> kernels, we have patches that add a super_operation to report the
> correct device number everywhere, but even that is a hack.
> 
>> I already attempted a illinformed-patch in fs/btrfs/super.c:
>>
>> @@ -1127,6 +1127,7 @@ static int btrfs_fill_super(struct super_block *sb,
>>  		goto fail_close;
>>  	}
>>  
>> +	sb->s_dev = inode->i_sb->s_dev;
>>  	sb->s_root = d_make_root(inode);
>>  	if (!sb->s_root) {
>>  		err = -ENOMEM;
>>
>> but it didn't help.
> 
> It wouldn't.  That is assigning a variable to itself.
> 
>> I would like to dig deeper and fix it, but first I have to ask:
>> - Which number is wrong?
>>   The one returned by stat() or the one in mountinfo?
> 
> The one in mountinfo, but then that means that the user only sees the
> anonymous devices in mount(8), which isn't what we want either.
> 
> I'm afraid the correct fix is very involved and requires non-trivial
> changes in the VFS layer as well.  It's on my long-term TODO list.  I
> currently have some patches that do the magic with vfsmounts but it's
> far from being usable.
> 
> -Jeff
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
