Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:63853 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933358Ab3JOSCt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 14:02:49 -0400
Received: by mail-bk0-f47.google.com with SMTP id mx12so3258437bkb.6
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2013 11:02:48 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20131015180017.GC14323@localhost.localdomain>
References: <1381859040-11211-1-git-send-email-fdmanana@gmail.com>
	<20131015180017.GC14323@localhost.localdomain>
Date: Tue, 15 Oct 2013 19:02:47 +0100
Message-ID: <CAL3q7H4GfCHX0hOuR6Som4N8KZqQ0p4Z0M9PTCw_8guSV=2r+g@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix incorrect inode acl reset
From: Filipe David Manana <fdmanana@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 15, 2013 at 7:00 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Tue, Oct 15, 2013 at 06:44:00PM +0100, Filipe David Borba Manana wrote:
>> When a directory has a default ACL and a subdirectory is created
>> under that directory, btrfs_init_acl() is called when the
>> subdirectory's inode is created to initialize the inode's ACL
>> (inherited from the parent directory) but it was clearing the ACL
>> from the inode after setting it if posix_acl_create() returned
>> success, instead of clearing it only if it returned an error.
>>
>> To reproduce this issue:
>>
>> $ mkfs.btrfs -f /dev/loop0
>> $ mount /dev/loop0 /mnt
>> $ mkdir /mnt/acl
>> $ setfacl -d --set u::rwx,g::rwx,o::- /mnt/acl
>> $ getfacl /mnt/acl
>> user::rwx
>> group::rwx
>> other::r-x
>> default:user::rwx
>> default:group::rwx
>> default:other::---
>>
>> $ mkdir /mnt/acl/dir1
>> $ getfacl /mnt/acl/dir1
>> user::rwx
>> group::rwx
>> other::---
>>
>> After unmounting and mounting again the filesystem, fgetacl returned the
>> expected ACL:
>>
>> $ umount /mnt/acl
>> $ mount /dev/loop0 /mnt
>> $ getfacl /mnt/acl/dir1
>> user::rwx
>> group::rwx
>> other::---
>> default:user::rwx
>> default:group::rwx
>> default:other::---
>>
>> Meaning that the underlying xattr was persisted.
>>
>
> Can you put this into an xfstest please?  Thanks,

A new one or just add it to an existing one (and which)?


>
> Josef



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
