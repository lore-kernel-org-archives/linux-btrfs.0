Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:48058 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823Ab3KAFdG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Nov 2013 01:33:06 -0400
Date: Fri, 1 Nov 2013 14:32:55 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: could not find root 8
Message-ID: <20131101143255.2d3ae3f5@virtall.com>
In-Reply-To: <52733AA0.1090200@cn.fujitsu.com>
References: <20131101142010.02956ad8@virtall.com>
	<52733AA0.1090200@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 01 Nov 2013 13:22:40 +0800
Wang Shilong <wangsl.fnst@cn.fujitsu.com> wrote:

> On 11/01/2013 01:20 PM, Tomasz Chmielewski wrote:
> > What does this message mean? It started to show up for me recently;
> > other than that, the filesystem seems to be working correctly.
> Root 8 is  a quota root.
> 
> If you disable qgroup, and then run btrfs qgroup show <mnt>
> the following message will be outputed.

Ah, indeed - I've disabled qgroup to see if the system becomes stable,
but some cronjobs still call "btrfs qgroup".


-- 
Tomasz Chmielewski
http://wpkg.org
