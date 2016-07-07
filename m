Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-36.italiaonline.it ([212.48.25.164]:42579 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751243AbcGGUNI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Jul 2016 16:13:08 -0400
Reply-To: kreijack@inwind.it
Subject: Re: 64-btrfs.rules and degraded boot
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de>
 <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
 <10018aa9-a2e2-dd2a-b8d9-9945e0e170af@gmail.com>
 <CAA91j0VUTBc8W2CBFQJZFR4RxJAYL1bkw6GTJLsxu9mMBZ4yDw@mail.gmail.com>
 <f3b5493d-456c-f614-7c1b-fd1b6e9977bc@gmail.com>
 <1E3215A5-EAA9-425D-AE08-B81B57D3043E@gmail.com>
 <93cdc463-8f53-5cf6-055c-05b5359ad814@gmail.com>
 <fddbc0b3-deb7-8ac8-46c7-bde110206482@inwind.it>
 <de824c8d-f94f-87bd-2bf9-d27b1ff7294a@gmail.com>
 <CAJCQCtS7=bR_r6+u+vSxE7rfUOOwx0G3NTff4=WUbfV3riWVSA@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>, Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <e6209439-e4cc-c8fe-a91f-03772f3965e5@inwind.it>
Date: Thu, 7 Jul 2016 22:13:05 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS7=bR_r6+u+vSxE7rfUOOwx0G3NTff4=WUbfV3riWVSA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-07 20:58, Chris Murphy wrote:
> I get all kinds of damn strange behaviors in GNOME
> with Btrfs multiple device volumes: volume names appearing twice in
> the UI, unmounting one causes umount errors with the other.
> https://fedoraproject.org/wiki/Changes/Replace_UDisks2_by_Storaged
> http://storaged.org/

Unfortunately BTRFS is a mess from this point of view. Some btrfs subcommand query the system inspecting directly the data stored on the disks; others use the ioctl(2) syscall, which provides what the kernel think. Unfortunately, due to the cache, these two kind of source of information are out of sync. 

Often, when some command output don't convince me, I do some "sync"; then repeating the command the output is better ("btrfs fi show" is one of these commands).

BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
