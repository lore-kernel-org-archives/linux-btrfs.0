Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:37404 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755644AbdIRLpX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 07:45:23 -0400
Received: by mail-io0-f194.google.com with SMTP id 93so730768iol.4
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2017 04:45:22 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id f199sm3588858iof.31.2017.09.18.04.45.20
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Sep 2017 04:45:21 -0700 (PDT)
Subject: Re: snapshots of encrypted directories?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20170914145739.GA32347@rus.uni-stuttgart.de>
 <20170914153222.GC7067@carfax.org.uk>
 <ac97097d-f107-042c-f402-580a2ab5aa76@gmail.com>
 <20170915100103.GB32347@rus.uni-stuttgart.de>
 <CAEtw4r1KUQJGZkKEA+e3J=3+4a9hW+-ZBRBfTXhwYn4Ae30CCw@mail.gmail.com>
 <20170915162825.GC32347@rus.uni-stuttgart.de>
 <6cd1ef22-7cab-4c8c-0b73-d254aeca83ad@gmail.com>
 <20170915194126.GF32347@rus.uni-stuttgart.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6100b72b-db9c-43c5-cb3f-a2b9d4a00b57@gmail.com>
Date: Mon, 18 Sep 2017 07:45:18 -0400
MIME-Version: 1.0
In-Reply-To: <20170915194126.GF32347@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-15 15:41, Ulli Horlacher wrote:
> On Fri 2017-09-15 (13:16), Austin S. Hemmelgarn wrote:
> 
>>>> And then mount enryptfs:
>>>>
>>>> mount.ecryptfs /<MOUNTPOINT_ENCRYPTED> /<MOUNTPOINT_DECRYPTED>
>>>
>>> This only possible by root.
>>> For a user it is not possible to have access for his own snapshots.
>>> Bad.
>>
>> Which is why you use EncFS (which is a FUSE module that runs in
>> userspace and requires no root privileges) instead of eCryptFS (which is
>> a kernel assisted filesystem that doesn't use FUSE, has more complicated
>> setup constraints, and requires CAP_SYS_ADMIN or root access).
> 
> I use both, encfs and ecryptfs, for different use cases.
> I use ecryptfs on my notebooks for $HOME, which has some kind of
> automounter on login (via pam).
> This setup is not possible with encfs, which is also much slower and has
> a lower security level.
Actually it is, it's just not trivially easy like with eCryptFS.  the 
pam_script module can be used to perform auto-mounting on login as well.
> 
> But even for encfs it is very circumstantial for a user to have access to
> snapshots.
> It's still a case where it's a problem of the combined usage of the two, 
and it's not likely to get fixed by either.  In theory, it should be 
possible to have some hook added that handles mounting the snapshots 
when one is taken and when the user logs in, but that isn't the job of 
BTRFS at all (filesystems are supposed to not care about what's using 
them), and I don't see it as likely that EncFS or eCryptFS will add 
support either (they can't reliably watch for snapshot creation, so they 
would have to add snapshot support and force you to go through them). 
Overall, you're likely to be better off arguing for BTRFS native support 
for the VFS encryption API (that is, F2FS and ext4 style native per-file 
encryption).
