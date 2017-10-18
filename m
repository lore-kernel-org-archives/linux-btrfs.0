Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60790 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S933581AbdJREvV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 00:51:21 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e4gJu-0006Jr-Py
        for linux-btrfs@vger.kernel.org; Wed, 18 Oct 2017 06:51:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
Date: Wed, 18 Oct 2017 04:50:53 +0000 (UTC)
Message-ID: <pan$70e87$46a69ce1$42506b71$a7d5710b@cox.net>
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
        <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
        <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com>
        <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
        <d15a82aa-7d6e-ba36-76cc-8771e0359379@gmail.com>
        <20171017011443.bupcsskm7joc73wb@angband.pl>
        <e8497dd4-7341-a708-7828-282001738a95@gmail.com>
        <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
        <81e1136a-a846-9531-b1bf-9ad2aabb785d@gmail.com>
        <20171017170626.amfrohfyqlujdueu@angband.pl>
        <1d5e9875-1c1e-f67e-1f5b-0741555d9517@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 17 Oct 2017 15:19:09 -0400 as
excerpted:

>> It's a single-device filesystem, thus disconnects are obviously fatal. 
>> But,
>> they never caused even a single bit of damage (as scrub goes), thus
>> proving btrfs handles this kind of disconnects well.  Unlike times
>> past, the kernel doesn't get confused thus no reboot is needed, merely
>> an unmount, "service nbd-client restart", mount, restart the rebuild
>> jobs.
> That's expected behavior though.  _Single_ device BTRFS has nothing to
> get out of sync most of the time, the only time there's any possibility
> of an issue is when you die after writing the first copy of a block
> that's in a dup profile chunk, but even that is not very likely to cause
> problems (you'll just lose at most the last <commit-time> worth of
> data).  The moment you add another device though, that simplicity goes
> out the window.

This is why I said if you /must/ work with USB-connected devices, I'd 
suggest single-device btrfs, tho I'd go full dup (data too) to take 
advantage of the btrfs ability to detect checksum errors and rewrite a 
bad copy from the second, hopefully good, copy.

Single device simply doesn't have the sync issues of multi-device, even 
in dup mode, so end up being much more reliable in cases like USB 
connection (and NBD as in the example above), where connection 
reliability is a problem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

