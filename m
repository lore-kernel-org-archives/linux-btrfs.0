Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:37682 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751281AbdLKHab (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 02:30:31 -0500
Received: by mail-lf0-f47.google.com with SMTP id a12so18009871lfe.4
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Dec 2017 23:30:31 -0800 (PST)
Message-ID: <5A2E3418.30504@gmail.com>
Date: Mon, 11 Dec 2017 08:30:32 +0100
From: ein <ein.net@gmail.com>
MIME-Version: 1.0
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [RFC v2] Improve subvolume usability for a normal user
References: <eae0749c-eca0-4952-d4b3-ec4175d22653@jp.fujitsu.com>
In-Reply-To: <eae0749c-eca0-4952-d4b3-ec4175d22653@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/11/2017 07:38 AM, Misono, Tomohiro wrote:
> - Change the default behavior to allow a user to delete subvolume which is empty

>From sysadmin point of view I think it's worth considering the following
scenario(s):
what if admin wants one persistent snapshot undeletable by the user?
- snapshots created by the root in user work tree should not be deleted
by the user (snapshot owner should be root?), but we may want also
permissions, filesystem ACLs and extend ACLs consistency
- snapshots with chattr +i should be not deleted by the user, even if he
created it.
