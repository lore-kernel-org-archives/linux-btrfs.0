Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34.italiaonline.it ([212.48.25.162]:48437 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751121AbdBXRjX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Feb 2017 12:39:23 -0500
Reply-To: kreijack@inwind.it
Subject: Re: List of corruption cases for scrub
References: <20170224023225.GA4006@giis.co.in>
To: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>, linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <9a5fb7b9-76b3-9848-9c29-8d4aac3fdb7b@libero.it>
Date: Fri, 24 Feb 2017 18:39:20 +0100
MIME-Version: 1.0
In-Reply-To: <20170224023225.GA4006@giis.co.in>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
On 2017-02-24 03:32, Lakshmipathi.G wrote:
> Hi.
> 
> I tried to a create list of corruption test scenarios for scrubbing process with RAID5.
> Here's the list: https://btrfs.wiki.kernel.org/index.php/Scrub_corruption_cases
> 
> If similar list already exists in btrfs wiki, let me know, I'll move this data
> to there. Feel free to add/update/delete entries or suggest new corrupt ideas!

Thanks for doing that. About the test "Device-corruption", I suppose that you want to test a scenario where one disk fails. If so you do not have to always corrupt "D0" block, but the first block of the file which is stored in the failing disk (which could be different from the D0).

Another scenario which should be tested, is the reshaping of the raid: add a drive (or remove a drive) then re-balance the system (with or without some corruption). IIRC this use the same scrub code.

> 
> Cheers.
> Lakshmipathi.G
> --


BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
