Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37314 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752281AbbGFUxs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jul 2015 16:53:48 -0400
Subject: Re: size 2.73TiB used 240.97GiB after balance
To: Donald Pearson <donaldwhpearson@gmail.com>,
        Hugo Mills <hugo@carfax.org.uk>,
        Hendrik Friedel <hendrik@friedels.name>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <559AD4E5.2030107@friedels.name> <559ADAB5.3050804@friedels.name>
 <20150706194932.GE10539@carfax.org.uk>
 <CAC=t97D7p96+x_QQyAwa7c_2-TN0LvrBQ0TX_6B-2-b882JMWQ@mail.gmail.com>
From: Omar Sandoval <osandov@fb.com>
Message-ID: <559AEAAB.4070401@fb.com>
Date: Mon, 6 Jul 2015 13:52:59 -0700
MIME-Version: 1.0
In-Reply-To: <CAC=t97D7p96+x_QQyAwa7c_2-TN0LvrBQ0TX_6B-2-b882JMWQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/06/2015 01:01 PM, Donald Pearson wrote:
> Based on my experience Hugo's advice is critical, get the bad drive
> out of the pool when in raid56 and do not try to replace or delete it
> while it's still attached and recognized.
> 
> If you add a new device, mount degraded and rebalance.  If you don't,
> mount degraded then device delete missing.
> 

Watch out, replacing a missing device in RAID 5/6 currently doesn't work
and will cause a kernel BUG(). See my patch series here:
http://www.spinics.net/lists/linux-btrfs/msg44874.html

-- 
Omar
