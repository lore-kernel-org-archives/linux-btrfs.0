Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:35254 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967517Ab3HIHra (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 03:47:30 -0400
Date: Fri, 9 Aug 2013 15:47:20 +0800
From: Tomasz Chmielewski <tch@virtall.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs qgroup destroy -> ERROR: unable to create quota group:
 Device or resource busy
Message-ID: <20130809154720.7f4cb618@virtall.com>
In-Reply-To: <5204928F.1020603@cn.fujitsu.com>
References: <20130809133933.2fbfc6e4@virtall.com>
	<52048483.1010809@cn.fujitsu.com>
	<20130809140750.59832bc4@virtall.com>
	<52048770.40602@cn.fujitsu.com>
	<20130809144221.740d57b1@virtall.com>
	<5204928F.1020603@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 09 Aug 2013 14:56:15 +0800
Wang Shilong <wangsl.fnst@cn.fujitsu.com> wrote:

> > So how exactly should I do it? A bit confused on how to proceed.
> 
> btrfs qgroup remove 4494 13/1 <mnt>
> 
> will destroy relation between 4494 and 13/1
> Then you can try:
> 
> btrfs qgroup destroy 4494 <mnt>

Excellent, thanks a lot!

-- 
Tomasz Chmielewski
http://wpkg.org

