Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35723 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758710AbcCDTIL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Mar 2016 14:08:11 -0500
Received: by mail-io0-f171.google.com with SMTP id g203so72176471iof.2
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Mar 2016 11:08:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160304173125.GA1902@torres.zugschlus.de>
References: <20160304173125.GA1902@torres.zugschlus.de>
Date: Fri, 4 Mar 2016 12:08:10 -0700
Message-ID: <CAJCQCtTtfwQgt5+MwP9QjKMLwAM+StMSq+DFDTMTV7u_78t45g@mail.gmail.com>
Subject: Re: balance hangs and starts again on reboot
From: Chris Murphy <lists@colorremedies.com>
To: Marc Haber <mh+linux-btrfs@zugschlus.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 4, 2016 at 10:31 AM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> Hi,
>
> I have another btrfs on the same host that has no the no space left on
> device balance issue, but on another disk. On this btrfs, it seems
> like a balance process is stuck, with a lot of hanging kernel
> threads. After a reboot, when I mount the filesystem, the balance
> immediately starts again. btrfs balance cancel just hangs around with
> no visible reaction for hours.
>
> Log appended. Is there rescue?

The log is made much more useful if you can sysrq+w while the blocked
task is happening; and then dmesg or journalctl -k to get the results
into a file for attachment to avoid the annoying MUA wrapping.




-- 
Chris Murphy
