Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:33810 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240AbbIYMtL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 08:49:11 -0400
Received: by iofb144 with SMTP id b144so109531547iof.1
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 05:49:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55FE0B42.50300@jrs-s.net>
References: <55F88ECC.1040604@menke.ac>
	<55FE0B42.50300@jrs-s.net>
Date: Fri, 25 Sep 2015 08:48:59 -0400
Message-ID: <CAGfcS_=bst0S8YLsr6y4oGDu7Gy-ox9ow5+_nD4c3zFdj-Y6ug@mail.gmail.com>
Subject: Re: BTRFS as image store for KVM?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Jim Salter <jim@jrs-s.net>
Cc: Gert Menke <gert@menke.ac>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 19, 2015 at 9:26 PM, Jim Salter <jim@jrs-s.net> wrote:
>
> ZFS, by contrast, works like absolute gangbusters for KVM image storage.

I'd be interested in what allows ZFS to handle KVM image storage well,
and whether this could be implemented in btrfs.  I'd think that the
fragmentation issues would potentially apply to any COW filesystem,
and if ZFS has a solution for this then it would probably benefit
btrfs to implement the same solution, and not just for VM images.

--
Rich
