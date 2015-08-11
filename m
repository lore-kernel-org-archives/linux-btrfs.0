Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:37841 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbbHKSEV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 14:04:21 -0400
Received: by igbpg9 with SMTP id pg9so97062390igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2015 11:04:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
	<CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
	<CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
	<CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
Date: Tue, 11 Aug 2015 14:04:20 -0400
Message-ID: <CAK7bmU_xV=2Mh0zj6c3Wj54HDi0vCWmon-Z9E6h14hGws2-YAg@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Timothy Normand Miller <theosib@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 11, 2015 at 1:56 PM, Timothy Normand Miller
<theosib@gmail.com> wrote:
> On Tue, Aug 11, 2015 at 12:21 AM, Chris Murphy <lists@colorremedies.com> wrote:

>> The entire dmesg is still useful because it should show libata errors
>> if these aren't fully failed drives. So you should file a bug and
>> include, literally, the entire unedited dmesg.
>
> Alright, I'll do that.  Thanks!
>

Here you go:

https://bugzilla.kernel.org/show_bug.cgi?id=102691

-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
