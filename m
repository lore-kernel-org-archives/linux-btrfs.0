Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33753 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbbHMWcr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 18:32:47 -0400
Received: by wijp15 with SMTP id p15so1299486wij.0
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Aug 2015 15:32:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55CC830D.2070304@gmail.com>
References: <20150812130758.GA26529@rus.uni-stuttgart.de>
	<55CC830D.2070304@gmail.com>
Date: Fri, 14 Aug 2015 08:32:46 +1000
Message-ID: <CA+WRLO9ZbjZyNnMM951xrkE5OqymO3E8gMeebOpkX1a4qCS+6g@mail.gmail.com>
Subject: Re: RAID0 wrong (raw) device?
From: Gareth Pye <gareth@cerberos.id.au>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Ulli Horlacher <framstag@rus.uni-stuttgart.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 13, 2015 at 9:44 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> 3. See the warnings about doing block level copies and LVM snapshots of
> BTRFS volumes, the same applies to using it on DRBD currently as well (with
> the possible exception of remote DRBD nodes (ie, ones without a local copy
> of the backing store) (in this case, we need to blacklist backing devices
> for stacked storage (I think the same issue may be present with BTRFS on a
> MD based RAID1 set).


I've been using BTRFS on top of DRBD for several years now, what
specifically am I meant to avoid?

I have 6 drives mirrored across a local network, this is done with DRBD.
At any one time only a single server has the 6 drives mounted with btrfs.
Is this a ticking time bomb?

-- 
Gareth Pye - blog.cerberos.id.au
Level 2 MTG Judge, Melbourne, Australia
"Dear God, I would like to file a bug report"
