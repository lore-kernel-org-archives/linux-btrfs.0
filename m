Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zougloub.eu ([188.165.233.99]:39921 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713Ab3GOLzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jul 2013 07:55:52 -0400
Date: Mon, 15 Jul 2013 07:58:11 -0400
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Josef Bacik <jbacik@fusionio.com>
Subject: Re: Troublesome failure mode and recovery
Message-ID: <20130715075811.4bb5c090@Bidule>
In-Reply-To: <20130713121404.65fc89ea@Bidule>
References: <20130713121404.65fc89ea@Bidule>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 13 Jul 2013 12:14:04 -0400
Jérôme Carretero <cJ-ko@zougloub.eu> wrote:

> Within the UML instance with python, I cannot do `ls` (`os.listdir()`)
> on my home folder (`/home/cJ`), and btrfs-restore only restores
> a few dot files in there.
> But I can get inode numbers and read files or subdirectories beyond
> this folder.

I was able to recover the "critical" data this way (mounted a second image
and ran python,busybox and rsync to salvage the data at known locations under
the problematic directory).

Right now, I think that 2-3 sections of medatata had been overridden by data
very recently. These sections are very small, so I don't think it was a discard
issue. And I think this must have been provoked somehow by older crashes a few
weeks ago.

My disk image is still there in case someone wants to play with it.

Regards,

-- 
Jérôme
