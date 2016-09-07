Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:38063 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753009AbcIGO4F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Sep 2016 10:56:05 -0400
Received: by mail-it0-f49.google.com with SMTP id c198so25592373ith.1
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Sep 2016 07:56:04 -0700 (PDT)
Subject: Re: Security implications of btrfs receive?
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Graham Cobb <g.btrfs@cobb.uk.net>, linux-btrfs@vger.kernel.org
References: <c04c596d-4cb9-ed98-513a-c550b1be18b2@cobb.uk.net>
 <2d59a472-4e74-d64c-27c4-28677d761316@gmail.com>
 <4afee621-0493-1ffc-31fe-fb81643f2374@cobb.uk.net>
 <4a00b682-c674-a46f-798e-d98b3e517f02@gmail.com>
 <1473259452.24874.5.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <e27b4c05-2d3c-a81a-0a54-b7f7b940feec@gmail.com>
Date: Wed, 7 Sep 2016 10:55:49 -0400
MIME-Version: 1.0
In-Reply-To: <1473259452.24874.5.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-07 10:44, Christoph Anton Mitterer wrote:
> On Wed, 2016-09-07 at 07:58 -0400, Austin S. Hemmelgarn wrote:
>> if you want proper security you should
>> be
>> using a real container system
>
> Won't these probably use the same filesystems?
That depends on how it's set up.  Most container software doesn't really 
care (but as this shows, they really should at least warn about this), 
but has no issues running a container off of it's own filesystem, so it 
ends up being an administrator decision in the end (as it arguably 
should be).
