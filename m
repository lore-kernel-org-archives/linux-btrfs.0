Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57949 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab2JOTPH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 15:15:07 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so3145374eek.19
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2012 12:15:05 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Goffredo Baroncelli <kreijack@gmail.com>, linux-btrfs@vger.kernel.org,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH] Btrfs-progs: use atoll() for mkfs.btrfs size option
Date: Mon, 15 Oct 2012 21:15:22 +0200
Message-Id: <1350328523-7465-1-git-send-email-kreijack@gmail.com>
In-Reply-To: <1350299942-23468-1-git-send-email-sbehrens@giantdisaster.de>
References: <1350299942-23468-1-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Stefan,

when I checked your patch I found further problems to the function
parse_size():
- this function is declared two time: both in mkfs.c and in cmd-filesystem.c;
this is a good chance to move it in the utils.c file.
- your suggestion was to use atoll, which is signed. strtoull (which is
unsigned) would be a better choice.
- this function doesn't check for overflow [minor]
- if a number like 123MB is passed, it is evaluated as 123 instead of
123*1024*1024 [bug]

This suggested me to make the following patch.
Hoping to not offende anybody :-)

BR
G.Baroncelli

Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>

You can pull the patch from 
   http://cassiopea.homelinux.net/git/btrfs-progs-unstable.git
branch
   parse_size


