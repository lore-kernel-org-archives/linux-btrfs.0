Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from umail2.aei.mpg.de ([194.94.224.8]:37875 "EHLO umail2.aei.mpg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752507AbdA3VHS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 16:07:18 -0500
Received: from mailgate.aei.mpg.de (mailgate.aei.mpg.de [194.94.224.5])
        by umail2.aei.mpg.de (Postfix) with ESMTP id D762C1BA66FD
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 22:07:00 +0100 (CET)
Received: from mailgate.aei.mpg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id CAC2E406ADE
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 22:07:00 +0100 (CET)
Received: from intranet.aei.uni-hannover.de (ahin1.aei.uni-hannover.de [130.75.117.40])
        by mailgate.aei.mpg.de (Postfix) with ESMTP id A7F78406ADB
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jan 2017 22:07:00 +0100 (CET)
Subject: Re: btrfs recovery
References: <5e29c839-6519-acb2-c094-54600a6c0102@aei.mpg.de>
 <CAJCQCtTqBaG5AhtbokOkfREStK8XC+ZAsQ-aNOtYe2Y2Nv-4jA@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Michael Born <Michael.Born@aei.mpg.de>
Message-ID: <5742ef43-0400-e0c9-c0b7-c8d3c8299f9f@aei.mpg.de>
Date: Mon, 30 Jan 2017 22:07:00 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTqBaG5AhtbokOkfREStK8XC+ZAsQ-aNOtYe2Y2Nv-4jA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Am 30.01.2017 um 21:51 schrieb Chris Murphy:
> On Mon, Jan 30, 2017 at 1:02 PM, Michael Born <Michael.Born@aei.mpg.de> wrote:
>> Hi btrfs experts.
>>
>> Hereby I apply for the stupidity of the month award.
> 
> There's still another day :-D
> 
> 
> 
>>
>> Before switching from Suse 13.2 to 42.2, I copied my / partition with dd
>> to an image file - while the system was online/running.
>> Now, I can't mount the image.
> 
> That won't ever work for any file system. It must be unmounted.

I could mount and copy the data out of my /home image.dd (encrypted
xfs). That was also online while dd-ing it.

>> Could you give me some instructions how to repair the file system or
>> extract some files from it?
> 
> Not possible. The file system was being modified while dd was
> happening, so the image you've taken is inconsistent.

The files I'm interested in (fstab, NetworkManager.conf, ...) didn't
change for months. Why would they change in the moment I copy their
blocks with dd?

Michael



