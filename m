Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33502 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932906AbdCaLeK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 07:34:10 -0400
Received: by mail-io0-f196.google.com with SMTP id f84so5620706ioj.0
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Mar 2017 04:34:09 -0700 (PDT)
Subject: Re: Fwd: Confusion about snapshots containers
To: Tim Cuthbertson <ratcheer@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CAAKzf7ngoK27K=7gtUJR83QoPOwLAxQNK9NcOunNDX0-ijQ5_w@mail.gmail.com>
 <20170329215554.GT11714@carfax.org.uk>
 <CAAKzf7n=e9Onnc5D-U_zBtXXpFk11QiN7RhisqAB5Ej0DQOcfA@mail.gmail.com>
 <pan$9f56c$63e254c1$b0a3dfea$f7b524f9@cox.net>
 <CAAKzf7kVXJmLdDyh=jajdNW25KjPq9AGyBeADXnpn0XKXHxn9g@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6da9892b-8636-af09-ae7f-8b4a29438256@gmail.com>
Date: Fri, 31 Mar 2017 07:34:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAAKzf7kVXJmLdDyh=jajdNW25KjPq9AGyBeADXnpn0XKXHxn9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-03-30 09:07, Tim Cuthbertson wrote:
> On Wed, Mar 29, 2017 at 10:46 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Tim Cuthbertson posted on Wed, 29 Mar 2017 18:20:52 -0500 as excerpted:
>>
>>> So, another question...
>>>
>>> Do I then leave the top level mounted all the time for snapshots, or
>>> should I create them, send them to external storage, and umount until
>>> next time?
>>
>> Keep in mind that because snapshots contain older versions of whatever
>> they're snapshotting, they're a potential security issue, at least if
>> some of those older versions are libs or binaries.  Consider the fact
>> that you may have had security-updates since the snapshot, thus leaving
>> your working copies unaffected by whatever security vulns the updates
>> fixed.  If the old versions remain around where normal users have access
>> to them, particularly if they're setuid or similar, they have access to
>> those old and now known vulns in setuid executables!  (Of course users
>> can grab vulnerable versions elsewhere or build them themselves, but they
>> can't set them setuid root unless they /are/ root, so finding an existing
>> setuid-root executable with known vulns is finding the keys to the
>> kingdom.)
>>
>> So keeping snapshots unmounted and out of the normally accessible
>> filesystem tree by default is recommended, at least if you're at all
>> concerned about someone untrusted getting access to a normal user account
>> and being able to use snapshots with known vulns of setuid executables as
>> root-escalation methods.
>>
>> Another possibility is setting the snapshot subdir 700 perms, so non-
>> super-users can't normally access anything in it anyway.  Of course
>> that's a problem if you want them to have access to snapshots of their
>> own stuff for recovery purposes, but it's useful if you can do it.
>>
>> Good admins will do both of these at once if possible as they know and
>> observe the defense-in-depth mantra, knowing all too well how easy a
>> single layer of defense yields to fat-fingering or previously unknown
>> vulns.
>>
>> --
>> Duncan - List replies preferred.   No HTML msgs.
>> "Every nonfree program has a lord, a master --
>> and if you use the program, he is your master."  Richard Stallman
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Thank you, Duncan. I will try to take all that into consideration.
> These are really just fairly simple personal home systems, but
> security is still important.
On the note of the old binaries and libraries bit, nodev, noexec, and 
nosuid are all per-mountpoint, not per-volume, so you can mitigate some 
of the rsik by always mounting with those flags.  Despite that, it's 
still a good idea to not have anything more than you need mounted at any 
given time (it's a lot harder to screw up a filesystem which isn't mounted).

