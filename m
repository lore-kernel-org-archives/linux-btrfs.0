Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62031 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab2ICOfR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Sep 2012 10:35:17 -0400
Received: by dady13 with SMTP id y13so3732852dad.19
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Sep 2012 07:35:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5044BD53.5080106@codethink.co.uk>
References: <5044BD53.5080106@codethink.co.uk>
Date: Mon, 3 Sep 2012 08:35:16 -0600
Message-ID: <CAE5mzvgwXks1+6q+tL=AJR7q1HvduQA6S2KMP36-AT40jTkhtQ@mail.gmail.com>
Subject: Re: Advice on FS corruption
From: cwillu <cwillu@cwillu.com>
To: Sam Thursfield <sam.thursfield@codethink.co.uk>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 3, 2012 at 8:23 AM, Sam Thursfield
<sam.thursfield@codethink.co.uk> wrote:
> Hi
>
> I've been running btrfs in various VMs for a while, and periodically I've
> experienced corruption in the filesystems being used. None of the data is
> important, but I'd like to track down how the corruption occurred in the
> first place.
>
> Trying to mount any of the corrupt filesystems fails with an error of this
> form:
>
> [   47.805146] device label baserock devid 1 transid 90 /dev/sdb1
> [   47.810073] btrfs: disk space caching is enabled
> [   47.817261] parent transid verify failed on 1636728832 wanted 76 found 95
> [   47.818081] parent transid verify failed on 1636728832 wanted 76 found 95
> [   47.818522] Failed to read block groups: -5
> [   47.826103] btrfs: open_ctree failed

Try mounting with -o recovery.
