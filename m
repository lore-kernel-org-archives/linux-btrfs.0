Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34740 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbbLZRuI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Dec 2015 12:50:08 -0500
Received: by mail-ig0-f171.google.com with SMTP id m11so102205267igk.1
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Dec 2015 09:50:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151220025010.7d353d35@natsu>
References: <20151220025010.7d353d35@natsu>
Date: Sat, 26 Dec 2015 09:50:07 -0800
Message-ID: <CAN05THQftMgDnvbf=bKXeTEH9ab1CL8gXHS+W=z71eSGszZdhg@mail.gmail.com>
Subject: Re: Timeouts copying large files to a Samba server with Btrfs
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That does not look good.
See if you can find something in the samba logs on the server.
Look for messages about long running VFS operations and/or client
disconnecting wile a file is open for writing.



The CIFS/SMB protocol has hard real-time requirements in the windows
client redirector which leads to dataloss if a server becomes
unresponsive for a long time.
Long time here means ~20s or more.

The reason is that for performance reasons CIFS/SMB defaults to use
clientside caching for writes (using oplocks as the cache coherency
protocol).
IF a server suddenly stops responding promptly the client will
eventually (20-60 seconds) tear down the connection and reconnect. As
part of the session teardown, any open files will be forced close, and
any write cache on the client will be discarded.

This basically means that if a server gets stuck in the VFS for a slow
filesystem, you face a real risk that any/all files that are open for
writing will be truncated at that stage and you have data loss.


This used to be a big problem when using samba ontop of various
cluster filesystems since they used to have a tendency to pause all
I/O for sometimes very long times when the cluster topology changed,
leading to a large amount of dataloss every time.
We added some logging to samba to help identiify this and also to log
all the names of the files that were very likely destroyed, but I
can't recall the exact wording of these messages of the top of my
head.
Look in the samba logs for things that relate to long running VFS
operations or client disconnect while the file is open for write.


Basically, If you want to use a filesystem host CIFS, you must
instrument it so that it will guarantee to always respond to I/O
requests from the clients within 10 seconds (to have some headroom) or
else you will face a real risk of data loss.


If you can not guarantee that the filesystem will never pause for this
long because it is doing foo/bar/bob/...   then you should not use
that filesystem for samba.

On Sat, Dec 19, 2015 at 1:50 PM, Roman Mamedov <rm@romanrm.net> wrote:
> Hello,
>
> Sometimes when I copy large files (the latest case was with a 13 GB file) to a
> Btrfs-residing share on a Samba file server (using Thunar file manager), the
> copy process fails around the end with following messages in dmesg on the
> client:
>
> [7699154.504380] CIFS VFS: sends on sock ffff88010d41e800 stuck for 15 seconds
> [7699154.504440] CIFS VFS: Error -11 sending data on socket to server
> [7699215.173469] CIFS VFS: sends on sock ffff88010d41e800 stuck for 15 seconds
> [7699215.173533] CIFS VFS: Error -11 sending data on socket to server
> [7699317.982262] CIFS VFS: sends on sock ffff88010d41e800 stuck for 15 seconds
> [7699317.982319] CIFS VFS: Error -11 sending data on socket to server
>
> Nothing in dmesg on the server.
>
> My guess is that the Samba server process submits too much queued buffers at
> once to be written to disk, then blocks on waiting for this, and the whole
> operation ends up taking so long, that it doesn't get back to the client in
> time.
>
> This also happens much more often is compress-force is enabled on the server.
>
> The server specs are AMD E-350 1.6GHz, 16GB of RAM, client/server network
> connection is 1 Gbit. Kernel 4.1.15 on the server, 3.18.21 on the client.
>
> Any idea what to tune so that this doesn't happen? (server/client/Samba/Btrfs?)
>
> --
> With respect,
> Roman
