Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:60068 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3J2WqY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 18:46:24 -0400
Received: by mail-pd0-f182.google.com with SMTP id q10so85545pdj.13
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Oct 2013 15:46:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$d5444$ef292b25$154f150a$c91a6fe4@cox.net>
References: <9c53ka-otf.ln1@hurikhan77.spdns.de>
	<CALJXSJr0sjzFwCT=w1WdDX+-CWS-CjDhYBArVpvTeUNBM88Mdw@mail.gmail.com>
	<pan$d5444$ef292b25$154f150a$c91a6fe4@cox.net>
Date: Tue, 29 Oct 2013 18:46:23 -0400
Message-ID: <CALJXSJoaLrr0gPrMww_MR-5n+_7gmqai1tkvRhwGxNX12weaSA@mail.gmail.com>
Subject: Re: memory leak in <=3.11.6
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 29, 2013 at 12:42 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>
> So I'd call the qgroups feature broken at this time

I agree. I made a page about Quotas on the wiki so to document my
findings as documentation is really sparse. If you consult the section
Known issues, you will find those:

* To get accurate information, you must issue a sync before using the
qgroup show command.
* The qgroup show command is missing some information, for example you
cannot see which subvolume is part of a parent qgroup.
* Creating a qgroup from an existing directory will show a 0 usage
until a full filesystem quota rescan is issued.
* Using btrfs subvolume delete will break qgroup unshared space usage.
* After deleting a subvolume, you must manually delete the associated qgroup.

Knowing this, if you create a qgroup after some files have been added
to a subvolume, those never get accounted for until you rescan the
whole volume. This means that if you manage to delete enough "not
accounted for" files, you get negative numbers.

Wiki: https://btrfs.wiki.kernel.org/index.php/Quota_support
