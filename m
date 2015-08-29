Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:33289 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbbH2W3A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Aug 2015 18:29:00 -0400
Received: by vkbf67 with SMTP id f67so18037620vkb.0
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Aug 2015 15:28:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG__1a7WWVORLm3JZKwg8BgvA=+LM+i4Dwxjs72sBpHP1XM4uw@mail.gmail.com>
References: <CAG__1a4T=d_O49CnOw+0gtKr56xtrmcjRcmujtUff_s_-oL0Jw@mail.gmail.com>
	<20150826165024.05af044f@natsu>
	<55DDAB1C.90406@gmail.com>
	<CAG__1a4x_bv2DURyT0ZW0p+udh43ifcn=bHjUKM4NF1Tk=cYDw@mail.gmail.com>
	<20150828093502.GO23769@carfax.org.uk>
	<CAG__1a7WWVORLm3JZKwg8BgvA=+LM+i4Dwxjs72sBpHP1XM4uw@mail.gmail.com>
Date: Sat, 29 Aug 2015 16:28:58 -0600
Message-ID: <CAJCQCtTZYEpVjs6rkAc7UhBarktbXri8eUGZPZP4nhUNzLkndw@mail.gmail.com>
Subject: Re: Understanding BTRFS storage
From: Chris Murphy <lists@colorremedies.com>
To: George Duffield <forumscollective@gmail.com>
Cc: Hugo Mills <hugo@carfax.org.uk>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 29, 2015 at 2:52 AM, George Duffield
<forumscollective@gmail.com> wrote:
> Funny you should say that, whilst I'd read about it it didn't concern
> me much until Neil Brown himself advised me against expanding the
> raid5 arrays any further (one was built using 3TB drives and the other
> using 4TB drives).  My understanding is that larger arrays are
> typically built using more drives of lower capacity.  I'm also loathe
> to use mdadm as expanding arrays takes forever whereas a Btrfs array
> should expand much quicker.  If Btrfs raid isn't yet ready for prime
> time I'll just hold off doing anything for the moment, frustrating as
> that is.

I think a grid of mdadm vs btrfs feature/behavior comparisons might be useful.

The main thing to be aware of with btrfs multiple device is the
failure handling is really not present; whereas it is with mdadm and
lvm raids. This means btrfs tolerates read and write failures where md
will "eject" the drive from the array after even one write failure,
and after so many read failures (not sure what it is). There's also no
spares support. And no notifications of problems, just kernel
messages.

Instead of notification emails the mdadm way, I think it's better to
look at maybe libblockdev and storaged projects since both of those
are taking on standardizing the manipulation of mdadm arrays, LVM,
LUKS, and other Linux storage technologies. And then project like (but
no limited to) openLMI and a future udisks2 replacement can then get
information and state on such things, and propagate that up to the
user (with email, text message, web browser, whatever).

-- 
Chris Murphy
