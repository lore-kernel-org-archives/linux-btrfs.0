Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16749 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755286AbcCBBo6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 20:44:58 -0500
Subject: Re: [RFC] Experimental btrfs encryption
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
 <56D5C64F.3000800@gmail.com>
CC: <clm@fb.com>, <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56D64590.1090108@cn.fujitsu.com>
Date: Wed, 2 Mar 2016 09:44:48 +0800
MIME-Version: 1.0
In-Reply-To: <56D5C64F.3000800@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Austin S. Hemmelgarn wrote on 2016/03/01 11:41 -0500:
> On 2016-03-01 11:08, Anand Jain wrote:
>> This patchset adds btrfs encryption support.
> While I think this is a great feature to have, I personally think we're
> better off waiting for the ext4/F2FS encryption API's to get pushed up
> to the VFS layer in mainline, and then use those for the user facing API
> (or at least support them).  That said, general comments below.
>>
>> Warning:
>> The code is in prototype/experimental stage and is not suitable
>> for the production data yet.
>>
>> Example usage:
>> Create an encrypted subvolume:
>>    btrfs subvol create -e /btrfs/sv1
>>    Paraphrase: <-
> Is there any way to do encryption per file instead of per-subvolume?
> This is a useful feature for a lot of people, and would provide better
> consistency with how most other filesystem-level encryption designs
> work.  That said, I do like the possibility of per-subvolume encryption,
> as it allows for things like per-user encrypted home directories without
> needing some extra layer like ecryptfs.
>>
>> Review encryption status
>>    btrfs subvol show /btrfs/sv1
>>    btrfs/sv1
>>      Name: sv1
>>      UID: d8bf1718-56a7-da40-86d9-b8e87315f63f
>>      Parent UUID: -
>>      Received UUID: -
>>      Creation time: 2016-03-01 17:11:58 +0800
>>      Subvolume ID: 257
>>      Generation: 13
>>      Gen at creation:7
>>      Parent ID: 5
>>      Top level ID: 5
>>      Flags: -
>>      Encryption: aes@btrfs:d8bf1718 (188612608)
>>                     ^ ^^^^^^^^^^^^^^ ^^^^^^^^^
>>                     |        |               |
>>                  Algorithm Key-Tag Key-serial-number
>>
>>    keyctl show
>>    ::
>>    188612608 --alswrv 0 0 \_ user: btrfs:d8bf1718
>>
>> Logout/revoke:
>>    btrfs subvol encrypt -k out /btrfs/sv1
>>    btrfs subvol show /btrfs/sv1 | egrep Encrypt
>>    Encryption: aes@btrfs:d8bf1718 (Required key not available)
>>
>> sign in:
>>    btrfs subvol encrypt -k in /btrfs/sv1
>>
>> Known issues / limitation / for future expansion:
>> - Need to set FS incompatible feature.
>>
>> - No password verification yet.
> These two are absolutely essential from a data safety POV.
>>
>> - Move of files across subvolume is not supported when both
>>    or either one has encryption set.
>>
>> - No way to change the password.
>>
>> - Does not drop the cached pages when key is revoked.
> This is essential from a security POV.
>>
>> - Need to get password twice from the user.
>>
>> - No user permeable subvol info ioctl.
>>
>> - Provide a method to pass key using the mount option.
>>
>> - Provide a method to read the key from the file.
>>
>> - Current encryption method is symmetric (same key for both
>>    encryption and decryption), however we could easily expand
>>    this to other potentially useful methods like asymmetric
>>    (private/public) encryption.
>>
>> - As of now uses "user" keytype, I am still considering/
>>    evaluating other key type such as logon.
>>
>> - Evaluate other encryption algorithms,  as of now it is
>>    using "cts(cbc(aes)".
> While this would be nice (I would love to see full CryptoAPI support),
> it probably shouldn't be considered a deal breaker for merging this or
> declaring it production ready.
>>
>> - Uses btrfs compression framework, so compression and then
>>    encryption is not possible. However yet evaluate if there
>>    are encryption algorithm which can compress as well.
> The utility of this is debatable.  Most other filesystems that support
> both compression and encryption support only one or the other for a
> given file, encrypting compressed data is overall less secure than
> encrypting the data itself, and trying to compress encrypted data
> usually just wastes CPU time.

+1 here, but in fact, it's easy to deal with.
As long as not implement encryption as a compression method.

Just like inband dedup, we use the following method to support dedup and 
compression while still using most of CPU cores like compression:

Old compression only implement:
inode needs compress will go into async_cow_start()
async_cow_start()
   |- compress_file_range()

Compression with dedup implement:
inode needs compress *OR* dedup will go into async_cow_start()
async_cow_start()
   |
   |- if (!inode_need_dedup())
   |  |- compress_file_range()  <<Just as normal one
   |     |- btrfs_compress_pages()
   |     |- add_async_extent()
   |
   |- else
      |- hash_file_range()      <<Calculate file hashes
         |- normal dedup hash
         |- if (inode_need_compress())
         |  |- btrfs_compress_pages()
         |- add_async_extent()

Although not the most elegant method, but it shows that we can 
co-operate compress and encrypt.


However the most elegant method, is to rework current cow_file_range() 
and its variant, to an unified btrfs internal API.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


