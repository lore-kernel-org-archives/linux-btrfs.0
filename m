Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33682 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbcGGTOb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 15:14:31 -0400
Received: by mail-oi0-f45.google.com with SMTP id u201so36452909oie.0
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 12:14:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS7=bR_r6+u+vSxE7rfUOOwx0G3NTff4=WUbfV3riWVSA@mail.gmail.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de> <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
 <10018aa9-a2e2-dd2a-b8d9-9945e0e170af@gmail.com> <CAA91j0VUTBc8W2CBFQJZFR4RxJAYL1bkw6GTJLsxu9mMBZ4yDw@mail.gmail.com>
 <f3b5493d-456c-f614-7c1b-fd1b6e9977bc@gmail.com> <1E3215A5-EAA9-425D-AE08-B81B57D3043E@gmail.com>
 <93cdc463-8f53-5cf6-055c-05b5359ad814@gmail.com> <fddbc0b3-deb7-8ac8-46c7-bde110206482@inwind.it>
 <de824c8d-f94f-87bd-2bf9-d27b1ff7294a@gmail.com> <CAJCQCtS7=bR_r6+u+vSxE7rfUOOwx0G3NTff4=WUbfV3riWVSA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 7 Jul 2016 13:14:28 -0600
Message-ID: <CAJCQCtRtL7B5OsyaRKgP0hWgt_OO3WrjTB-YCjuUXdtj9uYcPg@mail.gmail.com>
Subject: Re: 64-btrfs.rules and degraded boot
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

More Btrfs udev issues, they involve making btrfs multiple device
volumes via 'btrfs dev add' which then causes problems at boot time.
https://bugzilla.opensuse.org/show_bug.cgi?id=912170
https://bugzilla.suse.com/show_bug.cgi?id=984516

The last part is amusing in that the proposed fix is going to end up
in btrfs-progs. And so that's why:

[chris@f24m ~]$ dnf provides /usr/lib/udev/rules.d/64-btrfs-dm.rules
Last metadata expiration check: 1:18:18 ago on Thu Jul  7 11:54:20 2016.
btrfs-progs-4.6-1.fc25.x86_64 : Userspace programs for btrfs
Repo        : @System

[chris@f24m ~]$ dnf provides /usr/lib/udev/rules.d/64-btrfs.rules
Last metadata expiration check: 1:18:30 ago on Thu Jul  7 11:54:20 2016.
systemd-udev-229-8.fc24.x86_64 : Rule-based device node and kernel event manager
Repo        : @System

Ha. So the btrfs rule is provided by udev upstream. The dm specific
Btrfs rule is provided by Btrfs upstream. That's not confusing at all.


Chris Murphy
