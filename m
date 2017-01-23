Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:35220 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdAWVum (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 16:50:42 -0500
Received: by mail-yw0-f195.google.com with SMTP id 17so18857543ywk.2
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jan 2017 13:50:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170123213109.GA11778@vader.DHCP.thefacebook.com>
References: <CAJCQCtRhgxqtrpnsibOPqkMA75Cf=ryRAeTb0Gf-ygy=gjD_Yg@mail.gmail.com>
 <CAJCQCtT73Zh2F13tg3v4UZC3+rdTMhgC==Ag3LZQ-RZMTpisOg@mail.gmail.com>
 <CAJCQCtSZyfHdmsaVdEM7iQiKfK-s4Qqs4ORZrE1MCpWCgeCWbw@mail.gmail.com>
 <CAJCQCtQz5fhYymEgFuxuiactZpWeUSEeCCXFCAEmLTTA6AOZLQ@mail.gmail.com> <20170123213109.GA11778@vader.DHCP.thefacebook.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 23 Jan 2017 14:50:41 -0700
Message-ID: <CAJCQCtSVXRXvGmnmfFt5yn_L33a8eCCuuFANxTOyWLrJeqrK9g@mail.gmail.com>
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items,
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 23, 2017 at 2:31 PM, Omar Sandoval <osandov@osandov.com> wrote:
> On Wed, Jan 18, 2017 at 02:27:13PM -0700, Chris Murphy wrote:
>> On Wed, Jan 11, 2017 at 4:13 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> > Looks like there's some sort of xattr and Btrfs interaction happening
>> > here; but as it only happens with some subvolumes/snapshots not all
>> > (but 100% consistent) maybe the kernel version at the time the
>> > snapshot was taken is a factor?
>>
>> The kernel version at the time the snapshot is taken is not a factor.
>> I've taken a snapshot of a working subvolume, and booting the snapshot
>> fails during startup with the fs forced readonly with kernel 4.9 and
>> higher; the problem doesn't happen with kernel 4.8.17 and lower.
>>
>> As a further test I tried:
>>
>>
>> git checkout tags/v4.9
>> git revert 6c6ef9f26e598fb977f60935e109cd5b266c941a
>>
>> But I get a failure during compile:
>>
>> scripts/Makefile.build:293: recipe for target 'fs/xattr.o' failed
>> make[1]: *** [fs/xattr.o] Error 1
>> Makefile:988: recipe for target 'fs' failed
>> make: *** [fs] Error 2
>>
>> Anyway, the inability to boot snapshots means bootable rollbacks are
>> broken. I think this is a serious regression, what's the next step in
>> figuring out what's going on?
>
> Hm, so you're 100% sure that this exact commit caused the regression?
> I've stared at it for a little while and am not seeing anything obvious.

This is the git bisect log:
https://bugzilla.kernel.org/attachment.cgi?id=251271

I don't know how to evaluate your question. If there's a test that
helps answer the question, let me know. Searching for this commit
brings up an lkml thread:

https://lkml.org/lkml/2016/11/3/268

I haven't found the commit for that patch, so maybe it's something
with the combination of that patch and the previous commit. But I see
it's applied in at least 4.10-rc4 and this forced readonly event
happens with 4.10-rc4.


-- 
Chris Murphy
