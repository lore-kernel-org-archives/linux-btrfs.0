Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:34588 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbbKKMWU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Nov 2015 07:22:20 -0500
Received: by ykfs79 with SMTP id s79so45257134ykf.1
        for <linux-btrfs@vger.kernel.org>; Wed, 11 Nov 2015 04:22:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56432D2A.5040506@profihost.ag>
References: <56432D2A.5040506@profihost.ag>
Date: Wed, 11 Nov 2015 13:22:19 +0100
Message-ID: <CAHji153qQPDyO+Ajv3O+FE991DjPG3y1t35091s8t9S4+w5k3g@mail.gmail.com>
Subject: Re: Regression in btrfs: properly set the termination value of
 ctx->pos in readdir
From: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 11, 2015 at 12:57 PM, Stefan Priebe - Profihost AG
<s.priebe@profihost.ag> wrote:
> Hi,
>
> the patch btrfs: properly set the termination value of ctx->pos in
> readdir introduces a regression to me.
>
> A lot of stuff runs in "endless" or long running loops.

Just tested this and can confirm something is off.
In a directory with several files, create a new directory and move all
files into the new subdir.
An immediately following ls will hang. The problem goes away after a
manual sync.

-h
