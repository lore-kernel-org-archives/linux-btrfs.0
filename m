Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:51203 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbcCDSJm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Mar 2016 13:09:42 -0500
Subject: Re: balance hangs and starts again on reboot
To: Marc Haber <mh+linux-btrfs@zugschlus.de>, linux-btrfs@vger.kernel.org
References: <20160304173125.GA1902@torres.zugschlus.de>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56D9CF63.3060603@googlemail.com>
Date: Fri, 4 Mar 2016 19:09:39 +0100
MIME-Version: 1.0
In-Reply-To: <20160304173125.GA1902@torres.zugschlus.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/04/16 18:31, Marc Haber wrote:
> I have another btrfs on the same host that has no the no space left on
> device balance issue, but on another disk. On this btrfs, it seems
> like a balance process is stuck, with a lot of hanging kernel
> threads. After a reboot, when I mount the filesystem, the balance
> immediately starts again. btrfs balance cancel just hangs around with
> no visible reaction for hours.
> 
> Log appended. Is there rescue?

Can't offer much help other than to recommend to *always* mount with
-o skip_balance, which IMHO should have been the default behaviour
from the beginning. Then try to balance in small increments.

-h

