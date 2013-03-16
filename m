Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f170.google.com ([209.85.210.170]:49718 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927Ab3CPMYs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Mar 2013 08:24:48 -0400
Received: by mail-ia0-f170.google.com with SMTP id h8so4066745iaa.29
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Mar 2013 05:24:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303162302.14746.russell@coker.com.au>
References: <201303162302.14746.russell@coker.com.au>
Date: Sat, 16 Mar 2013 06:24:47 -0600
Message-ID: <CAE5mzvj4DF98MmzW7M29WZtKiW3p_f7=GzZ54q3+jo6CWgPvxw@mail.gmail.com>
Subject: Re: multiple btrfsck runs
From: cwillu <cwillu@cwillu.com>
To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 16, 2013 at 6:02 AM, Russell Coker <russell@coker.com.au> wrote:
> Is it expected that running btrfsck more than once will keep reporting errors?

Without options, btrfsck does not write to the disk.
