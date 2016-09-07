Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:35954 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753990AbcIGPUe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Sep 2016 11:20:34 -0400
Received: by mail-it0-f53.google.com with SMTP id i184so203779694itf.1
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Sep 2016 08:20:34 -0700 (PDT)
Subject: Re: Security implications of btrfs receive?
To: Graham Cobb <g.btrfs@cobb.uk.net>, linux-btrfs@vger.kernel.org
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com>
 <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
 <4a00b682-c674-a46f-798e-d98b3e517f02@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f954e01c-3ccf-5b44-3fde-e627537f2af2@gmail.com>
Date: Wed, 7 Sep 2016 11:20:19 -0400
MIME-Version: 1.0
In-Reply-To: <4a00b682-c674-a46f-798e-d98b3e517f02@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-07 07:58, Austin S. Hemmelgarn wrote:
> On 2016-09-06 13:20, Graham Cobb wrote:
>> Thanks to Austin and Duncan for their replies.
>>
>> On 06/09/16 13:15, Austin S. Hemmelgarn wrote:
>>> On 2016-09-05 05:59, Graham Cobb wrote:
>>>> Does the "path" argument of btrfs-receive mean that *all* operations
>>>> are
>>>> confined to that path?  For example, if a UUID or transid is sent which
>>>> refers to an entity outside the path will that other entity be affected
>>>> or used?
>>> As far as I know, no, it won't be affected.
>>>> Is it possible for a file to be created containing shared
>>>> extents from outside the path?
>>> As far as I know, the only way for this to happen is if you're
>>> referencing a parent subvolume for a relative send that is itself
>>> sharing extents outside of the path.  From a practical perspective,
>>> unless you're doing deduplication on the receiving end, the this
>>> shouldn't be possible.
>>
>> Unfortunately that is not the case.  I decided to do some tests to see
>> what happens.  It is possible for a receive into one path to reference
>> and access a subvolume from a different path on the same btrfs disk.  I
>> have created a bash script to demonstrate this at:
>>
>> https://gist.github.com/GrahamCobb/c7964138057e4e092a75319c9fb240a3
>>
>> This does require the attacker to know the (source) subvolume UUID they
>> want to copy.  I am not sure how hard UUIDs are to guess.
> Oh, I forgot about the fact that it checks the whole filesystem for
> referenced source subvolumes.
>>
>> By the way, this is exactly the same whether or not the --chroot option
>> is specified on the "btrfs receive" command.
> Which makes sense, chroot only affects the VFS layer, not the underlying
> FS.
>>
>> The next question this raises for me is whether this means that
>> processes in a chroot or in a container (or in a mandatory access
>> controls environment) can access files outside the chroot/container if
>> they know the UUID of the subvolume?  After all, btrfs-receive uses
>> IOCTLs that any program running as root can use.
> Yes, it does mean that, but if you want proper security you should be
> using a real container system (or better yet, a virtual machine), not
> just a chroot.  Chroot by itself is not a security mechanism, it's a
> safety belt and testing tool.  If you actually want to secure something,
> chroot should only be part of it, together with isolating it to it's own
> filesystem, and using cgroups and namespaces.
I should probably add to this that you shouldn't be accepting 
send/receive data streams from untrusted sources anyway.  While it 
probably won't crash your system, it's not intended for use as something 
like a network service.  If you're sending a subvolume over an untrusted 
network, you should be tunneling it through SSH or something similar, 
and then using that to provide source verification and data integrity 
guarantees, and if you can't trust the system's your running backups 
for, then you have bigger issues to deal with.
