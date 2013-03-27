Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39529 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab3C0GlV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 02:41:21 -0400
Message-ID: <5152956A.4000004@cn.fujitsu.com>
Date: Wed, 27 Mar 2013 14:44:58 +0800
From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Koen De Wit <koen.de.wit@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: The -c option of btrfs qgroup limit
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Koen,

	Although we offer '-c' option for btrfs qgroup limit,
it has been not implemented yet.
	So until now, btrfs quota just limits the real space
that writes to the space.

Thanks,
Wang

