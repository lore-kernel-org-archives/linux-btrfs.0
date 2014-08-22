Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39573 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaHVG5C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 02:57:02 -0400
Received: by mail-wi0-f180.google.com with SMTP id n3so9442480wiv.1
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Aug 2014 23:57:01 -0700 (PDT)
Message-ID: <53F6E9B7.1040701@gmail.com>
Date: Fri, 22 Aug 2014 09:56:55 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>,
        Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Significance of high number of mails on this list?
References: <CAH-HCWVZPNkc7ycsL4jH0i6niVU3nqZiB2MLD6CfP85FckAg7g@mail.gmail.com>	<2217061.yFV10mnZWq@merkaba> <CAH-HCWVxOA+NBD5ON_D2Np2mC6+PC=n5QCCc410pQC04X7VnxA@mail.gmail.com>
In-Reply-To: <CAH-HCWVxOA+NBD5ON_D2Np2mC6+PC=n5QCCc410pQC04X7VnxA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 22/8/2014 6:40 πμ, Shriramana Sharma wrote:
> Hello people. Thank you for your detailed replies, esp Duncan.
>
> In essence, I plan on using BTRFS for my production data -- mainly
> programs/documents I write in connection with my academic research.
> I'm not a professional sysadmin and I'm not running a business server.
> I'm just managing my own data, and as I have mentioned, my chief
> reason for looking at BTRFS is the ease of snapshots and backups using
> send/receive.
>
> It is clear now that snapshots are by and large stable but
> send/receive is not. But, IIUC, even if send/receive fails I still
> have the older data which is not overwritten due to COW and atomic
> operations, and I can always retry send/receive again. Is this
> correct?
>
> If yes, then I guess I can take the plunge but ensure I have daily
> backups (which BTRFS itself should help me do easily).
>
>
I would stay with rsync for a while, because there is always the 
possibility of a bug that corrupts both your primary filesystem and your 
backup one, or send propagating corruption from one filesystem to 
another (Or maybe I am too paranoid, it would be good if we could have 
the opinion of a btrfs developer on this)

I would also suggest lsyncd if rsync runs become slow due to too many 
files and directories, or you have something like my use case, where i 
have filesystems with millions of files and my backup servers are a few 
km away and reachable over relatively slow wireless links.

Finaly, be sure to use the --inplace option of rsync.

-- 
Konstantinos Skarlatos

