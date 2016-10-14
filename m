Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49999 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S932853AbcJNVUL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 17:20:11 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bv9tc-0000M6-Gc
        for linux-btrfs@vger.kernel.org; Fri, 14 Oct 2016 23:20:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID system with adaption to changed number of disks
Date: Fri, 14 Oct 2016 21:19:40 +0000 (UTC)
Message-ID: <pan$dceb8$140ac377$172f0cb7$9cba8307@cox.net>
References: <20161011160601.GI7683@carfax.org.uk>
        <CAJCQCtSY2Y5AsW2FC5FGP3x3Vaz6Y10=EbAE-0FKFQAqg0oGkg@mail.gmail.com>
        <3da9a459-c63b-570c-5b42-c7186b3a74fd@cn.fujitsu.com>
        <20161012043718.GW21290@hungrycats.org>
        <37578baa-556b-d3f7-45bd-10843124dea1@cn.fujitsu.com>
        <20161012171936.GD26140@hungrycats.org>
        <16a02312-a74c-6e2d-08ae-7fa479823341@cn.fujitsu.com>
        <20161013210346.GY21290@hungrycats.org>
        <d1646e74-004d-737f-671a-4ca30f518819@cn.fujitsu.com>
        <CAJCQCtRxN+5+8Kfr8TM8+gVx62CUQ+Vhkiz7auWJa_tYKZVsXA@mail.gmail.com>
        <20161014195544.GZ21290@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zygo Blaxell posted on Fri, 14 Oct 2016 15:55:45 -0400 as excerpted:

> The current btrfs raid5 implementation is a thin layer of bugs on top of
> code that is still missing critical pieces.  There is no mechanism to
> prevent RMW-related failures combined with zero tolerance for
> RMW-related failures in metadata, so I expect a btrfs filesystem using
> raid5 metadata to be extremely fragile.  Failure is not likely--it's
> *inevitable*.

Wow, that's a signature-quality quote reflecting just how dire the 
situation with btrfs parity-raid is ATM.  First sentence for a short sig, 
full paragraph for a longer one.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

