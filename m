Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([82.95.169.224]:36846 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab3ARIov (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jan 2013 03:44:51 -0500
Date: Fri, 18 Jan 2013 09:44:49 +0100
From: Sander <sander@humilis.net>
To: Reartes Guillermo <rtguille@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs: could not do orphan cleanup -22
Message-ID: <20130118084449.GA16399@panda>
Reply-To: sander@humilis.net
References: <CAPVzhpxSdjLTUhA0jVm5gLSvX9fB0N9zV6UTTQno2bANTsfGVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPVzhpxSdjLTUhA0jVm5gLSvX9fB0N9zV6UTTQno2bANTsfGVw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reartes Guillermo wrote (ao):
> [   71.617841] device label testfs1 devid 1 transid 4143 /dev/sdb1
> [   71.619164] btrfs: disk space caching is enabled
> [   71.629969] device label fedora devid 1 transid 2038 /dev/sda2
> [   71.805339] btrfs: Error removing orphan entry, stopping orphan cleanup
> [   71.806597] btrfs: could not do orphan cleanup -22
> [   71.986601] device label testfs1 devid 1 transid 4143 /dev/sdb1
> [   72.934724] btrfs: open_ctree failed

> Since sda2 is mounted i could not check it, but from the logs it is
> not clear to me if the issue is in sda2 or sdb1.

Seems sda2 from the above.
