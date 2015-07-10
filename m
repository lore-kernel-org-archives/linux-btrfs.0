Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f47.google.com ([209.85.216.47]:43294 "EHLO
	mail-vn0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbbGJAvV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jul 2015 20:51:21 -0400
Received: by vnbf1 with SMTP id f1so25228075vnb.10
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 17:51:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <trinity-6ce0e74d-59bd-46bc-a3d6-a45d130708b7-1436484868276@3capp-webde-bs53>
References: <trinity-6ce0e74d-59bd-46bc-a3d6-a45d130708b7-1436484868276@3capp-webde-bs53>
Date: Thu, 9 Jul 2015 18:51:20 -0600
Message-ID: <CAJCQCtRvVSPjBc6GnMu8rB1WDS_xjFXabHXHE7HxWugDo_rRTw@mail.gmail.com>
Subject: Re: [BUG] Fails to duplicate metadata/system
From: Chris Murphy <lists@colorremedies.com>
To: conchur@web.de
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 9, 2015 at 5:34 PM,  <conchur@web.de> wrote:
> Hi,
>
> I've noticed that a single device partition was using metadata.single and system.single instead of metadata.dup and system.dup. All tests to force conversion to dup failed.
>

Try only -mconvert=dup and without -f flag and see if it works. I'm
pretty sure system chunks are treated in parity with metadata chunks
now so it doesn't need to be separately listed. And -f isn't needed
except to reduce redundancy.

If that's not it, I'm going to speculate maybe try kernel 4.0.6 and
higher, as there was a bug in 4.0 that prevented chunk conversions but
I thought that only applied to raid profiles, not single vs dup. The
fix for that was commit 153c35b6cccc0c72de9fae06c8e2c8b2c47d79d4.



-- 
Chris Murphy
