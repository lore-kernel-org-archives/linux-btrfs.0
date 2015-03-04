Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:39488 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933535AbbCDGVE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Mar 2015 01:21:04 -0500
Received: by lbvn10 with SMTP id n10so42073802lbv.6
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Mar 2015 22:21:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1425051165-23376-1-git-send-email-dsterba@suse.cz>
References: <1425051165-23376-1-git-send-email-dsterba@suse.cz>
Date: Wed, 4 Mar 2015 01:21:02 -0500
Message-ID: <CALJXSJov2K5M7RAAn4_i50Qvdc8ns9jy+LgCzhPJVQEwemLZsg@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: convert: show progress by default
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 27, 2015 at 10:32 AM, David Sterba <dsterba@suse.cz> wrote:
>
> +       printf("\t-p           show converting progress (default)\n");

A quick look a this it looks like you've added a mandatory «option»
since the "case" which handle -p can only turn on this flag. Logic
should be switched to -q for quiet mode instead.
