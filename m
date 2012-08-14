Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38814 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2HNNxo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 09:53:44 -0400
Received: by qcro28 with SMTP id o28so237856qcr.19
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Aug 2012 06:53:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502A529B.8060201@pocock.com.au>
References: <5027DDFC.60504@pocock.com.au>
	<CAG1y0scy=6NByQ9DBF_9m6MrmNrYe1WvX9-JkmbEUKWjd77w8Q@mail.gmail.com>
	<502A529B.8060201@pocock.com.au>
Date: Tue, 14 Aug 2012 20:53:43 +0700
Message-ID: <CAG1y0sdEePQbRUwvmbCqGMxfPqwCiUKxWcuxczFFEhtait1sNQ@mail.gmail.com>
Subject: Re: raw partition or LV for btrfs?
From: "Fajar A. Nugraha" <list@fajar.net>
To: Daniel Pocock <daniel@pocock.com.au>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 14, 2012 at 8:28 PM, Daniel Pocock <daniel@pocock.com.au> wrote:
> Can you just elaborate on the qgroups feature?
> - Does this just mean I can make the subvolume sizes rigid, like LV sizes?

Pretty much.

> - Or is it per-user restrictions or some other more elaborate solution?

No

>
> If I create 10 LVs today, with btrfs on each, can I merge them all into
> subvolumes on a single btrfs later?

No

>
> If I just create a 1TB btrfs with subvolumes now, can I upgrade to
> qgroups later?

Yes

>  Or would I have to recreate the filesystem?

No

> If I understand correctly, if I don't use LVM, then such move and resize
> operations can't be done for an online filesystem and it has more risk.

You can resize, add, and remove devices from btrfs online without the
need for LVM. IIRC LVM has finer granularity though, you can do
something like "move only the first 10GB now, I'll move the rest
later".

-- 
Fajar
