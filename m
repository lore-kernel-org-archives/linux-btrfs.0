Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34756 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbbK1SYV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Nov 2015 13:24:21 -0500
Received: by igvg19 with SMTP id g19so47604238igv.1
        for <linux-btrfs@vger.kernel.org>; Sat, 28 Nov 2015 10:24:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAK5rZE7j-4QMFjvn-FzWXDdqegvkQ9=HGoLUey6Kw4OMsQ0uZQ@mail.gmail.com>
References: <CAK5rZE7_f6cypBPTR8UX-7t=OnRE595XBw__kN6Gy2cNowGFgA@mail.gmail.com>
	<20151127204305.GE24333@carfax.org.uk>
	<CAJCQCtQgjbR77eei2-srOofBLpWp-avj_2OMCRa_4Ffby8eL5g@mail.gmail.com>
	<CAK5rZE7j-4QMFjvn-FzWXDdqegvkQ9=HGoLUey6Kw4OMsQ0uZQ@mail.gmail.com>
Date: Sat, 28 Nov 2015 11:24:21 -0700
Message-ID: <CAJCQCtSpB=ZWHeZ3f5bJcvaBOv9gA77Ke97uEOHTjsN53p0-Gg@mail.gmail.com>
Subject: Re: BTRFS: could not find root 8
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 28, 2015 at 2:40 AM, Imran Geriskovan
<imran.geriskovan@gmail.com> wrote:
>>>> After upgrading from systemd227 to 228
>>>> these messages began to show up during boot:
>>>> [   24.652118] BTRFS: could not find root 8
>>>> [   24.664742] BTRFS: could not find root 8
>
>> b. For the OP, is it possible quotas was ever enabled on this file system?
>
> Quotas have never been enabled since creation of this fs.


OK so we need some clarification on whether "could not find root 8" is
telling us systemd was looking to leverage already enabled quotas but can't
because they're not enabled; or if it's enabled them. I'd be surprised if
it's enabling quotas.

And also how to determine, from user space, whether quotas are enabled.

In the meantime, OP, does this message happen every boot? Or is it onetime?
If every boot, you could add boot parameter systemd.log_level=debug and
then look just above the "could not find..." message what systemd is doing
just prior.

--
Chris Murphy
