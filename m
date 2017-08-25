Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36-i6.italiaonline.it ([212.48.14.170]:58856 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754622AbdHYNxQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 09:53:16 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 00/14 RFC] Btrfs: Add journal for raid5/6 writes
To: Chris Murphy <lists@colorremedies.com>, Liu Bo <bo.li.liu@oracle.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20170801161439.13426-1-bo.li.liu@oracle.com>
 <ac334d78-77e1-081d-1cf0-48e36e25268f@libero.it>
 <20170801172411.GE26357@localhost.localdomain>
 <dc65edc8-82bd-ac1b-fa90-6076bea13df9@inwind.it>
 <20170802175738.GA12533@localhost.localdomain>
 <91f2f70c-151d-d0ff-1acf-c5eb55e4fc9c@inwind.it>
 <20170802202720.GB12533@localhost.localdomain>
 <CAJCQCtRrGRgU0u3+qU1pMgsyLfhOWHDrF6CCgVc8c9+JsLuoow@mail.gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <4bbd8148-6cc1-cfaf-4cc3-25f711a3555e@inwind.it>
Date: Fri, 25 Aug 2017 15:53:09 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRrGRgU0u3+qU1pMgsyLfhOWHDrF6CCgVc8c9+JsLuoow@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/23/2017 05:28 PM, Chris Murphy wrote:
> - dynamically sized stripes, so that writes can always be full stripe
> writes, no overwrites, and atomic
Think about also that a block could be deallocated (i.e. canceling a file of 4kb). This leads to have some holes that you cannot fill without a RMW cycle...

BR

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
