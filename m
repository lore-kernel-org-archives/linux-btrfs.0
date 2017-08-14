Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36783 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdHNNYA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 09:24:00 -0400
Received: by mail-it0-f65.google.com with SMTP id o72so3242288ita.3
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Aug 2017 06:24:00 -0700 (PDT)
Subject: Re: [RFC] Checksum of the parity
To: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <5d703b4c-e8ac-21dc-e327-ff1d8e232ee9@inwind.it>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2aac70ec-cef4-3b5d-b4ef-7b6d94c32489@gmail.com>
Date: Mon, 14 Aug 2017 09:23:54 -0400
MIME-Version: 1.0
In-Reply-To: <5d703b4c-e8ac-21dc-e327-ff1d8e232ee9@inwind.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-13 10:16, Goffredo Baroncelli wrote:
> Hi all,
> 
> in the BTRFS wiki, in the status page, in the "line" RAID5/6 it is reported that the parity is not checksummed. This was reported several time in the ML and also on other site (e.g. phoronix) as a BTRFS defect.
> 
> However I was unable to understand it, and I am supposing that this is a false mith.
> 
> So my question is: the fact that in the BTRFS5/6 the parity is not checksummed could be considered a defect ?
> 
> My goal is to verify if there is a rationale to require the parity checksummed, and if no I would like to remove this from the wiki.

While there isn't for normal operation (as Chris did a good job of 
explaining), there is a benefit for scrubbing the filesystem.

Without checksummed parity, you have to verify checksums on all the 
data, and then either recompute and compare the parity, or recompute and 
compare the data from parity to be able to verify that everything is 
correct.

With checksummed parity you just verify checksums on everything.

So, overall, I wouldn't consider it a defect, but having it could 
improve performance for a very specific use case.
