Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:53725 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751219AbeA3Tk4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 14:40:56 -0500
Date: Tue, 30 Jan 2018 20:40:54 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180130194054.GA10716@polanet.pl>
References: <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <20180127224200.GA16927@polanet.pl>
 <6b6b8e07-27b2-c181-49dc-3fbd1cd9e023@gmail.com>
 <20180130150950.GB7126@polanet.pl>
 <246588cf-01dd-9754-a96b-9fc44e2fd74d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <246588cf-01dd-9754-a96b-9fc44e2fd74d@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just one final word, as all was already said:

On Tue, Jan 30, 2018 at 11:30:31 -0500, Austin S. Hemmelgarn wrote:

>> In other words, is it:
>> - the systemd that threats btrfs WORSE than distributed filesystems, OR
>> - btrfs that requires from systemd to be threaded BETTER than other fss?
> Or maybe it's both?  I'm more than willing to admit that what BTRFS does 
> expose currently is crap in terms of usability.  The reason it hasn't 
> changed is that we (that is, the BTRFS people and the systemd people) 
> can't agree on what it should look like.

Hard to agree with someone who refuses to do _anything_.

You can choose to follow whatever, MD, LVM, ZFS, invent something
totally different, write custom daemon or put timeout logic inside the
kernel itself. It doesn't matter. You know the ecosystem - it is the
udev that must be signalled somehow and systemd WILL follow.

-- 
Tomasz Pala <gotar@pld-linux.org>
