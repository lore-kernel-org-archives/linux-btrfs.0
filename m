Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:54713 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751695AbdHNQmW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 12:42:22 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 221C39B838
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Aug 2017 17:42:16 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id E04725FBB3
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Aug 2017 17:42:15 +0100 (BST)
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
 <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net> <20170812074248.GA3352@infradead.org>
 <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <1502713484.3608.1.camel@scientia.net>
 <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
 <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net>
 <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <3198d9af-c63f-9922-c873-c13e5a914c79@cobb.uk.net>
Date: Mon, 14 Aug 2017 17:42:15 +0100
MIME-Version: 1.0
In-Reply-To: <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14/08/17 16:53, Austin S. Hemmelgarn wrote:
> Quite a few applications actually _do_ have some degree of secondary
> verification or protection from a crash.  

I am glad your applications do and you have no need of this feature.
You are welcome not to use it. I, on the other hand, definitely want
this feature and would have it enabled by default on all my systems
despite the need for manual actions after some unclean shutdowns.

> Go look at almost any database
> software.  It usually will not have checksumming, but it will almost
> always have support for a journal, which is enough to cover the
> particular data loss scenario we're talking about (unexpected unclean
> shutdown).

No, the problem we are talking about is the data-at-rest corruption that
checksumming is designed to deal with. That is why I want it. The
unclean shutdown is a side issue that means there is a trade-off to
using it.

No one is suggesting that checksums are any significant help with the
unclean shutdown case, just that the existence of that atomicity issue
does not **prevent** them being very useful for the function for which
they were designed. The degree to which any particular sysadmin will
choose to enable or disable checksums on nodatacow files will depend on
how much they value the checksum protection vs. the impact of manually
fixing problems after some unclean shutdowns.

In my particular case, many of these nodatacow files are large, very
long-lived and only in use intermittently. I would like my monthly
"btrfs scrub" to know they haven't gone bad but they are extremely
unlikely to be in the middle of a write during an unclean shutdown so I
am likely to have very few false errors. They are all backed up, but
without checksumming I don't know that the backup needs to be restored
(or even that I am not backing up now-bad data).

Graham
