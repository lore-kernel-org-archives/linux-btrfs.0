Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:57337 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbaFDOIQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 10:08:16 -0400
Received: by mail-vc0-f182.google.com with SMTP id id10so8681812vcb.13
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 07:08:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <16894659.LPcZdlAJqm@xev>
References: <20140604111916.GB1657@mars>
	<16894659.LPcZdlAJqm@xev>
Date: Wed, 4 Jun 2014 15:08:15 +0100
Message-ID: <CAMU1PDg=mw7V5WkmNDOhtCHsD=H+gS8WWSGDRzXHTYBtwY-2GQ@mail.gmail.com>
Subject: Re: Partition tables / Output of parted
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: russell@coker.com.au
Cc: Stefan Malte Schumacher <s.schumacher@netcologne.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4 June 2014 14:30, Russell Coker <russell@coker.com.au> wrote:
> On Wed, 4 Jun 2014 13:19:16 Stefan Malte Schumacher wrote:
>> I have created multiple filesystems with btrfs, in all cases directly
>> on the devices themself without creating partitions beforehand.
>
> I do that sometimes, it works well.  I've done the same thing with Ext2/3 in
> the past as well, it's no big deal.
>
>> Now,
>> if I open the disks containing the multi-device filesystem in parted
>> it outputs the partion table as loop and shows one partition with
>> btrfs which covers the whole disk.
>
> http://lists.alioth.debian.org/pipermail/parted-devel/2009-May/002840.html
>
> A Google search on "Partition Table: loop" turned up the above explanation as
> the third result.
>
>> I am unsure how to interpret this output. Two possible explanations
>> come to mind: a) Btrfs does create partitions, but only if a filesystem
>> spans multiple devices or b) the output of parted is faulty and no actual
>> partition is created in both cases.
>
> BTRFS doesn't create partitions.

c) Parted (libparted) is merely displaying a pretend loop partition
table as a way to represent the situation of a file system covering
the whole disk in it's view of the world where all disks have a
partition table.

Mike
