Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:64388 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHaGFZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Aug 2014 02:05:25 -0400
Received: by mail-lb0-f181.google.com with SMTP id n15so4478989lbi.12
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Aug 2014 23:05:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH-HCWXVn3pyejxzy7_sQmGPwARf6hLxYdHPWBrhd5bkZvExpQ@mail.gmail.com>
References: <CAH-HCWXVn3pyejxzy7_sQmGPwARf6hLxYdHPWBrhd5bkZvExpQ@mail.gmail.com>
From: Mike Hartman <mike@hartmanipulation.com>
Date: Sun, 31 Aug 2014 02:05:03 -0400
Message-ID: <CAB=7dhm+0GOSJtd8maAakzni7TvpU_nAmCDNm_d2bQMqAUi=Ww@mail.gmail.com>
Subject: Re: Change "total" in btrfs filesystem df output to "alloc"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Aug 30, 2014 9:55 PM, "Shriramana Sharma" <samjnaa@gmail.com> wrote:
>
> Hello. There seem to be lots of questions in various forums re the
> output of btrfs fi df -- especially w.r.t. the usage of the word
> "total". For example see https://community.oracle.com/thread/2459838
>
> I feel it would make the intent clearer if "total" were changed to
> "alloc" or "allocated" (if the short form is felt unclear). It would
> also help people understand the output of regular df on a btrfs system
> since one can understand easier that pre-allocated space would count
> as "used" space as it is not free!
>
> --


Just a user here, but I think that's a GREAT idea. Even after reading
the man page and wiki the current output isn't terribly easy to
understand for the uninitiated. I think "allocated" is a much better
representation of the actual state of the fs (as I understand it).
