Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33500 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1753986AbeE1Id1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 04:33:27 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fNDYf-0008LA-K0
        for linux-btrfs@vger.kernel.org; Mon, 28 May 2018 10:31:13 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID-1 refuses to balance large drive
Date: Mon, 28 May 2018 08:31:06 +0000 (UTC)
Message-ID: <pan$6e298$9a312851$f255783a$40f84a09@cox.net>
References: <56F1E7BE.1000004@gmail.com>
        <CAJCQCtSiPeHE7QimeJyz4Y760saeFB7Enn2YceA3r-Z9eZmA_g@mail.gmail.com>
        <56F2C991.9080500@gmail.com>
        <CAJCQCtRgCvUPEMVXfQpJ+wdW_9jL3rijzuinPfiyRV3rTFEsKA@mail.gmail.com>
        <56F2EA25.4070004@gmail.com>
        <CAJCQCtQ7YwtBcvq9H1e1Ma8WEKB4o2ni40yOE9f1KMr0u6rX_w@mail.gmail.com>
        <CAA7pwKNjyRRoXGV0djzjgXX7HQ2MY8mhQFj8_7TsfYeKkge-2g@mail.gmail.com>
        <CAPmG0jbUWiDNSVjv9hMF3rpe0cm4EZWkuRKEgM_t6EuU3sPYFA@mail.gmail.com>
        <CAHz9+Emc4DsXoMLKYrp1TfN+2r2cXxaJmPyTnpeCZF=h0FhtMg@mail.gmail.com>
        <CAHz9+En8h8mX1OorR1Nyvf3iwHxmZRt02ufi-Je-jGsV1Nx+sw@mail.gmail.com>
        <f773a802-67a3-f148-5d36-fa8a9d168e25@gmx.com>
        <CAHz9+EkeAAOXN7K+C0Wtmu-3RPOpTC4a6pK-y5gDQCtdAc8nUA@mail.gmail.com>
        <6dc280f8-3822-078e-9b69-c3203e75ec1e@gmx.com>
        <CAHz9+EkzNkAiP4CSZCiAbTrsKik0SGS9OQ=C4TSfwtB8Rb3zvA@mail.gmail.com>
        <c8077032-58ea-da5b-ea62-6007d837e666@gmx.com>
        <CAHz9+EkB64Y-ZT37Y-Bu=HXcw-FELW4GNGf+G-fC9MPXa3WvBg@mail.gmail.com>
        <CAHz9+En7ZwTTY5xi_vkNjsbir6NqKt_zN1_6qPud66QRT9e2iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brad Templeton posted on Sun, 27 May 2018 11:22:07 -0700 as excerpted:

> BTW, I decided to follow the original double replace strategy suggested 
--
> replace 6TB with 8TB and replace 4TB with 6TB.  That should be sure to
> leave the 2 large drives each with 2TB free once expanded, and thus able
> to fully use all space.
> 
> However, the first one has been going for 9 hours and is "189.7% done" 
> and still going.   Some sort of bug in calculating the completion
> status, obviously.  With luck 200% will be enough?

IIRC there was an over-100% completion status bug fixed, I'd guess about 
18 months to two years ago now, long enough it would have slipped 
regular's minds so nobody would have thought about it even knowing you're 
still on 4.4, that being one of the reasons we don't do as well 
supporting stuff that old.

If it is indeed the same bug, anything even half modern should have it 
fixed

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

