Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37189 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751398AbdHGP1L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Aug 2017 11:27:11 -0400
Received: by mail-wm0-f46.google.com with SMTP id t201so9911629wmt.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Aug 2017 08:27:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za> <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 7 Aug 2017 09:27:09 -0600
Message-ID: <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Brendan Hide <brendan@swiftspirit.co.za>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 4, 2017 at 8:05 AM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>     For example, if one day there is some dm-csum to support verify csum of
> given ranges (and skip unrelated ones specified by higher levels), btrfs
> support for data csum is no longer an exclusive feature.

How would dm-csum differ from dm-integrity?
https://www.kernel.org/doc/Documentation/device-mapper/dm-integrity.txt

By that description it uses a journal to guarantee atomicity. If
multiqueue maybe the performance implications are neutral. But
certainly on spinning drives that would slow things down, especially
if the file system is also journaling, and the workload is metadata
heavy.

-- 
Chris Murphy
