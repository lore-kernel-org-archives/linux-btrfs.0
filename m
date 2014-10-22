Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:57785 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049AbaJVMtr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 08:49:47 -0400
Received: by mail-vc0-f178.google.com with SMTP id hq12so1901877vcb.9
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Oct 2014 05:49:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$19856$ee791297$ceeef1ce$27ae8dc@cox.net>
References: <20141016113337.GC22943@twin.jikos.cz>
	<20141020163403.GW22943@twin.jikos.cz>
	<pan$32992$bbc3a80d$ad912ad2$31fcc5ce@cox.net>
	<CAGfcS_nTbXQQTOC+QcBX8dbwk18Qbf-+JonQSw4WP6MOFg2z7A@mail.gmail.com>
	<pan$19856$ee791297$ceeef1ce$27ae8dc@cox.net>
Date: Wed, 22 Oct 2014 08:49:46 -0400
Message-ID: <CAAVQaYA9UWbF3ROXRRmcbKX9U7dwrT19Rc3NSX2vuzfVr3oXVA@mail.gmail.com>
Subject: Re: Poll: time to switch skinny-metadata on by default?
From: Dave <dave@thekilempire.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 21, 2014 at 10:08 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> As for the mounted filesystem question, since all it does is flip a
> switch so that new metadata writes use the skinny-metadata code path, it
> shouldn't be a problem.

Nope.  Just tried it here:

# btrfs --version
Btrfs v3.16.1-42-g140eccb

# btrfstune -x /dev/dm-0
/dev/dm-0 is mounted
-- 
-=[dave]=-

Entropy isn't what it used to be.
