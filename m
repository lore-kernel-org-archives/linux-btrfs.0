Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ebox.rath.org ([23.92.25.96]:52151 "EHLO ebox.rath.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbbC0DjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Mar 2015 23:39:16 -0400
From: Nikolaus Rath <Nikolaus@rath.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel warning at fs/btrfs/inode.c:8693 btrfs_destroy_inode+0x1fa/0x2a0 [btrfs]()
References: <87wq23ff57.fsf@vostro.rath.org>
	<CAJCQCtTJ9wPfpLXtC+SQdpfcDww+H1_u=kjcmGe=CZtJSAkEmA@mail.gmail.com>
Date: Thu, 26 Mar 2015 20:39:14 -0700
In-Reply-To: <CAJCQCtTJ9wPfpLXtC+SQdpfcDww+H1_u=kjcmGe=CZtJSAkEmA@mail.gmail.com>
	(Chris Murphy's message of "Thu, 26 Mar 2015 21:21:36 -0600")
Message-ID: <87sicrf6sd.fsf@vostro.rath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mar 26 2015, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Mar 26, 2015 at 6:38 PM, Nikolaus Rath <Nikolaus@rath.org> wrote:
>
>> I'm running 4.0-rc3, and I'm regularly getting these warnings in my
>> kernel log:
>
>> Mar 26 17:31:13 vostro kernel: [21480.088682] WARNING: CPU: 0 PID:
>> 28958 at fs/btrfs/inode.c:8693 btrfs_destroy_inode+0x1fa/0x2a0
>> [btrfs]()
>
> It's known.
> https://lkml.org/lkml/2015/3/7/41

Thanks. Does this mean that I risk data corruption when using btrfs with
4.0-rc3, or is this relatively harmless?

Best,
-Nikolaus
-- 
GPG encrypted emails preferred. Key id: 0xD113FCAC3C4E599F
Fingerprint: ED31 791B 2C5C 1613 AF38 8B8A D113 FCAC 3C4E 599F

             »Time flies like an arrow, fruit flies like a Banana.«
