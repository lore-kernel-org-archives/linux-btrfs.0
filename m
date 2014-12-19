Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36177 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaLSCFx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 21:05:53 -0500
Received: by mail-ob0-f172.google.com with SMTP id va8so9668721obc.3
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 18:05:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR=1atHwyn3563nhQCnFyd2Ra99S2ps8Y11=6qfau-onw@mail.gmail.com>
References: <CAN6BF2LwtJkjt1qB6C-wcVxizGj4bufvojR29QX5e7JJ_h-xXA@mail.gmail.com>
	<CAJCQCtR=1atHwyn3563nhQCnFyd2Ra99S2ps8Y11=6qfau-onw@mail.gmail.com>
Date: Thu, 18 Dec 2014 19:05:52 -0700
Message-ID: <CAJCQCtQEbmb0RFZX9NrP5iF_mMRCKOTBOgACZOMkm=AKx+w1nQ@mail.gmail.com>
Subject: Re: Extra info
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 18, 2014 at 6:57 PM, Chris Murphy <lists@colorremedies.com> wrote:
> The other thing going on here is that every write is going to be COW,
> which isn't ideal for VM images.

Reminder goes here for setting xattr +C on VM images. You can't set it
after the fact though. Only at the time the file is created. A reflink
copy into a folder with +C will fail. And there's not enough space on
the volume to fully copy it.


-- 
Chris Murphy
