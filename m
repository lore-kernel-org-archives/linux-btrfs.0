Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36436 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbdHPN4F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 09:56:05 -0400
Received: by mail-it0-f68.google.com with SMTP id o72so2435966ita.3
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 06:56:05 -0700 (PDT)
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net> <20170812074248.GA3352@infradead.org>
 <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <1502713484.3608.1.camel@scientia.net>
 <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
 <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net>
 <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
 <1502740488.5384.5.camel@scientia.net>
 <20170816131230.GA28619@clm-mbp.thefacebook.com>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f42da288-8f9b-6c1a-fd91-b34dc2bf7f59@gmail.com>
Date: Wed, 16 Aug 2017 09:56:01 -0400
MIME-Version: 1.0
In-Reply-To: <20170816131230.GA28619@clm-mbp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-16 09:12, Chris Mason wrote:
> My real goal is to make COW fast enough that we can leave it on for the 
> database applications too.  Obviously I haven't quite finished that one 
> yet ;) But I'd rather keep the building block of all the other btrfs 
> features in place than try to do crcs differently.
In general, the performance issue isn't because of the time it takes to 
CoW the blocks, it's because of the fragmentation it introduces.  That 
fragmentation could in theory be mitigated by making CoW happen at a 
larger chunk size, but that would push the issue more towards being one 
of CoW performance, not fragmentation.

