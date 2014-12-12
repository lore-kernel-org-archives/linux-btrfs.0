Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:44460 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaLLVqk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Dec 2014 16:46:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 12 Dec 2014 22:46:37 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: Robert White <rwhite@pobox.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0: kernel BUG at fs/btrfs/relocation.c:242!
In-Reply-To: <548B5FD6.5080306@pobox.com>
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com>
 <542EE83D.8050701@fb.com>
 <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com>
 <438e043f73392614d1453892b7fe225c@admin.virtall.com>
 <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com>
 <548B5FD6.5080306@pobox.com>
Message-ID: <ce7dba343916e4262a92071af863d014@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-12-12 22:36, Robert White wrote:

> In another thread [that was discussing SMART] you talked about
> replacing a drive and then needing to do some patching-up of the
> result because of drive failures. Is this the same filesystem where
> that happened?

Nope, it was on a different server.

-- 
Tomasz Chmielewski
http://www.sslrack.com

