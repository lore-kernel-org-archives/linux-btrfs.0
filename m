Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbaJJWFY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Oct 2014 18:05:24 -0400
Message-ID: <5438581D.5060102@redhat.com>
Date: Fri, 10 Oct 2014 17:05:17 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Bob Marley <bobmarley@shiftmail.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: What is the vision for btrfs fs repair?
References: <54358C77.2070808@redhat.com> <9251D9EB-5B12-4885-8C6B-FFA10B1CDA24@colorremedies.com> <5437BAB2.1040605@shiftmail.org> <93B9D2BD-1F0F-4C94-899F-16A3A2A0D57E@colorremedies.com> <54381ADB.2030002@shiftmail.org> <543834FC.9050409@gmail.com>
In-Reply-To: <543834FC.9050409@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/10/14 2:35 PM, Austin S Hemmelgarn wrote:
> On 2014-10-10 13:43, Bob Marley wrote:
>> On 10/10/2014 16:37, Chris Murphy wrote:
>>> The fail safe behavior is to treat the known good tree root as
>>> the default tree root, and bypass the bad tree root if it cannot
>>> be repaired, so that the volume can be mounted with default mount
>>> options (i.e. the ones in fstab). Otherwise it's a filesystem
>>> that isn't well suited for general purpose use as rootfs let
>>> alone for boot.
>>> 
>> 
>> A filesystem which is suited for "general purpose" use is a
>> filesystem which honors fsync, and doesn't *ever* auto-roll-back
>> without user intervention.
>> 
>> Anything different is not suited for database transactions at all.
>> Any paid service which has the users database on btrfs is going to
>> be at risk of losing payments, and probably without the company
>> even knowing. If btrfs goes this way I hope a big warning is
>> written on the wiki and on the manpages telling that this
>> filesystem is totally unsuitable for hosting databases performing
>> transactions.
> If they need reliability, they should have some form of redundancy
> in-place and/or run the database directly on the block device;
> because even ext4, XFS, and pretty much every other filesystem can
> lose data sometimes,

Not if i.e. fsync returns.  If the data is gone later, it's a hardware
problem, or occasionally a bug - bugs that are usually found & fixed
pretty quickly.

> the difference being that those tend to give
> worse results when hardware is misbehaving than BTRFS does, because
> BTRFS usually has a old copy of whatever data structure gets
> corrupted to fall back on.

I'm curious, is that based on conjecture or real-world testing?

-Eric

