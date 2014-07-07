Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:53730 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbaGGRdP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jul 2014 13:33:15 -0400
Message-ID: <53BADAF1.80803@inwind.it>
Date: Mon, 07 Jul 2014 19:37:53 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Revert "btrfs: allow mounting btrfs subvolumes with
 different ro/rw options"
References: <1404207001-7510-1-git-send-email-quwenruo@cn.fujitsu.com> <53B445F5.6060709@libero.it> <53B4A3C7.1020805@cn.fujitsu.com> <53B594E7.9070500@inwind.it> <53B6032D.6090207@cn.fujitsu.com> <53B6E744.1060204@inwind.it> <53B9FBE4.6040300@cn.fujitsu.com>
In-Reply-To: <53B9FBE4.6040300@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/07/2014 03:46 AM, Qu Wenruo wrote:
> 
[... cut ...]
>> 
>> So to me it seems reasonable to have different rw/ro status between
>> btrfs root and btrfs subvolume. As use case think a system which
>> hosts several guests in container. Each guest has its own subvolume
>> as root filesystem. An user would mount the btrfs root RO in order
>> to see all the subvolume but at the same time he avoids to change a
>> file for error; when a guest has to be started, its root
>> filesystem/subvolume can be mounted RW.
> You caught me. Yes, the use case seems quite resonable since
> currently you need to mount btrfs to get the subvolume list (the only
> offline method seems btrfs-debug-tree but end-users won't use it
> anyway) and it's a good admin behavior to mount it ro if no need to
> write.
>> 
>> On the other side, I understand that this could lead to an
>> unexpected behaviour because with the other filesystem it is
>> impossible to mount only a part as RW. In this BTRFS would be
>> different.
>> 
>> Following the "least surprise" principle, I prefer that the *mount*
>> RO/RW flag acts globally: the filesystem has only one status. It is
>> possible to change it only globally.
>> 
>> In order to having a subvolumes with different RO/RW status we
>> should rely on different flag. I have to point out that the
>> subvolume has already the concept of read-only status.
>> 
>> We could adopt the following rules: 

>> - if the filesystem is mounted RO then all the subvolumes (event 
>> the id=5) are RO 


>>- if a subvolume is marked RO, the it is RO 
>> - otherwise a subvolume is RW

> I'm confused with rule 1. When mentionting 'mounted RO', you mean
> mount subvolume id=5 RO? Also you mentioned that using differnt RO/RW
> flag independent from VFS RO/RW flags, so it also makes me confused
> that when mentioning RO, did you mean VFS RO or new btrfs RO/RW
> flags?


For "mounted RO" I mean the VFS flag, the "one" passed via the mount 
command. I say "one" as 1, because I am convinced that it has to act globally, 
e.g. on the whole filesystem; the flag should be set at the first mount,
then it can be changed (only ?) issuing a "mount -o remount,rw/ro"

For example, the following commands

  # mount -o subvol=subvolname,ro /dev/sda1 /mnt/btrfs-subvol
  # mount -o subvolid=5 /dev/sda1 /mnt/btrfs-root

cause the following ones

  # touch /mnt/btrfs-subvol/touch-a-file
  # touch /mnt/btrfs-root/touch-a-file2

to fail; and the following commands

  # mount -o subvol=subvolname,ro /dev/sda1 /mnt/btrfs-subvol
  # mount -o subvolid=5 /dev/sda1 /mnt/btrfs-root
  # mount -o remount,rw /mnt/btrfs-subvol

cause the following ones 

  # touch /mnt/btrfs-subvol/touch-a-file
  # touch /mnt/btrfs-root/touch-a-file2

to succeed

So for each filesystem, there is a "globally" flag ro/rw which acts on the 
whole filesystem. Clear and simple.

Step 2: a more fine grained control of the subvolumes.
We have already the capability to make a subvolume read-only/read-write doing

   # btrfs property set -t s /path/to/subvolume ro true

or 

   # btrfs property set -t s /path/to/subvolume ro false

My idea is to use this flag. It could be done at the mount time for example:

  # mount -o subvolmode=ro,subvol=subvolname /dev/sda1 /

(this example doesn't work, it is only a my idea)

So:
- we should not add further code
- the semantic is simple
- the property is linked to the subvolume in a understandable way

We should only add the subvolmode=ro option to the mount command.

Further discussion need to investigate the following cases:
- if the filesystem is mounted as ro (mount -o ro....), does mounting a subvolume
 rw ( mount -o subvolmode=rw...) should raise an error ?  (IMHO yes) 
- if the filesystem is mounted as ro (mount -o ro....), does mounting the filesystem a 2nd time rw ( mount -o rw...) should raise an error ?  (IMHO yes) 
- if a subvolume is mounter rw (or ro), does mounting the same subvolume a 2nd time as ro (or rw) should raise an error ?  (IMHO yes) 


BR
G.Baroncelli

>> 
>> Moreover we can add further rules to inherit the subvolume RO/RW
>> status at the creation time (even tough it makes sense only for the
>> snapshot). We could use an xattr for that.
>> 
>> Finally I would like to point out that relying on the relationship
>> parent/child between the subvolumes is very dangerous. With the
>> exception if the subvolid=5 which is the only root one, it is very
>> easy to move up and down the subvolume. I have to point out this
>> because I read on another email that someone likes the idea to
>> having a RO subvolume because its parent is marked RO. But a
>> subvolume may be mounted also by id and not by its path (and or
>> name). So relying on the relationship parent/child would lead to
>> break the "least surprise principle".
>> 
>> My 2 ¢ BR G.Baroncelli
> Oh I forgot that user can mv subvolumes just like normal dirs. In
> this case it will certainly make ro/rw disaster if rely on the parent
> ro/rw status. :(
> 
> Thanks, Qu
>> 
>>> Thanks, Qu
>>>> If so this behaviour seems to me correctly. Different is after 
>>>> mounting the subvolume "subvolumename", also the whole
>>>> filesystem results rw (eg: #1 succeeded).
>>>> 
>>>> G.Baroncelli
>>>> 
>>>> 
>>>> 
>>>> 
>>>> 
>>>>> The problem also happens when a parent subvol is mounted rw
>>>>> but child subvol is mounted ro. User can still modify the
>>>>> child subvol through parent subvol, still broke the readonly
>>>>> rule.
>>>>> 
>>>>> Thanks, Qu
>>>>> 
>>> 
>> 
> 
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
