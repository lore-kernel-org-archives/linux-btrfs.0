Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55650 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbdHLHmx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 12 Aug 2017 03:42:53 -0400
Date: Sat, 12 Aug 2017 00:42:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
Message-ID: <20170812074248.GA3352@infradead.org>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
 <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1502496618.6092.6.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 12, 2017 at 02:10:18AM +0200, Christoph Anton Mitterer wrote:
> Qu Wenruo wrote:
> >Although Btrfs can disable data CoW, nodatacow also disables data 
> >checksum, which is another main feature for btrfs.
> 
> Then decoupling of the two should probably decoupled and support for
> notdatacow+checksumming be implemented?!

And how are you going to write your data and checksum atomically when
doing in-place updates?
