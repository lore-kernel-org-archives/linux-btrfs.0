Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54351 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbaAUSD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jan 2014 13:03:28 -0500
Received: by mail-pd0-f175.google.com with SMTP id w10so3236748pde.34
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jan 2014 10:03:27 -0800 (PST)
Received: from [10.2.10.160] (206.214.244.2.epikip.net. [206.214.244.2])
        by mx.google.com with ESMTPSA id pe3sm14409874pbc.23.2014.01.21.10.03.27
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Tue, 21 Jan 2014 10:03:27 -0800 (PST)
From: Graham Fleming <graham.fleming@gmail.com>
Content-Type: text/plain; charset=us-ascii
Subject: RE: Scrubbing with BTRFS Raid 5
Message-Id: <DC8CDADE-5C7A-4DA3-8081-EB631136621B@gmail.com>
Date: Tue, 21 Jan 2014 10:03:26 -0800
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks again for the added info; very helpful.

I want to keep playing around with BTRFSS RAID 5 and testing with it... assuming I have a drive with bad blocks, or let's say some inconsistent parity am I right in assuming that a) a btrfs scrub operation will not fix the stripes with bad parity and b) a balance operation will not be successful? Or would a balance operation work to re-write parity?