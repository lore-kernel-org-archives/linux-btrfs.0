Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:36096 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340Ab3GaHqO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 03:46:14 -0400
Date: Wed, 31 Jul 2013 14:46:06 +0700
From: Tomasz Chmielewski <tch@virtall.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: ERROR: quota command failed: Invalid argument
Message-ID: <20130731144606.01cb0962@virtall.com>
In-Reply-To: <20130731144128.08c50a7d@wpkg.org>
References: <20130731144128.08c50a7d@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 31 Jul 2013 14:41:28 +0700
Tomasz Chmielewski <mangoo@wpkg.org> wrote:

> I'm getting "ERROR: quota command failed: Invalid argument" when
> trying to run "btrfs quota rescan" - is it expected?
> 
> root@bkp010 ~ # btrfs quota rescan /mnt/lxc1
> ERROR: quota command failed: Invalid argument
> 
> root@bkp010 ~ # btrfs quota rescan /mnt/lxc1
> ERROR: quota command failed: Invalid argument

Ah, just noticed it's because I uses btrfs from here:

http://github.com/miaoxie/btrfs-progs.git


The upstream version works fine.

-- 
Tomasz Chmielewski
http://wpkg.org
