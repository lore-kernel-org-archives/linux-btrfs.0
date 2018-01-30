Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pepin.polanet.pl ([193.34.52.2]:49097 "EHLO pepin.polanet.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751651AbeA3QW5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Jan 2018 11:22:57 -0500
Date: Tue, 30 Jan 2018 17:22:55 +0100
From: Tomasz Pala <gotar@polanet.pl>
To: "Majordomo vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: degraded permanent mount option
Message-ID: <20180130162255.GA28192@polanet.pl>
References: <1517035210.1252874.1249880112.19FABD13@webmail.messagingengine.com>
 <8607255b-98e7-5623-6f62-75d6f7cf23db@gmail.com>
 <569AC15F-174E-4C78-8FE5-6CE9E0BED479@yayon.me>
 <E23AAC7C-6CAA-4290-9CF1-19285DB31D05@yayon.me>
 <111ca301-f631-694d-93eb-b73a790f57d4@gmail.com>
 <20180127110619.GA10472@polanet.pl>
 <20180127132641.mhmdhpokqrahgd4n@angband.pl>
 <20180127224200.GA16927@polanet.pl>
 <6b6b8e07-27b2-c181-49dc-3fbd1cd9e023@gmail.com>
 <20180130150950.GB7126@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
In-Reply-To: <20180130150950.GB7126@polanet.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 30, 2018 at 16:09:50 +0100, Tomasz Pala wrote:

>> BCP for over a 
>> decade has been to put multipathing at the bottom, then crypto, then 
>> software RAID, than LVM, and then whatever filesystem you're using. 
> 
> Really? Let's enumerate some caveats of this:
> 
> - crypto below software RAID means double-encryption (wasted CPU),
> 
> - RAID below LVM means you're stuck with the same RAID-profile for all
>   the VGs. What if I want 3-way RAID1+0 for crucial data, RAID1 for
>   system and RAID0 for various system caches (like ccache on software
>   builder machine) or transient LVM-level snapshots.
> 
> - RAID below filesystem means loosing btrfs-RAID extra functionality,
>   like recovering data from different mirror when CRC mismatch happens,
> 
> - crypto below LVN means encrypting everything, including data that is
>   not sensitive - more CPU wasted,

And, what is much worse - encrypting everything using the same secret.
BIG show-stopper.

I would shred such BCP as ineffective and insecure for both, data
integrity and confidentiality.

> - RAID below LVM means no way to use SSD acceleration of part of the HDD
>   space using MD write-mostly functionality.

-- 
Tomasz Pala <gotar@pld-linux.org>
