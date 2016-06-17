Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33881 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbcFQWUt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jun 2016 18:20:49 -0400
Received: by mail-oi0-f51.google.com with SMTP id d132so136780133oig.1
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jun 2016 15:20:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ8yPE5CSyrZ2k0ZCT6Wp5VYo9iSxe9znKv=Q04cXzODw@mail.gmail.com>
References: <1970914.zjZ5YKPDft@whitehead.beowulf.uwo.ca>
	<CAJCQCtTcns_Oq=ku2zx_Dhm8hbfJBDzj57ybDLDZ2=fQ1W0Vow@mail.gmail.com>
	<25284905.4oL6MYjT0a@whitehead.beowulf.uwo.ca>
	<CAJCQCtQ8yPE5CSyrZ2k0ZCT6Wp5VYo9iSxe9znKv=Q04cXzODw@mail.gmail.com>
Date: Fri, 17 Jun 2016 16:20:48 -0600
Message-ID: <CAJCQCtTttYHH1302Yp1KOjNhNngf47eiT8Pzkij_tkDaLDSNCw@mail.gmail.com>
Subject: Re: Scrub aborts on newer kernels
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Tyson Whitehead <twhitehead@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 'journalctl -b -o short-monotonic'

-b is for the current boot. So either reproduce the problem and use
-b, or you can actually track down the boot when the scrubbing failed
with journalctl --list-boots and use -b -1, -b -2, and so on, to get
the journal for prior boots.


-- 
Chris Murphy
