Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48837 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750880AbdBQINq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 03:13:46 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cedfd-00065k-H1
        for linux-btrfs@vger.kernel.org; Fri, 17 Feb 2017 09:13:37 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: stat(2) returning device ID not existing in mountinfo
Date: Fri, 17 Feb 2017 08:13:26 +0000 (UTC)
Message-ID: <pan$f1d62$6c5d9aea$6878f47$b58d3485@cox.net>
References: <1474057691.16275.16.camel@xiaoka.com>
        <d5df5a17-fb7f-80a2-9308-66fe0e5335f3@suse.com>
        <925b4337-2de3-32fc-624f-ed67dd0eb8f2@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: findutils-patches@gnu.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Wed, 15 Feb 2017 19:25:57 +0100 as
excerpted:

> (Resended because I don saw it in the mailing lists)
> 
> -----
> Hi,
> 
> I want to highlight this bug another time.
> 
> I encountered this bug, when I was looking to a problem with find. I my
> machine find took an huge quantity of memory (up to 3GB) when used by
> updatedb.

FWIW, I saw it (via news.gmane.org list2news service) here.  It's well 
over my head, tho, so I didn't reply, but I found it interesting.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

