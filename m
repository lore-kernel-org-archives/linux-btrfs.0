Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:63832 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576AbaHVDk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 23:40:56 -0400
Received: by mail-qa0-f43.google.com with SMTP id w8so9368248qac.30
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Aug 2014 20:40:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2217061.yFV10mnZWq@merkaba>
References: <CAH-HCWVZPNkc7ycsL4jH0i6niVU3nqZiB2MLD6CfP85FckAg7g@mail.gmail.com>
	<2217061.yFV10mnZWq@merkaba>
Date: Fri, 22 Aug 2014 09:10:55 +0530
Message-ID: <CAH-HCWVxOA+NBD5ON_D2Np2mC6+PC=n5QCCc410pQC04X7VnxA@mail.gmail.com>
Subject: Re: Significance of high number of mails on this list?
From: Shriramana Sharma <samjnaa@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello people. Thank you for your detailed replies, esp Duncan.

In essence, I plan on using BTRFS for my production data -- mainly
programs/documents I write in connection with my academic research.
I'm not a professional sysadmin and I'm not running a business server.
I'm just managing my own data, and as I have mentioned, my chief
reason for looking at BTRFS is the ease of snapshots and backups using
send/receive.

It is clear now that snapshots are by and large stable but
send/receive is not. But, IIUC, even if send/receive fails I still
have the older data which is not overwritten due to COW and atomic
operations, and I can always retry send/receive again. Is this
correct?

If yes, then I guess I can take the plunge but ensure I have daily
backups (which BTRFS itself should help me do easily).


-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
