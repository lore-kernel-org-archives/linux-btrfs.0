Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13123 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753608AbbKGURd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 Nov 2015 15:17:33 -0500
Date: Sat, 7 Nov 2015 15:17:27 -0500
From: Chris Mason <clm@fb.com>
To: "Diego Call." <diegocg@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Reproducible corruption issue in stable, with possible patch
 unmerged?
Message-ID: <20151107201727.GB26661@ret.masoncoding.com>
References: <CAFhRPx8LiHHuuv+JfZZV+d9+rCDv2Y97WYm-eniFJTBhwKmdsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAFhRPx8LiHHuuv+JfZZV+d9+rCDv2Y97WYm-eniFJTBhwKmdsw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 07, 2015 at 04:36:56PM +0100, Diego Call. wrote:
> [repost, since the previous mail was rejected by vger.kernel.org]
> 
> I got these messages in my dmesg:
> 
> [ 2587.841376] BTRFS error (device sdc1): partial page write in btrfs
> with offset 0 and length 8392704
> [ 2588.814182] BTRFS critical (device sdc1): bad ordered accounting
> left 0 size 4096
> 
> With no other errors before. After rebooting I got btrfs
> errors and widespreading filesystem corruption (pool
> of three disks created with -d raid0 and -m raid1)
> 
> I reinstalled the system (current arch linux installer, which
> runs 4.2) and started to restore the backup. Surprisingly,
> I got exactly the same errors again. I reinstalled again,
> and after rebooting to the new system, running 4.2.5,
> I tried to restore the backup and got the same messages
> and corruption again. Then I tried reinstalling with
> the 4.1.12 LTS version, and it all worked fine.
> 
> Now, the interesting thing is that, after googling this error, I didn't
> found any interesting references except a patch sent to this
> mailing list which seems to fix a problem that causes the same
> error output. The patch doesn't seem to have been merged:
> 

Good catch.  Can you describe your configuration?

-chris

