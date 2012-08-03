Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39488 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab2HCXjZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2012 19:39:25 -0400
Received: by pbbrp8 with SMTP id rp8so2086786pbb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Aug 2012 16:39:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120803211317.GA10080@localhost.localdomain>
References: <1343949380-15398-1-git-send-email-ablock84@googlemail.com>
	<20120803211317.GA10080@localhost.localdomain>
Date: Sat, 4 Aug 2012 01:39:25 +0200
Message-ID: <CAB9VWqAU5THN7Lb9Y35pGBr1ewmtYmqsX6B-x7Lx3BiAUW4FgQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: remove mnt_want_write call in btrfs_mksubvol
From: Alexander Block <ablock84@googlemail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 3, 2012 at 11:13 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Thu, Aug 02, 2012 at 05:16:20PM -0600, Alexander Block wrote:
>> We got a recursive lock in mksubvol because the caller already held
>> a lock. I think we got into this due to a merge error. Commit a874a63
>> removed the mnt_want_write call from btrfs_mksubvol and added a
>> replacement call to mnt_want_write_file in btrfs_ioctl_snap_create_transid.
>> Commit e7848683 however tried to move all calls to mnt_want_write above
>> i_mutex. So somewhere while merging this, it got mixed up. The
>> solution is to remove the mnt_want_write call completely from
>> mksubvol.
>>
>> Reported-by: David Sterba <dave@jikos.cz>
>> Signed-off-by: Alexander Block <ablock84@googlemail.com>
>> ---
>>  fs/btrfs/ioctl.c |    5 -----
>>  1 file changed, 5 deletions(-)
>>
>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>> index 00ddf22..9df50fa 100644
>> --- a/fs/btrfs/ioctl.c
>> +++ b/fs/btrfs/ioctl.c
>> @@ -664,10 +664,6 @@ static noinline int btrfs_mksubvol(struct path *parent,
>>       struct dentry *dentry;
>>       int error;
>>
>> -     error = mnt_want_write(parent->mnt);
>> -     if (error)
>> -             return error;
>> -
>>       mutex_lock_nested(&dir->i_mutex, I_MUTEX_PARENT);
>>
>>       dentry = lookup_one_len(name, parent->dentry, namelen);
>> @@ -703,7 +699,6 @@ out_dput:
>>       dput(dentry);
>>  out_unlock:
>>       mutex_unlock(&dir->i_mutex);
>> -     mnt_drop_write(parent->mnt);
>>       return error;
>>  }
>>
>
> I'm confused, this isn't here in btrfs-next, so is this a problem still?
It's in linus current master. Lio Bo moved the call out of
btrfs_mksubvol into the caller. Later a commit from Jan Kara tried to
move the call inside mksubvol below i_mutex. If I understand the logs
correctly, It was then merged incorrectly.
> Thanks,
>
> Josef
