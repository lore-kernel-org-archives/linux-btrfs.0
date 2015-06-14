Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:40625 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbbFNAa2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Jun 2015 20:30:28 -0400
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: kernel crashes with btrfs and busy database IO - how to debug?
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sun, 14 Jun 2015 09:30:25 +0900
From: Tomasz Chmielewski <tch@virtall.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <cf09b22a06bf52a5b365fa44e15583f7@admin.virtall.com>
References: <ae9b9ca434c98509ca6c1ba6dbd84b63@admin.virtall.com>
 <557A8691.6070908@cn.fujitsu.com>
 <73cb882c23a71c9039a0e7bbfddfab64@admin.virtall.com>
 <557AA1B9.9040009@cn.fujitsu.com>
 <cf09b22a06bf52a5b365fa44e15583f7@admin.virtall.com>
Message-ID: <f96134ed2c586f25fa959234fc525ab9@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-06-13 08:23, Tomasz Chmielewski wrote:

> I did get it from /var/crash/ though - is it more useful? I don't have
> vmlinux for this kernel though, but have just built 4.1-rc7 with the
> same config, can try to get the crash there.

I've uploaded a crash dump and vmlinux here:

http://www.virtall.com/files/temp/201506132321/

Let me know if it's anything useful or if you need more info.


-- 
Tomasz Chmielewski


