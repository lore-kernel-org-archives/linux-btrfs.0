Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:35427 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbbDHNiX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2015 09:38:23 -0400
Received: by obbfy7 with SMTP id fy7so137820742obb.2
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Apr 2015 06:38:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9805000.6VT5HnkAKH@quad>
References: <1463140364.591861428494608421.JavaMail.weblogic@epmlwas09b>
	<20150408122757.GN13864@carfax.org.uk>
	<9805000.6VT5HnkAKH@quad>
Date: Wed, 8 Apr 2015 15:38:16 +0200
Message-ID: <CANXojcwKK+B5qxwSCPZW4ergy0=N62+AQgAySMdj1y2a7oJbKA@mail.gmail.com>
Subject: Re: Porting BTRFS to user space
From: Stef Bon <stefbon@gmail.com>
To: Chris Samuel <chris@csamuel.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

maybe interesting to know,

I'm working on a backup service, which uses btrfs for making snapshots.
The user can assign a folder for backup very easy, and create "rules" per backup
of what to backup. Right now it works with assigning mimetypes to a backup:
the files ot these mimetypes will be watched and made a backup of.

To show the backup of a file and all the versions available it uses FUSE.
To keep track of the different versions sqlite is used.

I do not have a project page yet, but a message at the kde forum:

https://forum.kde.org/viewtopic.php?f=223&t=125124

and I'm planning to give a presentation at the openSuse meeting at Den
Hage in may.

This FUSE fs is totally different from what you're looking for, but
still maybe interesting.

Stef
