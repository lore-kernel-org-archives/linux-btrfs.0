Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:51731 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684AbbAZUwK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Jan 2015 15:52:10 -0500
Received: by mail-oi0-f48.google.com with SMTP id v63so9228117oia.7
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Jan 2015 12:52:09 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 26 Jan 2015 21:52:09 +0100
Message-ID: <CANXojczR_jeVU0XNQGzatmDaaCv7CdWanis8NiSe2F75cuz_9g@mail.gmail.com>
Subject: Get the diff from a file in two snapshots.
From: Stef Bon <stefbon@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm working on a service/program for Linux which takes care of
managing backupping of folders and the snapshots of those.

The user can assign forlders he/she want to be backupped (corect
English?), and create a profile for this folder. This profile is about
the files which will be taken into process, and which not.

As tool to backup and manage the snapshots I use btrfs.
Now in my construction I get a lot of situations like:

/path/to/snapshots/201501261603/path/to/some/file

is another version of the same file at:

/path/to/snapshots/201501252252/path/to/some/file

is there a way to get the difference between these two files by making
use of btrfs?

I know there are "high level" tools like diff, and tools that fit with
the mimetype of the file
(for ODT files you need another tool than say plaintext files)

I know there is a tool like btrfs send / receive, but that count for
whole snapshots.

If there is such a tool, the next step would be whether it's possible
to provide the user comprehensive information what has changed in the
file, when the mimetype is something else than plaintext, but that's
another question.

Stef Bon
