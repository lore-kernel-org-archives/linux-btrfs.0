Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:59342 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752496AbeBKRZe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Feb 2018 12:25:34 -0500
Date: Sun, 11 Feb 2018 18:25:22 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        "Ellis H. Wilson III" <ellisw@panasas.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs-cleaner / snapshot performance analysis
Message-ID: <20180211172522.szfeavra6qd3jqru@angband.pl>
References: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
 <96cd9e57-cde4-5bc4-0312-02b54668e59a@mendix.com>
 <76e7f364-62b9-5ef1-a8ed-f6fb9e534963@panasas.com>
 <13d35a99-98ef-5861-3b44-17428d999a7c@mendix.com>
 <437ef3be-58ef-9195-0422-113b5fd17bff@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <437ef3be-58ef-9195-0422-113b5fd17bff@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 11, 2018 at 12:31:42PM +0300, Andrei Borzenkov wrote:
> 11.02.2018 04:02, Hans van Kranenburg пишет:
> >> - /dev/sda6 / btrfs
> >> rw,relatime,ssd,space_cache,subvolid=259,subvol=/@/.snapshots/1/snapshot
> >> 0 0
> > 
> > Note that changes on atime cause writes to metadata, which means cowing
> > metadata blocks and unsharing them from a previous snapshot, only when
> > using the filesystem, not even when changing things (!).
> 
> With relatime atime is updated only once after file was changed. So your
> description is not entirely accurate and things should not be that
> dramatic unless files are continuously being changed.

Alas, that's untrue.  relatime updates happen if:
* the file has been written after it was last read, or
* previous atime was older than 24 hours

Thus, you get at least one unshare per inode per day, which is also the most
widespread frequency of both snapshotting and cronjobs.

Fortunately, most uses of atime are gone, thus it's generally safe to
disable it completely.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ The bill with 3 years prison for mentioning Polish concentration
⣾⠁⢰⠒⠀⣿⡁ camps is back.  What about KL Warschau (operating until 1956)?
⢿⡄⠘⠷⠚⠋⠀ Zgoda?  Łambinowice?  Most ex-German KLs?  If those were "soviet
⠈⠳⣄⠀⠀⠀⠀ puppets", Bereza Kartuska?  Sikorski's camps in UK (thanks Brits!)?
