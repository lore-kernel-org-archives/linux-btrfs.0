Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:46416 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753651AbaA0SfG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 13:35:06 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: =?windows-1252?Q?Re=3A_Snapshots_=96_noob_questions?=
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140127140350.GL3314@carfax.org.uk>
Date: Mon, 27 Jan 2014 11:35:03 -0700
Cc: KC <impactoria@googlemail.com>, linux-btrfs@vger.kernel.org
Message-Id: <D927B5A8-4670-4A26-8C21-E389BBB0487E@colorremedies.com>
References: <52E664E0.5070909@gmail.com> <20140127140350.GL3314@carfax.org.uk>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 27, 2014, at 7:03 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Mon, Jan 27, 2014 at 02:53:36PM +0100, KC wrote:
>> I have been trying to understand how snapshots work (in BRTFS and in
>> general), but I still have some questions, and would appreciate if
>> someone could clear them for me.
>> To make things easier, I tried to make most of them Yes/No questions:
>> 
>> 1. When creating the filesystem, I only made btrfs partition with no
>> subvolumes. Do I have to use subvolumes, or can I snapshot entire
>> “/“?
> 
>   / (the top level of the FS) is a subvolume as well -- it's the only
> one that can't be renamed or deleted, though.


I'll point out a source of confusion I've had, and see new users have the same confusion quite often also. Within the file system hierarchy, / is a mount point. It could be that subvolume ID 5 is mounted there, which is how opensuse's default rootfs on Btrfs works. However, Fedora's / is a subvolume named root, the top level ID 5 subvolume isn't mounted by default.

So / is not necessarily the top level of the file system. I'm not sure what to call the undeleteable ID 5 subvolume. It's the default subvolume, but if the user changes the default subvolume then it isn't. Calling it the default default is maybe more confusing. And calling it subvolume ID 5 is a bit confusing because subvolume ID 0 maps to 5, and many users are more familiar with subvol ID 0 than ID 5. And then if I have a subvolume within a subvolume mounted and do a btrfs list, it shows top level ID with a value other than 5.

Anyway I really don't know what else to call the undeletable first subvolume.

Chris Murphy

