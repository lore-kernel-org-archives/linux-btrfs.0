Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:55475 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaKYWrM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 17:47:12 -0500
Received: by mail-yh0-f45.google.com with SMTP id f10so774005yha.18
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 14:47:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141125222126.GQ17380@hungrycats.org>
References: <FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
	<546BA96D.4050805@ubuntu.com>
	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com>
	<20141121042814.GR17395@hungrycats.org>
	<5470C92E.1070607@inwind.it>
	<20141123001927.GO17380@hungrycats.org>
	<5474AF87.6090702@inwind.it>
	<20141125202948.GP17380@hungrycats.org>
	<5474FBD9.5070709@inwind.it>
	<20141125222126.GQ17380@hungrycats.org>
Date: Tue, 25 Nov 2014 15:47:11 -0700
Message-ID: <CAJCQCtQDYUtS=JJuqYo7H-coNjNJeuB_zaKZ+-jm4CXnA_=yLQ@mail.gmail.com>
Subject: Re: BTRFS messes up snapshot LV with origin
From: Chris Murphy <lists@colorremedies.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What happens when all btrfs LVs are unmounted, and you lvchange -an
the LVs (the pair) you do not want mounted; and then btrfs dev scan;
and then mount one of the devices? It should only find the matching LV
because the others are deactivated. I know this isn't ideal, but it's
better than corruption.


Chris Murphy
