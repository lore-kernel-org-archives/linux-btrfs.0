Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49519 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbdGDAdO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jul 2017 20:33:14 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dSBm6-0000yg-Ve
        for linux-btrfs@vger.kernel.org; Tue, 04 Jul 2017 02:33:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Deleting mounted subvolumes
Date: Tue, 4 Jul 2017 00:32:59 +0000 (UTC)
Message-ID: <pan$569ab$8d7e22$27d3737a$18b15f95@cox.net>
References: <65603e72-6e30-7be5-1b9c-95c5fe416880@petezilla.co.uk>
        <5ce523e5-72bd-a600-47ae-e781a0d2ccec@mendix.com>
        <a2ec890c-ead0-4f9a-d338-a5a1a804cd28@petezilla.co.uk>
        <5787bb34-0cfa-f074-505b-0c482cc16aee@mendix.com>
        <CAJCQCtSvCUR-TLieEMNMDEQAtB1=nSudzMGoSrRdTjE6uaOHyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 03 Jul 2017 17:21:18 -0600 as excerpted:

> It's more like a bind mount of a directory, as far as what's going on
> under the hood. I take it it's possible to delete a directory that is
> bind mounted elsewhere? I'm not sure what happens though.

Yes, deleting a directory in a rw-mounted bind-mount is possible, as is 
simply modifying an existing file.

What makes this "interesting" is the possibility that either the original 
mount or (at least) one of the bind-mounts is mounted ro, while the one 
you'd delete the directory in would obviously be rw in ordered for it to 
work, making it very possible for the contents of an ro mount to change!

IOW, if there ever was a day when read-only meant unchangeable, that day 
is long gone.  Just because it's read-only does NOT mean it's 
unchangeable!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

