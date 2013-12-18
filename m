Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from md5i.com ([75.151.244.229]:56769 "EHLO maru2.md5i.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751267Ab3LREuZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 23:50:25 -0500
From: Michael Welsh Duggan <mwd@md5i.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, mwd@md5i.com
Subject: Re: [PATCH] Btrfs-progs: receive: fix the case that we can not find subvolume
References: <1387271629-11315-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<20131217150919.GP6498@twin.jikos.cz>
	<tntbo0fcwp2.fsf@watermonitor.yellow.cert.org>
	<52B10EBE.4030508@cn.fujitsu.com> <8761qmsup8.fsf@maru2.md5i.com>
	<52B11C67.2010900@cn.fujitsu.com>
Date: Tue, 17 Dec 2013 23:06:17 -0500
In-Reply-To: <52B11C67.2010900@cn.fujitsu.com> (Wang Shilong's message of
	"Wed, 18 Dec 2013 11:54:15 +0800")
Message-ID: <871u1asszq.fsf@maru2.md5i.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wang Shilong <wangsl.fnst@cn.fujitsu.com> writes:

> It seems that you use older kernel version but use the latest
> btrfs-progs, new btrfs-progs use uuid tree to search but
> this tree did not exist yet.
>
> Can you try to upgrade your kernel?

What version is necessary?  (I am currently on 3.11.10.)

-- 
Michael Welsh Duggan
(md5i@md5i.com)
