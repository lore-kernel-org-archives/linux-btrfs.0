Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:33160 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab3JVJkr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 05:40:47 -0400
Date: Tue, 22 Oct 2013 18:40:34 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        jgoerzen@complete.org
Subject: Re: Lots of trouble hanging when rm files with many extents
Message-ID: <20131022184034.2fa93425@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Another approach could probably be to write a C program that writes
> 20GB to a file, then seeks to random places within it, writing chunks
> of data within them.
> 
> I could probably whip up such a thing if the debuggers need it.

That would be very useful, I guess!

-- 
Tomasz Chmielewski
http://wpkg.org
