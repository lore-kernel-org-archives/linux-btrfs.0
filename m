Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:40590 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964781AbcBPQI4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 11:08:56 -0500
Subject: Re: BZ#101951, Overlayfs on top of btrfs causes kernel oops + freeze
To: fdmanana@gmail.com
References: <56C3428D.1010000@canonical.com>
 <CAL3q7H7XVLTHrv+tdNiF4W=VZGNQ9S3dNNdh1wvHkPjYZ0QhkQ@mail.gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <56C34996.3050802@canonical.com>
Date: Tue, 16 Feb 2016 16:08:54 +0000
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7XVLTHrv+tdNiF4W=VZGNQ9S3dNNdh1wvHkPjYZ0QhkQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16/02/16 15:51, Filipe Manana wrote:
> On Tue, Feb 16, 2016 at 3:38 PM, Colin Ian King
> <colin.king@canonical.com> wrote:
>> Hi there,
>>
>> bug: https://bugzilla.kernel.org/show_bug.cgi?id=101951 and also
>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1532145
>>
>> Commit 4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01 ("overlayfs: Make f_path
>> always point to the overlay and f_inode to the underlay") resulted in an
>> issue when using a combination of btrfs and overlayfs.  This is
>> noticeable when doing a fsync() on a file in a chroot with overlayfs on
>> top of btrfs; we hit a kernel oops in btrfs_sync_file() on
>> atomic_inc(&root->log_batch) because root is NULL.
>>
>> I've debugged this further and found that in btrfs_sync_file():
>>
>>         struct inode *inode = d_inode(dentry);
>>
>> does not return the inode I expected when using the stacked overlay fs,
>> where as:
>>
>>         struct inode *inode = file_inode(file);
>>
>> does.
> 
> See the discussion at
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg48131.html
> 
> You can get along with file_inode() in btrfs_sync_file(), but not
> later the fsync code path where we traverse the hierarchy up using
> dentries.
> More details on that thread.

Ah, good. So was there any resolution on a way forward for a fix?

> 
>>
>> However, I'm not well at all well versed in btrfs, so I am not confident
>> this is a actually correct.  Any comments?
>>
>> Colin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

