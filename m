Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ed1-f43.google.com ([209.85.208.43]:44381 "EHLO
        mail-ed1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbeHKIvf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Aug 2018 04:51:35 -0400
Received: by mail-ed1-f43.google.com with SMTP id f23-v6so5771302edr.11
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Aug 2018 23:18:30 -0700 (PDT)
Subject: Re: Report correct filesystem usage / limits on BTRFS subvolumes with
 quota
To: Tomasz Pala <gotar@polanet.pl>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
References: <0059606f-88bf-c919-450b-bf08e184b5a2@mailbox.org>
 <b10a3950-0b86-e4fb-3621-f4c5ad3d79e7@gmx.com>
 <20180809174811.GA27001@polanet.pl>
 <a4719dd3-fae9-c81c-8f51-f59fceda14ba@gmail.com>
 <20180810182115.GA922@polanet.pl>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <03266d2e-2812-52bd-43aa-e64f67aaad47@gmail.com>
Date: Sat, 11 Aug 2018 09:18:26 +0300
MIME-Version: 1.0
In-Reply-To: <20180810182115.GA922@polanet.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

10.08.2018 21:21, Tomasz Pala пишет:
> On Fri, Aug 10, 2018 at 07:39:30 -0400, Austin S. Hemmelgarn wrote:
> 
>>> I.e.: every shared segment should be accounted within quota (at least once).
>> I think what you mean to say here is that every shared extent should be 
>> accounted to quotas for every location it is reflinked from.  IOW, that 
>> if an extent is shared between two subvolumes each with it's own quota, 
>> they should both have it accounted against their quota.
> 
> Yes.
> 

This is what "referenced" in quota group report is, is not it? What is
missing here?
