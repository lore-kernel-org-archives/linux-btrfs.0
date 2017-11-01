Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:43926 "EHLO pim.lukas-pirl.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751853AbdKAQD5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 12:03:57 -0400
Subject: Re: Several questions regarding btrfs
To: ST <smntov@gmail.com>
References: <1509467017.1662.37.camel@gmail.com>
 <edd9dfa6-a73d-54d6-d9d6-48bd5fd7f724@gmail.com>
 <1509480384.1662.84.camel@gmail.com>
 <ea097624-d485-9423-387f-3c9427508883@gmail.com>
 <1509545153.1662.105.camel@gmail.com>
From: Lukas Pirl <btrfs@lukas-pirl.de>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <b1925eda-dc71-1d47-fb26-a86e0d1581f6@lukas-pirl.de>
Date: Wed, 1 Nov 2017 16:31:33 +0100
MIME-Version: 1.0
In-Reply-To: <1509545153.1662.105.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/01/2017 03:05 PM, ST wrote as excerpted:
>> However, it's important to know that if your users have shell access, 
>> they can bypass qgroups.  Normal users can create subvolumes, and new 
>> subvolumes aren't added to an existing qgroup by default (and unless I'm 
>> mistaken, aren't constrained by the qgroup set on the parent subvolume), 
>> so simple shell access is enough to bypass quotas.

> I never did it before, but shouldn't it be possible to just whitelist
> commands users are allowed to use in the SSH config (and so block
> creation of subvolumes/cp --reflink)? I actually would have restricted
> users to sftp if I knew how to let them change their passwords once they
> wish to. As far as I know it is not possible with OpenSSH...

Possible only via a rather custom setup, I guess. You could
a) force users into a chroot via the sshd configuration
   (chroots need allowed binaries plus their libs and configs etc.),
b) solve the problem with file permissions on all binaries
   (probably a terrible pain to setup (users, groups, …) and maintain)

Cheers,

Lukas
