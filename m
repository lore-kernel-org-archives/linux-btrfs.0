Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45475 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758770AbcAKJqk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 04:46:40 -0500
Subject: Re: btrfs fail behavior when a device vanishes
To: Chris Murphy <lists@colorremedies.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
References: <CAJCQCtQxFm5L-RtP9Ph8qaYtG0jVo3PfrHj6U35LJSStB5pyuQ@mail.gmail.com>
 <CAN05THS2=MFKwETJMPDz_FntDVFwfgbaY4Aros9=B4rhOF91qQ@mail.gmail.com>
 <CAN05THSvLdPvt9LmM4TLG-JWBQdRKNtEjrAkTX9jjL6r8kG8pA@mail.gmail.com>
 <CAJCQCtQ5Df8p4gJwBDLAF0HgKg9HNiNVbphn9=ao3To8CvkRkQ@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <569379F1.2060208@oracle.com>
Date: Mon, 11 Jan 2016 17:46:25 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ5Df8p4gJwBDLAF0HgKg9HNiNVbphn9=ao3To8CvkRkQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> Already we know that Btrfs tries to write indefinitely to missing
> devices.

(sorry for the late reply, now back from vacation).
The below and its related patch will take care of it, if when
critical IO fails it can bring the device to an offline / failed
state, so that it prevents further IOs to it.

  [PATCH 07/15] btrfs: introduce device dynamic state transition to 
offline or failed

  Further this could provide btrfs sysfs user interface so that
  externally device error monitoring scripts can bring the device
  offline / failed. (we need to settle the sysfs framework and
  patchset to add that sysfs interface).

> If it reappears, what gets written? Will that device be
> consistent?

  Yep that part of the error handling isn't present. The workaround
for it is to use the remount. (sorry if certain setup considers
remount as not suitable). However this kind of the user involved
recovery option is safe from the intermittently failing devices,
which may lead to a messy situation as you mentioned.

Thanks, Anand
