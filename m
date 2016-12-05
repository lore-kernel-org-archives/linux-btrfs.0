Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47028 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751086AbcLELvg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 06:51:36 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cDrns-0006K3-Jf
        for linux-btrfs@vger.kernel.org; Mon, 05 Dec 2016 12:51:28 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Metadata balance fails ENOSPC
Date: Mon, 5 Dec 2016 11:51:18 +0000 (UTC)
Message-ID: <pan$d30bd$9f6e479e$48969f15$6982ee22@cox.net>
References: <04e767a6-ff6f-95ba-f2f9-6061035dcd10@profihost.ag>
        <CAJCQCtQJV5jCLbON3Fk+DHCztRqAVN35rfMcHiWKWRT3yg+c_A@mail.gmail.com>
        <af47955b-19a4-7ff5-8d88-d94f40300e65@profihost.ag>
        <CAA91j0WLve+R5VBHkb7p2NO_hTuLcRp5KvjsPmnZgOoF1MTWzA@mail.gmail.com>
        <a4b76eec-8967-e7f6-544b-8b05f362c585@mendix.com>
        <abf74fc8-3198-8987-bb32-2fb61199f88a@profihost.ag>
        <CAJCQCtTyAGFvVU2BHXzaJNLC-OAT-LTTjemizAw8GtM=-ycwLg@mail.gmail.com>
        <7f3285e4-e6d3-8db7-15c3-9c93e3dfe95b@gmail.com>
        <697340c2-cf0a-6799-f8e5-f550a0d998b0@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stefan Priebe - Profihost AG posted on Mon, 05 Dec 2016 12:12:12 +0100 as
excerpted:

> isn't there a way to move free space to unallocated space again?

Yes, btrfs balance, but...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

