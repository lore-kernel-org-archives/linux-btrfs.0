Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:34143 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750771AbdHNTIb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 15:08:31 -0400
Received: by mail-ua0-f172.google.com with SMTP id q25so40303786uah.1
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Aug 2017 12:08:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <97904d09-60ef-6262-9cec-11f4ebd8af6c@inwind.it>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com> <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com> <1502496618.6092.6.camel@scientia.net>
 <20170812074248.GA3352@infradead.org> <1502538706.3996.1.camel@scientia.net>
 <20170812121257.GZ7140@carfax.org.uk> <1219eff6-7020-444c-efd7-6afb5ef551d9@libero.it>
 <86a8d523-8dc3-8406-af4c-8bb93e7859c5@gmx.com> <97904d09-60ef-6262-9cec-11f4ebd8af6c@inwind.it>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 14 Aug 2017 13:08:30 -0600
Message-ID: <CAJCQCtT5hgvHqiUDuahdyVasppV=UZhks4rpXNfWC4XEa34ywA@mail.gmail.com>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Hugo Mills <hugo@carfax.org.uk>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Christoph Hellwig <hch@infradead.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Liu Bo <bo.li.liu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 14, 2017 at 8:23 AM, Goffredo Baroncelli <kreijack@inwind.it> wrote:

> Form a theoretical point of view, if you have a "PURE" COW file-system, you don't need a journal. Unfortunately a RAID5/6 stripe update is a RMW cycle, so you need a journal to keep it in sync. The same is true for the NOCOW file (and their checksums)
>

I'm pretty sure the raid56 rmw is in memory only, I don't think we
have a case where a stripe is getting partial writes (a block in a
stripe is being overwritten). Partial stripe updates with rmw *on
disk* would mean Btrfs raid56 is not CoW.

-- 
Chris Murphy
