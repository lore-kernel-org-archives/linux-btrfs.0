Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39089 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114Ab3AYPa2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 10:30:28 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so521351oag.5
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2013 07:30:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51029EFB.90301@czarc.net>
References: <1359113550-23962-1-git-send-email-gene@czarc.net>
	<51029EFB.90301@czarc.net>
Date: Fri, 25 Jan 2013 09:30:27 -0600
Message-ID: <CAE5mzvjgSufQGjSOa0Zk1_st32kTZJV_JTnrXtnYt7_0wigz=Q@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: Exit if not running as root
From: cwillu <cwillu@cwillu.com>
To: Gene Czarcinski <gene@czarc.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 25, 2013 at 9:04 AM, Gene Czarcinski <gene@czarc.net> wrote:
> OK, I think I have gotten the message that this is a bad idea as implemented
> and that it should be dropped as such.  I believe that there are some things
> ("btrfs fi show" comes to mind) which will need root and I am going to
> explore doing something for that case.  And it also might be reasonable for
> some situations to issue the message about root if something errors-out.

Eh?  That's one of the clearest cases where you _may not_ need root.

cwillu@cwillu-home:~$ groups
cwillu adm dialout cdrom audio video plugdev mlocate lpadmin admin sambashare
cwillu@cwillu-home:~$ btrfs fi show /dev/sda3
failed to read /dev/sda
failed to read /dev/sda1
failed to read /dev/sda2
failed to read /dev/sda3
failed to read /dev/sdb
Btrfs v0.19-152-g1957076

cwillu@cwillu-home:~$ sudo addgroup cwillu disk
cwillu@cwillu-home:~$ su cwillu

cwillu@cwillu-home:~$ groups
cwillu adm disk dialout cdrom audio video plugdev mlocate lpadmin
admin sambashare
cwillu@cwillu-home:~$ btrfs fi show /dev/sda3
Label: none  uuid: ede59711-6230-474f-992d-f1e3deeddab7
	Total devices 1 FS bytes used 72.12GB
	devid    1 size 104.34GB used 104.34GB path /dev/sda3

Btrfs v0.19-152-g1957076
