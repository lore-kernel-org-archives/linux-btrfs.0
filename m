Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:47859 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaEHRkH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 May 2014 13:40:07 -0400
Received: by mail-lb0-f179.google.com with SMTP id c11so3992275lbj.24
        for <linux-btrfs@vger.kernel.org>; Thu, 08 May 2014 10:40:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140508013440.GH11401@merlins.org>
References: <20140507233959.GB11401@merlins.org>
	<536AD20E.70004@fb.com>
	<20140508004344.GE11401@merlins.org>
	<20140508013440.GH11401@merlins.org>
Date: Thu, 8 May 2014 10:40:05 -0700
Message-ID: <CAKgsxVR=6GTesbtqG_SAyKnpw9pxz1TZ0oOi_MB8Ej3j4-vMiw@mail.gmail.com>
Subject: Re: URGENT: my laptop's boot ssd btrfs crashed, what do you need off it?
From: Justin Maggard <jmaggard10@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 7, 2014 at 6:34 PM, Marc MERLIN <marc@merlins.org> wrote:
> Can btrfs restore be used to navigate the filesystem and look for files and patterns
> without dumping the entire filesystem, which I don't have room for?

On recent versions of btrfs-progs, you can run btrfs restore with both
the verbose and dry-run options to see what it finds, without actually
restoring anything.

-Justin
