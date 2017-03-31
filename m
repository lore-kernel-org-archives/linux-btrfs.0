Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55163 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751361AbdCaFiz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 31 Mar 2017 01:38:55 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ctpGm-00075J-Bg
        for linux-btrfs@vger.kernel.org; Fri, 31 Mar 2017 07:38:44 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Shrinking a device - performance?
Date: Fri, 31 Mar 2017 05:38:36 +0000 (UTC)
Message-ID: <pan$76dc7$170a959f$9df83808$fddf3918@cox.net>
References: <1CCB3887-A88C-41C1-A8EA-514146828A42@flyingcircus.io>
        <20170327130730.GN11714@carfax.org.uk>
        <3558CE2F-0B8F-437B-966C-11C1392B81F2@flyingcircus.io>
        <20170327194847.5c0c5545@natsu>
        <4E13254F-FDE8-47F7-A495-53BFED814C81@flyingcircus.io>
        <22746.30348.324000.636753@tree.ty.sabi.co.uk>
        <b0f6b00e-4c70-72d1-8683-c05bb72a0968@siedziba.pl>
        <22749.11946.474065.536986@tree.ty.sabi.co.uk>
        <67132222-17c3-b198-70c1-c3ae0c1cb8e7@siedziba.pl>
        <CAP8EXU2ufgLWL+kgKtaLjqHDBGV1OB8GWy+efCJf4Knb0DaEPQ@mail.gmail.com>
        <pan$5c23$ddaeadec$128532fd$8595ddc4@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Fri, 31 Mar 2017 05:26:39 +0000 as excerpted:

> Compare that to the current thread where someone's trying to do a resize
> of a 20+ TB btrfs and it was looking to take a week, due to the massive
> size and the slow speed of balance on his highly reflinked filesystem on
> spinning rust.

Heh, /this/ thread.  =:^)  I obviously lost track of the thread I was 
replying to.

Which in a way makes the reply even more forceful, as it's obviously 
generically targeted, not just at this thread.  Even if I were so devious 
as to arrange that deliberately (I'm not and I didn't, FWIW, but of 
course if you suspect that than this assurance won't mean much either).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

