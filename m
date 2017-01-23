Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55286 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751855AbdAWXUd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jan 2017 18:20:33 -0500
Date: Mon, 23 Jan 2017 18:18:09 -0500
From: Chris Mason <clm@fb.com>
To: Christoph Anton Mitterer <calestyo@scientia.net>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: RAID56 status?
Message-ID: <20170123231809.GA9114@clm-mbp.masoncoding.com>
References: <d69f5a19-baa8-ff56-609e-4ee01be8a103@jvales.net>
 <1485124549.6187.36.camel@scientia.net>
 <20170122223906.GA24076@carfax.org.uk>
 <3e9fe326-7638-bc78-4fe8-f6f6851769d7@jvales.net>
 <35d49fbd-102c-3e54-4e40-5f71fb88d2da@cn.fujitsu.com>
 <CALqCWCXNoKqAJR=7c4wzOvVjSBxNRMsUYMvkfRMcVk14dkp27Q@mail.gmail.com>
 <d7d3d966-c67f-28cc-0036-9b38756ed9a2@cn.fujitsu.com>
 <1485194001.21584.1.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <1485194001.21584.1.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 23, 2017 at 06:53:21PM +0100, Christoph Anton Mitterer wrote:
>Just wondered... is there any larger known RAID56 deployment? I mean
>something with real-world production systems and ideally many different
> IO scenarios, failures, pulling disks randomly and perhaps even so
>many disks that it's also likely to hit something like silent data
>corruption (on the disk level)?
>
>Has CM already migrated all of Facebook's storage to btrfs RAID56?! ;-)
>Well at least facebook.com seems till online ;-P *kidding*
>
>I mean the good thing in having such a massive production-like
>environment - especially when it's not just one homogeneous usage
>pattern - is that it would help to build up quite some trust into the
>code (once the already known bugs are fixed).

We've been focusing on the single-drive use cases internally.  This year 
that's changing as we ramp up more users in different places.  
Performance/stability work and raid5/6 are the top of my list right now.

-chris
