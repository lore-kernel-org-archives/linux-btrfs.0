Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f173.google.com ([209.85.210.173]:42195 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758721Ab2LIRjv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Dec 2012 12:39:51 -0500
Received: by mail-ia0-f173.google.com with SMTP id w21so3691868iac.32
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Dec 2012 09:39:50 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 9 Dec 2012 10:32:10 -0700
Message-ID: <CAEp_=V=FMv0gQ_396s1jY3hbPsMA0xRoQiM6wzm+ou6ObB=7rQ@mail.gmail.com>
Subject: recent btrfs errors not resolved by btrfsck
From: Paul Williams <paulprogrammer@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I've been using btrfs on and off for a few years now.  It gets great
performance in my dev environment when dealing with big files, which I
appreciate.

This week my home machine started complaining about a disk error on my
btrfs partition.  Dropping to the maintenance console and running btrfsck
gives the following, and btrfsck aborts without attempting a fix.

Can anyone offer some advice?

warning, start mismatch 1144184832 1143091200
block 1144184832 rec extent_item_refs 1, passed 1
warning, start mismatch 1144418304 1144430592

The volume actually mounts and seems to run OK, but I would like to resolve
the error.  It would not be a huge burden to backup the volume and
reformat, but I figure that I can contribute to stabilization of btrfs by
going through this exercise.

Thanks!
Any further details required will be supplied.

My setup is as follows:
Ubuntu 12.04 LTS
AMD Phenom(tm) II X6 1090T Processor
MemTotal:       16176556 kB
Mainboard: ASUS M4A88T-M
onboard everything else
