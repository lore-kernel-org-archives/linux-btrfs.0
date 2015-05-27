Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:34317 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbbE0Mb2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 May 2015 08:31:28 -0400
Received: by oifu123 with SMTP id u123so5957410oif.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2015 05:31:28 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 May 2015 14:31:28 +0200
Message-ID: <CANXojcyqXUNhWLa4ybGyhXceqLdb3DdvM-TvEtwf-KOM6YOsUQ@mail.gmail.com>
Subject: Plans for a library for btrfs?
From: Stef Bon <stefbon@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm working on a program (using sqlite, FUSE and btrfs) to provide
backup and version managment
for users. They can enable the backup service for folders they own,
and select files they want to backup using mimetypes.

This program, which I've called fuse-backup, creates backup subvolumes
and snapshots by calling an extrenal script, which does something
like:

btrfs subvolume snapshot -r %PathToBackup%/ %PathToSnapshot%

This works perfect, but are there any plans to do this with a library?

Stef Bon
