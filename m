Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:42217 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaLSB5Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Dec 2014 20:57:16 -0500
Received: by mail-ob0-f169.google.com with SMTP id vb8so9562347obc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Dec 2014 17:57:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAN6BF2LwtJkjt1qB6C-wcVxizGj4bufvojR29QX5e7JJ_h-xXA@mail.gmail.com>
References: <CAN6BF2LwtJkjt1qB6C-wcVxizGj4bufvojR29QX5e7JJ_h-xXA@mail.gmail.com>
Date: Thu, 18 Dec 2014 18:57:15 -0700
Message-ID: <CAJCQCtR=1atHwyn3563nhQCnFyd2Ra99S2ps8Y11=6qfau-onw@mail.gmail.com>
Subject: Re: Extra info
From: Chris Murphy <lists@colorremedies.com>
To: Daniele Testa <daniele.testa@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The other thing going on here is that every write is going to be COW,
which isn't ideal for VM images. Another thing that I wonder is what
SSD this is and if it's supporting deterministic TRIM, since discard
is enabled. And I'm not sure that md by default is passing down trim
(?). This is on md raid? What level? If it's 56 then there's a
separate enabler for raid56 discard. In general if this isn't an SSD
that supports queued trim commands you're better off without discard
mount option and just running fstrim manually once a week or even once
a day is OK if it's a very busy SSD, just schedule it for a time when
it's typically idle.

Chris Murphy
