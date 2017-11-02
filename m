Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:56672 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933680AbdKBPHp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Nov 2017 11:07:45 -0400
Received: by mail-io0-f178.google.com with SMTP id m81so14647112ioi.13
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 08:07:45 -0700 (PDT)
Subject: Re: Multiple btrfs-cleaner threads per volume
To: Martin Raiber <martin@urbackup.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <0102015f7d418aa6-af3c2ae7-27b0-47d0-a4bb-173f55304bb9-000000@eu-west-1.amazonses.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <fa6917cf-5251-16bb-48c9-e69163ccf530@gmail.com>
Date: Thu, 2 Nov 2017 11:07:40 -0400
MIME-Version: 1.0
In-Reply-To: <0102015f7d418aa6-af3c2ae7-27b0-47d0-a4bb-173f55304bb9-000000@eu-west-1.amazonses.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-02 11:02, Martin Raiber wrote:
> Hi,
> 
> snapshot cleanup is a little slow in my case (50TB volume). Would it
> help to have multiple btrfs-cleaner threads? The block layer underneath
> would have higher throughput with more simultaneous read/write requests.
I think a bigger impact would be proper parallelization of IO requests. 
Right now, writes are serialized (they first get sent to one device, 
then the next, then the next, until they've been sent to all devices), 
and reads aren't inherently load-balanced across devices (ideally, other 
things than load, like where the last read came from on a rotational 
device, would be factored in, but even just regular load balancing would 
be an improvement right now).  As a result, multi-device BTRFS volumes 
in general don't perform as well as possible, which is then compounded 
by other issues (such as snapshot cleanup being somewhat expensive).

