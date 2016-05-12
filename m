Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:54595 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751111AbcELVxl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 17:53:41 -0400
Reply-To: kreijack@inwind.it
Subject: Re: BTRFS Data at Rest File Corruption
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
 <97b8a0bd-3707-c7d6-4138-c8fe81937b72@gmail.com>
 <1463075341.3636.56.camel@clone1.com>
 <ebe609bb-3ce6-b929-97ef-ad323a254dc7@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        "Richard A. Lochner" <lochner@clone1.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <5734FB61.4060003@inwind.it>
Date: Thu, 12 May 2016 23:53:37 +0200
MIME-Version: 1.0
In-Reply-To: <ebe609bb-3ce6-b929-97ef-ad323a254dc7@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-05-12 20:29, Austin S. Hemmelgarn wrote:
>> I wonder if there is a way to correct or detect that situation.
> The closest we could get is to provide an option to handle this in
> scrub, preferably with a big scary warning on it as this same
> situation can be easily cause by someone modifying the disks
> themselves (we can't reasonably protect against that, but we
> shouldn't make it trivial for people to inject arbitrary data that
> way either).

"btrfs check" has the option "--init-csum-tree"...

Anyway, it should be exist an option to recalculate the checksum for a single file. BTRFS is good to highlight that a file is corrupted, but it should have the possibility to read it anyway: in some case is better to have a corrupted file (knowing that it is corrupted) that loosing all the file.

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
