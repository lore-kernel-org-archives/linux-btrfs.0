Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:37022 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751729AbdLKHeF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 02:34:05 -0500
Received: by mail-lf0-f45.google.com with SMTP id a12so18018840lfe.4
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Dec 2017 23:34:04 -0800 (PST)
Message-ID: <5A2E34EF.7040600@gmail.com>
Date: Mon, 11 Dec 2017 08:34:07 +0100
From: ein <ein.net@gmail.com>
MIME-Version: 1.0
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC v2] Improve subvolume usability for a normal user
References: <eae0749c-eca0-4952-d4b3-ec4175d22653@jp.fujitsu.com> <5A2E3418.30504@gmail.com>
In-Reply-To: <5A2E3418.30504@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

And also, how to prevent creation of the snapshots by the user.

On 12/11/2017 08:30 AM, ein wrote:
> On 12/11/2017 07:38 AM, Misono, Tomohiro wrote:
>> - Change the default behavior to allow a user to delete subvolume which is empty
> From sysadmin point of view I think it's worth considering the following
> scenario(s):
> what if admin wants one persistent snapshot undeletable by the user?
> - snapshots created by the root in user work tree should not be deleted
> by the user (snapshot owner should be root?), but we may want also
> permissions, filesystem ACLs and extend ACLs consistency
> - snapshots with chattr +i should be not deleted by the user, even if he
> created it.

