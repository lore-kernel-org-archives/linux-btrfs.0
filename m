Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:33771 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbcCAQmg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Mar 2016 11:42:36 -0500
Received: by mail-qg0-f43.google.com with SMTP id d32so90365123qgd.0
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Mar 2016 08:42:36 -0800 (PST)
Subject: Re: [RFC] Experimental btrfs encryption
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
Cc: clm@fb.com, dsterba@suse.cz
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56D5C64F.3000800@gmail.com>
Date: Tue, 1 Mar 2016 11:41:51 -0500
MIME-Version: 1.0
In-Reply-To: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-01 11:08, Anand Jain wrote:
> This patchset adds btrfs encryption support.
While I think this is a great feature to have, I personally think we're 
better off waiting for the ext4/F2FS encryption API's to get pushed up 
to the VFS layer in mainline, and then use those for the user facing API 
(or at least support them).  That said, general comments below.
>
> Warning:
> The code is in prototype/experimental stage and is not suitable
> for the production data yet.
>
> Example usage:
> Create an encrypted subvolume:
>    btrfs subvol create -e /btrfs/sv1
>    Paraphrase: <-
Is there any way to do encryption per file instead of per-subvolume? 
This is a useful feature for a lot of people, and would provide better 
consistency with how most other filesystem-level encryption designs 
work.  That said, I do like the possibility of per-subvolume encryption, 
as it allows for things like per-user encrypted home directories without 
needing some extra layer like ecryptfs.
>
> Review encryption status
>    btrfs subvol show /btrfs/sv1
>    btrfs/sv1
>      Name: sv1
>      UID: d8bf1718-56a7-da40-86d9-b8e87315f63f
>      Parent UUID: -
>      Received UUID: -
>      Creation time: 2016-03-01 17:11:58 +0800
>      Subvolume ID: 257
>      Generation: 13
>      Gen at creation:7
>      Parent ID: 5
>      Top level ID: 5
>      Flags: -
>      Encryption: aes@btrfs:d8bf1718 (188612608)
>                     ^ ^^^^^^^^^^^^^^ ^^^^^^^^^
>                     |        |               |
>                  Algorithm Key-Tag Key-serial-number
>
>    keyctl show
>    ::
>    188612608 --alswrv 0 0 \_ user: btrfs:d8bf1718
>
> Logout/revoke:
>    btrfs subvol encrypt -k out /btrfs/sv1
>    btrfs subvol show /btrfs/sv1 | egrep Encrypt
>    Encryption: aes@btrfs:d8bf1718 (Required key not available)
>
> sign in:
>    btrfs subvol encrypt -k in /btrfs/sv1
>
> Known issues / limitation / for future expansion:
> - Need to set FS incompatible feature.
>
> - No password verification yet.
These two are absolutely essential from a data safety POV.
>
> - Move of files across subvolume is not supported when both
>    or either one has encryption set.
>
> - No way to change the password.
>
> - Does not drop the cached pages when key is revoked.
This is essential from a security POV.
>
> - Need to get password twice from the user.
>
> - No user permeable subvol info ioctl.
>
> - Provide a method to pass key using the mount option.
>
> - Provide a method to read the key from the file.
>
> - Current encryption method is symmetric (same key for both
>    encryption and decryption), however we could easily expand
>    this to other potentially useful methods like asymmetric
>    (private/public) encryption.
>
> - As of now uses "user" keytype, I am still considering/
>    evaluating other key type such as logon.
>
> - Evaluate other encryption algorithms,  as of now it is
>    using "cts(cbc(aes)".
While this would be nice (I would love to see full CryptoAPI support), 
it probably shouldn't be considered a deal breaker for merging this or 
declaring it production ready.
>
> - Uses btrfs compression framework, so compression and then
>    encryption is not possible. However yet evaluate if there
>    are encryption algorithm which can compress as well.
The utility of this is debatable.  Most other filesystems that support 
both compression and encryption support only one or the other for a 
given file, encrypting compressed data is overall less secure than 
encrypting the data itself, and trying to compress encrypted data 
usually just wastes CPU time.
