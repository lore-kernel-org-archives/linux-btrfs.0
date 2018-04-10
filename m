Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:39172 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752857AbeDJNOj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Apr 2018 09:14:39 -0400
Received: by mail-io0-f173.google.com with SMTP id v13so13597870iob.6
        for <linux-btrfs@vger.kernel.org>; Tue, 10 Apr 2018 06:14:39 -0700 (PDT)
Subject: Re: How to zero errors
To: James Courtier-Dutton <james.dutton@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAAMvbhG37R8qTD3u=K7ao1GxmdeH6ieQDw-tpMK1yBoh9nxRRw@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <85e15063-0b47-b082-2858-a5040ca3d827@gmail.com>
Date: Tue, 10 Apr 2018 09:14:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAAMvbhG37R8qTD3u=K7ao1GxmdeH6ieQDw-tpMK1yBoh9nxRRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-04-10 09:08, James Courtier-Dutton wrote:
> Hi,
> 
> I have  disk that in the past had errors on it.
> I have fixed up the errors.
> btrfs scrub now reports no errors.
> How do I reset these counters to zero?
> 
> BTRFS info (device sdc2): bdev /dev/sdc2 errs: wr 0, rd 35, flush 0,
> corrupt 1, gen 0

Run `btrfs device stats` with the `-z` option on the filesystem.
