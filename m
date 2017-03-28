Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47228 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752785AbdC1FVn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Mar 2017 01:21:43 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1csjZO-0003SQ-BS
        for linux-btrfs@vger.kernel.org; Tue, 28 Mar 2017 07:21:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Qgroups are not applied when snapshotting a subvol?
Date: Tue, 28 Mar 2017 05:21:11 +0000 (UTC)
Message-ID: <pan$757c1$9ad205c8$395a3c06$45da3ed0@cox.net>
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
        <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com>
        <2e816c46-7a6a-7db9-a2c3-663dc7d8e6c9@gmail.com>
        <8c55c034-27cc-e8b5-5317-b388cc6492f4@cn.fujitsu.com>
        <e57c6cc8-4943-a93a-f568-d3654d341b65@sichert.me>
        <6e464739-5540-87ab-a46d-954a06086cba@gmail.com>
        <CAJCQCtRikr0CaYRj1rQid-UPukNm6NXem_8QD_e-VZYoZ3HPWA@mail.gmail.com>
        <20170328005358.5d5366ef@natsu>
        <5236e403-6f41-aae1-6e8a-ab04e3b98c89@mendix.com>
        <CAJCQCtTOX6p03hPi6CJyzPKmFQMfP4oSCzbrkjftU=Sm9LdjPA@mail.gmail.com>
        <pan$4c68e$4d5b137e$7fa9a653$88273853@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Tue, 28 Mar 2017 02:41:52 +0000 as excerpted:

> Which in usual terms means making the perms root-only, with the binary
> set to some controlled-access group and set-SUID-root (or appropriate
> security attributes, I'm drawing a blank on the word I want ATM), and
> then letting the admin control access via group membership.

File capacities (what was eluding me).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

