Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:45528 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751729AbcLIOHH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Dec 2016 09:07:07 -0500
Subject: Re: duperemove : some real world figures on BTRFS deduplication
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs@vger.kernel.org
References: <81bcff57-4bee-18d5-cac4-3359150730a5@petaramesh.org>
 <930fe4c7-b936-8f2d-fc4c-cc5574c27f19@suse.com>
From: =?UTF-8?Q?Sw=c3=a2mi_Petaramesh?= <swami@petaramesh.org>
Message-ID: <7790b5bf-5561-5b68-d4b1-69230d5394c3@petaramesh.org>
Date: Fri, 9 Dec 2016 15:06:55 +0100
MIME-Version: 1.0
In-Reply-To: <930fe4c7-b936-8f2d-fc4c-cc5574c27f19@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff, thanks for your reply,


On 12/08/2016 09:07 PM, Jeff Mahoney wrote:
> What version were you using? 
That's v0.11.beta4, installed rather recently
> What throughput are you getting to that disk?  I get that it's USB3, but
> reading 1TB doesn't take a terribly long time so 15 days is pretty
> ridiculous.
This is run from inside a VM, onto a physical USB3 HD. Copying to/from
this HD shows a speed that corresponds to what I would expect on the
same HD connected to a physical (not virtual) setup.

The only quick data that I can get are from "hdparm", that says :

- Timed cached reads : 5976 MB/sec
- Timed buffered disk reads : 105 MB/sec

Kind regards.

ॐ

-- 
Swâmi Petaramesh <swami@petaramesh.org> PGP 9076E32E

