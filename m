Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from capsec.org ([46.4.123.73]:48380 "EHLO mail.capsec.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751001AbdBFJOQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Feb 2017 04:14:16 -0500
Mime-Version: 1.0
Date: Mon, 06 Feb 2017 09:14:40 +0000
Content-Type: text/plain; charset="utf-8"
Message-ID: <22abce5d39112d2223580b19b1adc4df@85337f6d4fa4>
From: "Jorg Bornschein" <jb@capsec.org>
Subject: Re: Very slow balance / btrfs-transaction
To: "Qu Wenruo" <quwenruo@cn.fujitsu.com>,
        "Goldwyn Rodrigues" <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org
In-Reply-To: <57259b63-2f26-0da4-16f6-5fbd781daeb0@cn.fujitsu.com>
References: <57259b63-2f26-0da4-16f6-5fbd781daeb0@cn.fujitsu.com>
 <fce777cb-027f-532b-76ab-24a1e5c2cf7c@suse.de>
 <507c32d4-929c-b691-6196-103c8cb9addb@suse.com>
 <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf>
 <8999d95dac21ea8e2908c5012e50c59b@88cbed2449cf>
 <f9e2b226440e4f6e17e61ce86eecc7eb@88cbed2449cf>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

February 6, 2017 1:45 AM, "Qu Wenruo" <quwenruo@cn.fujitsu.com> 

> Would you please provide the kernel version?
> 
> v4.9 introduced a bad fix for qgroup balance, which doesn't completely fix qgroup bytes leaking,
> but also hugely slow down the balance process:
>

I'm a bit behind the times: 4.8.13-1-ARCH



   j
