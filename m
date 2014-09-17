Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:57693 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbaIQDFM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 23:05:12 -0400
Received: from homiemail-a59.g.dreamhost.com (sub5.mail.dreamhost.com [208.113.200.129])
	by hapkido.dreamhost.com (Postfix) with ESMTP id 9C89B862D5
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Sep 2014 20:05:12 -0700 (PDT)
Date: Tue, 16 Sep 2014 23:05:00 -0400
From: Shea Levy <shea@shealevy.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Setting FS_USERNS_MOUNT in btrfs_fs_type.fs_flags
Message-ID: <20140917030500.GD6185@nixos.hsd1.nh.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

What work would be required to mark btrfs_fs_type with FS_USERNS_MOUNT
so that btrfs images can be mounted by unprivileged users within a user
namespace (along with something like [1])? I'd like to be able to create
disk images without having to start a VM (and --rootdir isn't flexible
enough because I want to make subvolumes).

Cheers,
Shea Levy

P.S. I am not subscribed to either list, please CC me in replies

[1] https://lkml.org/lkml/2014/5/27/690
