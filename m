Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:54384 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751601AbdHNPNj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 11:13:39 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id 8B5B19B838
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Aug 2017 16:13:37 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id 55C475FBB3
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Aug 2017 16:13:37 +0100 (BST)
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
 <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net> <20170812074248.GA3352@infradead.org>
 <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <1502713484.3608.1.camel@scientia.net>
 <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
From: Graham Cobb <g.btrfs@cobb.uk.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net>
Date: Mon, 14 Aug 2017 16:13:37 +0100
MIME-Version: 1.0
In-Reply-To: <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14/08/17 15:23, Austin S. Hemmelgarn wrote:
> Assume you have higher level verification.  

But almost no applications do. In real life, the decision
making/correction process will be manual and labour-intensive (for
example, running fsck on a virtual disk or restoring a file from backup).

> Would you rather not be able
> to read the data regardless of if it's correct or not, or be able to
> read it and determine yourself if it's correct or not?  

It must be controllable on a per-file basis, of course. For the tiny
number of files where the app can both spot the problem and correct it
(for example if it has a journal) the current behaviour could be used.

But, on MY system, I absolutely would **always** select the first option
(-EIO). I need to know that a potential problem may have occurred and
will take manual action to decide what to do. Of course, this also needs
a special utility (as Christoph proposed) to be able to force the read
(to allow me to examine the data) and to be able to reset the checksum
(although that is presumably as simple as rewriting the data).

This is what happens normally with any filesystem when a disk block goes
bad, but with the additional benefit of being able to examine a
"possibly valid" version of the data block before overwriting it.

> Looking at this from a different angle: Without background, what would
> you assume the behavior to be for this?  For most people, the assumption
> would be that this provides the same degree of data safety that the
> checksums do when the data is CoW.  

Exactly. The naive expectation is that turning off datacow does not
prevent the bitrot checking from working. Also, the naive expectation
(for any filesystem operation) is that if there is any doubt about the
reliability of the data, the error is reported for the user to deal with.
