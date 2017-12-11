Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym01.jp.fujitsu.com ([211.128.242.40]:25681 "EHLO
        mgwym01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdLKICY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 03:02:24 -0500
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 3ED64AC01A0
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Dec 2017 17:02:17 +0900 (JST)
Subject: Re: [RFC v2] Improve subvolume usability for a normal user
To: ein <ein.net@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <eae0749c-eca0-4952-d4b3-ec4175d22653@jp.fujitsu.com>
 <5A2E3418.30504@gmail.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <f794a7d3-8858-7dc6-7fc0-893c0f461b03@jp.fujitsu.com>
Date: Mon, 11 Dec 2017 17:02:10 +0900
MIME-Version: 1.0
In-Reply-To: <5A2E3418.30504@gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On 2017/12/11 16:30, ein wrote:
> On 12/11/2017 07:38 AM, Misono, Tomohiro wrote:
>> - Change the default behavior to allow a user to delete subvolume which is empty
> 
> From sysadmin point of view I think it's worth considering the following
> scenario(s):
> what if admin wants one persistent snapshot undeletable by the user?
> - snapshots created by the root in user work tree should not be deleted
> by the user (snapshot owner should be root?), but we may want also
> permissions, filesystem ACLs and extend ACLs consistency
> - snapshots with chattr +i should be not deleted by the user, even if he
> created it.
> --
Immutable flag is already supported. So, we can set +i recursively by "sudo chattr -R +i <snapshot>"
If Immutable flag is set, it cannot be deleted by even root and it cannot be set/dropped by a normal user.

