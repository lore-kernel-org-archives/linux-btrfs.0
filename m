Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:63136 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161826AbbBDUxK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Feb 2015 15:53:10 -0500
Received: by mail-yh0-f47.google.com with SMTP id z6so1746064yhz.6
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Feb 2015 12:53:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS1cTQqbsYM01baLUmqTXDNE5HZfM-uL8gx0HkHXo-a+A@mail.gmail.com>
References: <CAJCQCtS1cTQqbsYM01baLUmqTXDNE5HZfM-uL8gx0HkHXo-a+A@mail.gmail.com>
Date: Wed, 4 Feb 2015 13:53:09 -0700
Message-ID: <CAJCQCtQUrfYhiG_Huv+M5w=6bEsvgnY1kUbreO-dANMhCrALbQ@mail.gmail.com>
Subject: Re: paused balance convert from raid1 can no longer be a writeable mount
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is completely reproducible with a brand new file system created
as raid1, using kernel 3.19 and btrfs-progs 3.18.

The conversion from raid1 to single, if paused, will apparently break
the file system's ability to be subsequently mounted writable. And
further, btrfs-image fails. I've updated the bug report.
https://bugzilla.kernel.org/show_bug.cgi?id=92641

First, the conversion from data/metadata raid1 should be faster than
requiring fully reading and writing the file system. As this is a 2
device raid1, each is already effectively data/metadata single, so I'm
not sure why anything other than metadata needs rewriting.

Second, either what I'm doing should be disallowed (user can't force
conversion of a degraded array to single), or the file system
shouldn't break like this.

Third, the error message is confusing "too many missing devices,
writeable mount is not allowed" the first part of that is definitely
not true. How can there be too many missing devices when it started
out as a 2 device volume and the remaining device isn't an ro or seed
device?


Chris Murphy
