Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48374 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751502AbaAORQQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 12:16:16 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfsck failes
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAKcLGm-Km3svoJ4oPGUdv8Wh__qsNAjujVmhF=46dwQP4HaeNw@mail.gmail.com>
Date: Wed, 15 Jan 2014 10:16:13 -0700
Message-Id: <5A3CA53B-B359-4DE0-A31B-49F98A1EBF7C@colorremedies.com>
References: <CAFP7zVthUK54N5-8+QRABBpz2R9-mAbJGjiOc6Ty3nVS4O-EDA@mail.gmail.com> <A76390BF-4D85-47D3-A332-AD09809F6632@colorremedies.com> <CAKcLGm-Km3svoJ4oPGUdv8Wh__qsNAjujVmhF=46dwQP4HaeNw@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Mitch Harder <mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 15, 2014, at 9:15 AM, Mitch Harder <mitch.harder@sabayonlinux.org> wrote:

> On Mon, Jan 13, 2014 at 6:37 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> 
>> On Jan 13, 2014, at 3:58 PM, Holger Brandsmeier <brandsmeier@gmail.com> wrote:
>>> 
>>> Currently btrfsck failes to repair my partition, I get the output:
>>> 
>>> [root@ho-think bholger]# btrfsck --repair /dev/sda5
>> 
>> This is almost the last resort and you probably should be posting to the list before using repair.
>> 
>> 
> 
> This is like saying:
> 
> "Yes, btrfs does now have a working btrfsck, but only for the select
> few who manage to get through on the mailing list for support."
> 
> I'd like to think that's not the case.

Yet that's exactly what the wiki suggests: "If you have a broken filesystem, it is probably better to use btrfsck with advice from one of the btrfs developers, just in case something goes wrong. (But even if it does go badly wrong, you've still got your backups, right?)"

I think it's understandably annoying that the repair tool could make things worse rather than fail gracefully, because restoring from backups is tedious. But the only way it gets better is if people break both the file system and the repair tools in ways the devs can't possibly predict. 

Chris Murphy

