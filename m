Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:33189 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbbJOFGm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 01:06:42 -0400
Received: by igbkq10 with SMTP id kq10so6839197igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 22:06:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+LE0jzBX8kN1NmQ-+8zUpxrB79oMEmpmzUGABYfeA_tX47jBA@mail.gmail.com>
References: <CA+LE0jzBX8kN1NmQ-+8zUpxrB79oMEmpmzUGABYfeA_tX47jBA@mail.gmail.com>
Date: Wed, 14 Oct 2015 23:06:41 -0600
Message-ID: <CAJCQCtT2zpaXRr+i3rqjwdPjmvfcVE-iG564Q6P_ZbY7MkLFqw@mail.gmail.com>
Subject: Re: BTRFS raid 5/6 status
From: Chris Murphy <lists@colorremedies.com>
To: audio muze <audiomuze@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

See the other recent thread on the list "RAID6 stable enough for production?"

A lot of your questions have already been answered in recent previous threads.

While there are advantages to Btrfs raid56, there are some missing
parts that make it incomplete and possibly unworkable for certain use
cases. For example there's no notification of device failures like md
and LVM raid. If there's a device failure, and then also any other
problem crops up, the whole file system can become unusable. So
whatever your backup strategy is going to be, it needs to be even more
bulletproof if you're going to depend on Btrfs for production.


-- 
Chris Murphy
