Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:33522 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753896AbcLKWqL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Dec 2016 17:46:11 -0500
Received: by mail-yw0-f196.google.com with SMTP id s68so6376183ywg.0
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Dec 2016 14:46:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADph71wae2AQT-v-hu0YcJdNE+dWxRZ7yQVmMEMLyhzsC-FHqQ@mail.gmail.com>
References: <CADph71xWQyFca34=K9b-1sSNUCChUnBggvcj1O5NKi8hpQjvfA@mail.gmail.com>
 <CAJCQCtTC5T0v6jZpALTPwn=CvWn-kJXZX2vVFAEjjk9xokqoPQ@mail.gmail.com> <CADph71wae2AQT-v-hu0YcJdNE+dWxRZ7yQVmMEMLyhzsC-FHqQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 11 Dec 2016 15:46:10 -0700
Message-ID: <CAJCQCtT5CG4M4nYmmefEfWjapmg3TpMXJSVmTE89r6iPxV6xHw@mail.gmail.com>
Subject: Re: btrfs-find-root duration?
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yes. Command and device only.

>
> I've tried that initially, but it run for a few hours with no output
> beside the initial 'Superblock...'.

OK when I do it on a file system with just 14GiB of metadata it's
maybe 15 seconds. So a few minutes sounds sorta suspicious to me but,
*shrug* I don't have a file system the same size to try it on, maybe
it's a memory intensive task and once the system gets low on RAM while
traversing the file system it slows done a ton.



-- 
Chris Murphy
